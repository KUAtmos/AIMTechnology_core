$gdxin '%outputdir%/gams_output/gdx_primary/%scen_name%/2030.gdx'
$load emtax_p=eq_gec_m
$gdxin
emtax('%gas_sector%','%gas_type%')$(%calc_year% gt 2030)=emtax_p('%gas_sector%','%gas_type%');
