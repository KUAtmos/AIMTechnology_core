$gdxin '%outputdir%/gams_output/gdx_primary/%scen_name%/2030.gdx'
$load emtax_p=emtax
$gdxin

emtax_d2030(MQ)=emtax_p(MQ,'CO2FFI')-smin(MQ2$(emtax_p(MQ2,'CO2FFI')),emtax_p(MQ2,'CO2FFI'));
