### NARR three Hourly file preparation

These are for MsTMIP met driver files.

The first step is to convert the time dim from fixed to unlimited so that the files can be concanated together.
The script to use is `lim2unlim.sh` - This takes a single arg - the var-name which is the same as the dir-name.
This step is very disk intensive 
So a typical run would be:


    lim2unlim.sh air.2m
    lim2unlim.sh rhum.2m
    lim2unlim.sh shum.2m
    lim2unlim.sh apcp_rescaled
    lim2unlim.sh dswrf_rescaled_corrected 
    lim2unlim.sh wnd.10m

The next script, `case.sh` handles concatenation of var/year files.
Permutes the dimes from time/lat/lon to lat/lon/time
Appends the the 6 var files to  single one


typical usage:

``sh
    # create concatenations


    case.sh concatenate air.2m
    case.sh concatenate apcp-rescaled
    case.sh concatenate dswrf_rescaled_corrected
    case.sh concatenate rhum.2m
    case.sh concatenate shhum.2m
    case.sh concatenate wnd.10m
    
    #do permutes
    case.sh permute air.2m
    case.sh permute apcp-rescaled
    case.sh permute dswrf_rescaled_corrected
    case.sh permute rhum.2m
    case.sh permute shhum.2m
    case.sh permute wnd.10m

    #do append
    case.sh append
``
