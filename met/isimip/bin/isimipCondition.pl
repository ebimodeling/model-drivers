#!/usr/bin/perl 
###########################################################################################################
# options flags
#
# (required) -action list|concatenate|append|convert|rename     
# -m | -model       the model prefix as defined in %MODELS in myConfig.pm
# -s | -scenario    the scenario prefix as defined in %SCENARIOS in myConfig.pm
# -vars             a list of vars to be processed - these are defined in %VARS - for each var there is
#                   1) iName - the netcdf name of the var                             
#                   2) oName - the isimip names - the one we want in the final output file
#                   3) fName - the var prefixed used in the nc file name
#                   4) iUnits - the the units attribute of the var in the nc file
#                   5) oUnits - the requried final units
#
# -D                Output debug information
# -V                vebose output information
#                                  
#  list - the files to be concatenated ( model gfdl / scenario rcp8 )
#  isimipCondition.pl  -action list -s rcp8 -m hadgem -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
#     
#  concatenate - 
#  isimipCondition.pl  -action concatenate -s rcp8 -m hadgem -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
#  ifall goes wellthere should 8 hadgem/rcp8 files located at $OUT/scratch
#
#  reorder and append - 
#  isimipCondition.pl  -action append -m hadgem -s rcp8 -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
#  if all goes well a single all file will be created e.g $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc
#
#  convert - the units of temperature from k(elvin) to Celsius 
#  This applies to vars tasAdjust, tasmaxAdjust,tasminAdjust. This action requries a single nc filename
#  isimipCondition.pl  -action convert $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc
#
#  rename - the vars from short_name to long_name e.g tasAdjust/air_temperature 
#  # rsds/ surface_downwelling_shortwave_flux_in_air, windAdjust / wind_speed
#  isimipCondition.pl  -action rename $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc   
#
#
############################################################################################################
use strict "vars","subs";
use File::Basename;
# assume myConfig.pm in same directory as this file !!
use lib dirname($0);
use myConfig;

# standard Modules
use File::Path;
use File::Copy;
use IO::File;
use File::Glob;
use Getopt::Long qw(:config auto_version);
use Cwd;
use Time::Local;
use Data::Dumper;
# contains MODELS?VARS and other config strings

my $err=0;
my $EXE_PATH=dirname($0);
my $DIR_SCRATCH="$OUT/scratch";
mkdir($DIR_SCRATCH) if ( ! -e $DIR_SCRATCH );


# Option vars
my ($D,$V)=(0,0);
my (@varList)=();
my $Model="";
my $Scenario="";
my $Action="";


my $result = GetOptions(
    'usage|help|?'   => \&Getopt::Long::HelpMessage,
    'V|Verbose+'     => \$V,
    'D|Debug+'       => \$D,
    'vars=s'         => \@varList, 
    'm|Model=s'      => \$Model,
    's|Scenario=s'   => \$Scenario,
    'a|action=s'       => \$Action    
    );

if($D){
    print STDERR << "DBG";
    Options
      Verbose  : $V
      Debug    : $D
      vars     : @varList
      Model    : $Model
      Scenario : $Scenario 
      Action   : $Action  
DBG
}


@varList=split(/,/,$varList[0]) if (scalar @varList);

if( scalar @varList){
   my $lst;
   my $nlst;
       
   # find vars NOT in hash VARS and put them in a list 
   map{ $nlst.=" $_" } grep { not exists $VARS{$_} } @varList;          
   if( $nlst ) {
     map { $lst.="$_ "} keys %VARS;   
     print STDERR "vars:\"$nlst\" not in list $lst\n";     
     $err=1;    
   }
}



# reparse aguments
if( $Model  && !$MODELS{$Model}){
    my $lst;
    map { $lst.="$_ "} keys %MODELS;   
    print STDERR "Model:\"$Model\" not in list $lst\n";
    $err=1;
}

if( $Scenario  && !$SCENARIOS{$Scenario}){
    my $lst;
    map { $lst.="$_ "} keys %SCENARIOS;   
    print STDERR "Scenario:\"$Scenario\" not in list $lst\n";
    $err=1;
}

exit (1) if($err);



if ($Action eq "list"){

    print STDOUT "Action:$Action model($Model) scenario($Scenario)\n" if ($V);

    foreach my $var (@varList){
       my (@Files)=getFiles($var, $Model,$Scenario);
       map { print $_,"\n"; } @Files;       
    }
}



if($Action eq "concatenate") {

 my(@Files)=();
 my $sYear;
 my $eYear;
 my $serr="";
 my $oFile;

   print STDOUT "Action:$Action model($Model) scenario($Scenario)\n" if ($V);

    # loop throu to check for errors in file dates
   foreach my $var (@varList){
      @Files=getFiles($var, $Model,$Scenario);
      ($sYear,$eYear,$serr)=checkFiles(\@Files);    
      if($serr) {
	 print STDERR "$serr";
	 exit(1);
      }

   } 
  
   # loop throu again for real !!   
   foreach my $var (@varList){
      @Files=getFiles($var, $Model,$Scenario);
      # dont need to check serr   
      ($sYear,$eYear,$serr)=checkFiles(\@Files);
      $oFile="$VARS{$var}{'fName'}_$MODELS{$Model}{'fName'}_$SCENARIOS{$Scenario}{'fName'}_$sYear-$eYear.nc"; 
      # add dir name  
      $oFile="$DIR_SCRATCH/$oFile";
      Concatenate($var,$SCENARIOS{$Scenario}{'dir'},\@Files,$oFile);   

   } 
   

}

if ($Action eq "append"){
my $tmpFile;
my (@Files)=();
my $oFile;
my $bYear;
my $eYear;
my $cwd=cwd();
my $ret=0;
my $vcnt=0;

     print STDOUT "Action:$Action model($Model) scenario($Scenario)\n" if ($V);

     chdir("$DIR_SCRATCH" );     

     for( my $idx=0; $idx < scalar @varList ; $idx++){
        my $var=$varList[$idx];  
        if($idx==0){ 
            $tmpFile="$VARS{$var}{'fName'}_$MODELS{$Model}{'fName'}_$SCENARIOS{$Scenario}{'fName'}_????-????.nc";   
            my (@tFiles)=glob("$tmpFile"); 

            if( scalar (@tFiles)==0 ){
               print STDERR "PermuteAppend: unable to locate file concatenation for $var-$tmpFile\n"; 
               exit(1);    
            } 
	    $VARS{$var}{'longName'}=$tFiles[0];
            $vcnt++;   
            
            $bYear=substr($tFiles[0],-12,4);
            $eYear=substr($tFiles[0],-7,4);
            
            next; 
         } 
         $tmpFile="$VARS{$var}{'fName'}_$MODELS{$Model}{'fName'}_$SCENARIOS{$Scenario}{'fName'}_$bYear-$eYear.nc";     

         if( -e "$tmpFile" ){
            # store file in %VAR hash   
	    $VARS{$var}{'longName'}=$tmpFile;
            $vcnt++;  
         }else{                  
           print STDERR "PermuteAppend: unable to locate file-concatenation $var($tmpFile) in scratch directory\n"; 
           exit(1);    
         }   
     }  # end for

         
     if( $vcnt==0 ) {
       print STDERR "PermuteAppend: unable to locate any file-concatenations for the vars \"@varList\n";  
       exit(1); 
     }          

     # create oFile string
     $oFile="all_$MODELS{$Model}{'fName'}_$SCENARIOS{$Scenario}{'fName'}_$bYear-$eYear.nc";         

   
     chdir( $cwd );     
     #make call  
     $ret=PermuteAppend(\@varList,$oFile);   
}

if( $Action eq "rename"){
   # create rename string form -v old-name,new-name
   my $sRename=""; 
   my @varFile=();



   # getOpt::Longs - strips named arguments from @ARGV and leaves file-arguments
   if( scalar(@ARGV) ==0 ) {
     print STDERR "Rename: this action requires a Netcdf filename to be specified on the command-line\n";
     exit(1);   
   }     

   print STDOUT "Action:$Action ncFile($ARGV[0])\n" if ($V);

   if( ! -e "$ARGV[0]" ) {
     print STDERR "Rename: Unable to locate file \"$ARGV[0]\"\n";
     exit(1);   
   }     


   
  @varFile=getVarList($ARGV[0]);     

  if( scalar( @varFile) ==0 ){
    print STDOUT "Rename: No isimip variables in $ARGV[0]n";
    exit(0);   

  }


  # create rename string - see example below
  foreach my $iName (@varFile){
     #get %VAR hash name
     my $v=VARiName2Name($iName);
        $sRename.=" -v $iName,$VARS{$v}{oName}" if ($v);        
  } 

  # make the call and do the deed
  # system("ncrename",$sRename,"$ARGV[0]");
  `ncrename $sRename $ARGV[0]`;
  if ( $? != 0){ 
    print STDERR "Rename: Problem running nco-rename operator\n";  
  }
 

}

# convert the units of tas,tasmin,tasmax form kelvin to Celsius
if( $Action eq "convert"){
   # create rename string form -v old-name,new-name
   my $sRename=""; 
   my @varFile=();



   # getOpt::Longs - strips named arguments from @ARGV and leaves file-arguments
   if( scalar(@ARGV) ==0 ) {
     print STDERR "Convert: this action requires a Netcdf filename to be specified on the command-line\n";
     exit(1);   
   }     

   print STDOUT "Action:$Action ncFile($ARGV[0])\n" if ($V);

   if( ! -e "$ARGV[0]" ) {
     print STDERR "Convert: Unable to locate file \"$ARGV[0]\"\n";
     exit(1);   
   }     
   
  @varFile=getVarList($ARGV[0]);     

  if( scalar( @varFile) ==0 ){
    print STDOUT "Convert: No isimip variables in $ARGV[0]n";
    exit(0);   

  }


  # make the ncap2 call - and change the 
  # nb the arguments here are very important 
  `ncap2 -v -A -C --no_tmp_fl -S $EXE_PATH/ncoConvert.nco "$EXE_PATH/empty.nc" $ARGV[0]`;
  if ( $? != 0){
    print STDERR "Convert: problem encountered running the ncap convert script\n";
    exit(1);  
  } 


}

exit(0); # script end

##########################################################################################################################
#      HELPER FUNCTIONS
##########################################################################################################################


sub PermuteAppend($$){
    my(@varInput)=@{$_[0]};  
    my $oFile=$_[1];
    my $ret=0;
    my %varHash=();
    my @varFile=(); 
    my @varFileP=(); 
    my $cwd=cwd();

    chdir("$DIR_SCRATCH" );     


    # populate hash 
    # explain values 
    # - 0 indicates Var not processed
    # - 1 indicates Var processed or already present in input file     
    map { $varHash{$_}=0 } @varInput;    

    print STDOUT "PermuteAppend: staring: varInput=@varInput\n";
    
    
    # copy file if target doenst exist
    # if(! -e "$oFile") {
    #   # for first var simply copy the first var longName file 
    #   my $tFile= $VARS{$varInput[0]}{'longName'};   
    #   copy ($tFile,$oFile);    
    # }  


    if( -e "$oFile") {   
      @varFileP=getVarList($oFile);  
      print STDERR "PermuteAppend: $oFile exists but doesnt contain any variables\n" && exit(1) if (scalar( @varFileP)==0);         
      map { $varHash{$_}=1  }  map  { VARiName2Name($_) } @varFileP;
    }  
          

    
   foreach my $v (@varInput){
       # check if already processed   
       next if $varHash{$v}==1;
       print STDOUT "PermuteAppend :ncpdq args: iName=$VARS{$v}{'iName'}"," longName=$VARS{$v}{'longName'}","\n" if($D);
       if ( -e "$oFile") {  
          # if file exists than work in append mode - nb only process vars - no coords
          `ncpdq -A -4 --no_tmp_fl -C  -h -a lat,lon,time -v "$VARS{$v}{'iName'}"  "$VARS{$v}{'longName'}"  "$oFile"`;
       }else{
          `ncpdq  -4 --no_tmp_fl  -h -a lat,lon,time -v "$VARS{$v}{'iName'}"  "$VARS{$v}{'longName'}"  "$oFile"`;   
       } 
         
       # mark as prcoesssed    
       #check that an append has really happened   
       @varFile=getVarList($oFile);
       if( scalar (@varFile) == scalar (@varFileP) ){
	   print STDOUT "PermuteAppend :ncpdq - failed to add the var \"$v\" to $oFile\n examine the file with ncdump";
           return 0;  
        
       }  
       @varFileP=@varFile;    
       $varHash{$v}=1; 
       print STDOUT "PermuteAppend :ncpdq successfully added $v to output file\n" if ($V);
   }       

      return 1;

}

sub VARiName2Name($){
   my $iName=$_[0];
   


   foreach (keys %VARS ){       
       return $_ if ( $VARS{$_}{'iName'} eq $iName );
   }     
   return "";
}



# concatenation
sub Concatenate($$$$){
    my $Var=$_[0]; 
    my $Dir=$_[1];
    my @Files= @{$_[2]};
    my $oFile= $_[3];  
    my $cwd=cwd();
    my $bSuccess=0;
    my (@oVars)=();   
    my %ncDims=();
       
    my $tmpFile="$DIR_SCRATCH/$Var.ncrcat.$$.nc";      
   
    chdir( $Dir) ;  
    
    printf( STDOUT "Concatenate: \"$Var\" start %s",  `date +'%F %R'` );               
    print STDOUT "Concatenate: \"$Var\" - ",scalar (@Files), " files to process\n" if($V);
    print STDOUT "Concatenate: \"$Var\" tmp file \"$tmpFile\"\n" if ($V);


    # do the deed
    `ncrcat -O --no_tmp_fl -h -O @Files $tmpFile`;

    $bSuccess=0;
    while( -e $tmpFile  ){ 
        my $stmp; 
        my(@dKeys)=();     
        my ($sFile)=basename ($tmpFile);  
        @oVars=getVarList($tmpFile);      
        %ncDims=getDimHash($tmpFile);  
        @dKeys=keys %ncDims; 
             
        #check var in output file        
        if ( scalar (map{ $Var eq $_   } @oVars) ==0  || scalar(@dKeys)==0 ){
            print STDERR "Concatenate: \"$Var\" not present in file: $sFile\n";   
            last;    
        }  

    

        if( not exists $ncDims{'time'} ){
            print STDERR "Concatenate: \"$Var\" -dimension \"time\"  not present in file: $sFile\n";   
            last;
        }       
           
          

	map { $stmp.="$_($ncDims{$_}) " } @dKeys;
        if ( $ncDims{'time'} <100 ){
            print STDOUT "Concatenate: \"$Var\" warning time dimension very small\n";        
            print STDOUT "Concatenate: \"$Var\" dims - $stmp\n";    
        }         
    
        move($tmpFile, $oFile);     
        print STDOUT "Concatenate: \"$Var\" dims - $stmp\n" if ($V);    
        print STDOUT "Concatenate: \"$Var\" renamed tmp file $oFile\n" if ($V);    

        $bSuccess=1; 
    }       


    if($bSuccess) { 
       printf(STDOUT "Concatenate: \"$Var\" sucessfull: %s\n", `date +'%F %R'` );                 
    }else{         	    
       printf(STDERR "Concatenate: \"$Var\" operation failed: %s\n", `date +'%F %R'` );                 
   }           

    chdir ($cwd); 
    return $bSuccess; 
}



# check end dates on files
# return (minYear,maxYear,err)
# if problem with dates then err is set
sub checkFiles($){
    my(@Files)= @{ $_[0] };
    my ($sYear,$eYear,$pYear,$minYear)=(0,0,0,9999);    


    foreach my $fName (@Files) {   
          
      $sYear=substr($fName,-12,4);
      $eYear=substr($fName,-7,4);
      if( $sYear < $eYear && $sYear > $pYear  ){
        $pYear=$eYear;
        $minYear=$sYear if( $sYear < $minYear);
      }
      else{
        return (0,0,"Year date on files not contiguous or overlap present ! - see $fName\n");          
     }               

    }
   return ($minYear, $eYear,"");  
   
}


# example files 
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2005-2010.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2011-2020.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2021-2030.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2031-2040.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2041-2050.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2051-2060.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2061-2070.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2071-2080.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2081-2090.nc
# wind_bced_1960_1999_hadgem2-es_rcp8p5_2091-2099.nc
sub getFiles($$$){
    # var abbreviation
    my $var=$_[0];
    my $model=$_[1];
    my $scenario=$_[2];
    my $cwd=cwd(); # save current working directory
    my $ncDir= $SCENARIOS{$scenario}{'dir'};
    my(@Files)=();
    my $fstring; 

    # a naughty hack - the filename for hurs_* files DO NOT include sYear-eYear immediatly after the fname
    # so hack it here   
    if( $var eq 'hurs' ){       
        $fstring="$VARS{$var}{'fName'}_$MODELS{$model}{'fName'}_$SCENARIOS{$scenario}{'fName'}_????-????.nc";
    }else{
        $fstring="$VARS{$var}{'fName'}_????_????_$MODELS{$model}{'fName'}_$SCENARIOS{$scenario}{'fName'}_????-????.nc";  
        # $fstring="$VARS{$var}{'fName'}_[0123456789\-]*_$MODELS{$model}{'fName'}_$SCENARIOS{$scenario}{'fName'}_[0123456789\-]*.nc4";  
    }
    # print $fstring;
    # print STDERR "getFiles: Unable to locate \"$model\" directory \"$ncDir\"\n";        
 
    if (-e "$ncDir" ) {
      chdir( "$ncDir" ); 
    }else{
      print STDERR "getFiles: Unable to locate \"$model\" directory \"$ncDir\"\n";     
      return @Files;    
    }

    @Files=sort glob($fstring);
    
    # map { print $_,"\n"; } @Files;       

    chdir($cwd);

    return @Files;
}



sub getVarList($){
  my $ncFile=$_[0];
  my $ncFileTmp="$DIR_SCRATCH/tmp.$$.nc";
  my $ncFileTmp2="$DIR_SCRATCH/tmp.$$.2.nc"; 
  my(@ncVars)=();
  
  my $sTmp;
    
  `ncks --no_tmp_fl -h -C -O -d time,0 -d lat,0 -d lon,0 $ncFile $ncFileTmp`;   
  return @ncVars if (! -e $ncFileTmp);
    
  $sTmp=`ncap2 -v -O --no_tmp_fl -S ${EXE_PATH}/ncoCheck.nco $ncFileTmp $ncFileTmp2`; 
  return @ncVars if(! -e $ncFileTmp2 );

  unlink "$ncFileTmp" if ( -e $ncFileTmp );
  unlink "$ncFileTmp2" if ( -e $ncFileTmp2 );

 
  # var names  are prefixed by '#' to distinguish from other stdout/sterr 
  @ncVars= grep { substr($_,0,1) eq '#' } split(/\n/,$sTmp);
  # remove # prefix                
  @ncVars= map { substr($_,1) } @ncVars;



  return @ncVars;
}


sub getDimHash($){
  my $ncFile=$_[0];
  my $ncFileTmp="$DIR_SCRATCH/tmp.$$.nc";
  my $ncFileTmp2="$DIR_SCRATCH/tmp.$$.2.nc"; 
  my(%ncDims)=();
  
  my $sTmp;
    
  `ncks --no_tmp_fl -h -C -O -v time,lat,lon $ncFile $ncFileTmp`;   
  return %ncDims if (! -e $ncFileTmp);
    
  $sTmp=`ncap2 -v -O --no_tmp_fl -S ${EXE_PATH}/ncoDims.nco $ncFileTmp $ncFileTmp2`; 
  return %ncDims if(! -e $ncFileTmp2 );

  unlink "$ncFileTmp" if ( -e $ncFileTmp );
  unlink "$ncFileTmp2" if ( -e $ncFileTmp2 );

 
  foreach ( split(/\n/,$sTmp) ){      
     my($Dim,$sz)=split(/ /);

     $Dim=substr($Dim,1);   # remove '#' prefix
     $ncDims{$Dim}=$sz;   

  }


 

  return %ncDims;
}
