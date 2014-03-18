!#/bin/bash
for var in apcp_rescaled dswrf_rescales_corrected rhum.2m shum.2m wnd.10m; do
    wget -r -nH --cut-dirs=6 ftp://nacp.ornl.gov/synthesis/2009/frescati/model_driver/narr/analysis/${var}/
done