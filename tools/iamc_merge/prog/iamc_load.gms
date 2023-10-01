* %1 refers to scenario name

execute_load '%out_dir%/gams_output/gdx_secondary/gdx/%1.gdx'
iamc_load=iamcrgdx,t_int_load=t_int_t;

iamc_merged('%1',Sv,Sr,Sy)  $=iamc_load(Sv,Sr,Sy);
st_int('%1',Sy)             $=t_int_load(Sy);
