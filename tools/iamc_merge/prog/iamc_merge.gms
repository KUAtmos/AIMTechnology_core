$eolcom //

* load and merge iamc template ---------------------------------------
Set
    Sy      'Year' /1971*2100/
    Sv      'Variable' /
$offlisting
$include '%prog_dir%/../gms2iamc/define/variable.gms'
$onlisting
            /
    Su(Sv)  'Unit' /
$offlisting
$include '%prog_dir%/../gms2iamc/define/unit.gms'
$onlisting
            /
    Sr      'Region'
    Sc      'Scenario' /
$include '%out_dir%/gams_output/set/scenario_list.txt'
            /
    Y5(Sy) /2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
;
Alias(Sc,Sca),(Sr,Sra)
;
Parameter
    iamc_load(Sv,Sr,Sy)                         'iamc template output from each scenario'
    iamc_merged(Sc,Sv,Sr,Sy)                    'iamc merged'
    hist_load(Sv,Sr,Sy)                         'historical data'
    v_y(Sy)
    st_int(Sc,Sy)                               'Time interval'                         
    t_int_load(Sy)                              'Time interval'
;
v_y(Sy)=1970+ord(Sy);

$eval.Set scenario_first Sc.firsttl
$gdxin '%out_dir%/gams_output/gdx_secondary/gdx/%scenario_first%.gdx'
$load Sr=RG
$gdxin

$call sed -e "s/^/\$batinclude '\%prog_dir\%\/prog\/iamc_load.gms' /g" "%out_dir%/gams_output/set/scenario_list.txt" > "%out_dir%/data/inc/merge_scenario.inc"
$include '%out_dir%/data/inc/merge_scenario.inc'

* calculation ---------------------------------------
Set
    St          'execution status'
    Sy2         'simulation end year'
    c1,c2,c3,c4 'scenario categories'
    summary_load(Sc,St<,Sy2<,Sc,c1<,c2<,c3<,c4<) /
$ondelim
$include '%out_dir%/modelstat/summary.csv'
$offdelim
        /
    MSc_base(Sc,Sc)     'baseline scenario mapping'
    MSc_stat(Sc,St)     'scenario status'
    MSc_endyr(Sc,Sy2)   'simulation end year'
    MY5(Sy,Y5)          '5 year mapping'
    var_diff(Sv)        'Variables converted to relative value with baseline scenario' /
$include '%prog_dir%/define/baseline_diff.gms'
        /
    var_5ave(Sv)    'Variables converted to 5 years average' /
$include '%prog_dir%/define/average5.gms'
        /
;
Parameter
    data_all(Sc,Sr,Sv,Sy)   'iamc template for all years'
    iamc_gdx(Sc,Sr,Sv,Y5)   'iamc template for 5 years'
    flg_5(Sc,Sy)            'data flag for 5 year average'
;
flg_5(Sc,Sy)$(v_y(Sy) ge 2005)  =ceil(v_y(Sy)/5)*5;

MSc_base(Sc,Sca)$sum((St,Sy2,c1,c2,c3,c4),summary_load(Sc,St,Sy2,Sca,c1,c2,c3,c4))=yes;
MSc_stat(Sc,St)$sum((Sca,Sy2,c1,c2,c3,c4),summary_load(Sc,St,Sy2,Sca,c1,c2,c3,c4))=yes;
MSc_endyr(Sc,Sy2)$sum((St,Sca,c1,c2,c3,c4),summary_load(Sc,St,Sy2,Sca,c1,c2,c3,c4))=yes;

data_all(Sc,Sr,Sv,Sy)$(not var_diff(Sv))    =iamc_merged(Sc,Sv,Sr,Sy);
data_all(Sc,Sr,Sv,Sy)$var_diff(Sv)          =iamc_merged(Sc,Sv,Sr,Sy)-sum(Sca$MSc_base(Sc,Sca),iamc_merged(Sca,Sv,Sr,Sy));

iamc_gdx(Sc,Sr,Sv,Y5)$(not var_5ave(Sv))    =data_all(Sc,Sr,Sv,Y5);
iamc_gdx(Sc,Sr,Sv,Y5)$(var_5ave(Sv) and sum(Sy$(v_y(Y5) eq flg_5(Sc,Sy)),1))=sum(Sy$(v_y(Y5) eq flg_5(Sc,Sy)),data_all(Sc,Sr,Sv,Sy)*st_int(Sc,Sy))/sum(Sy$(v_y(Y5) eq flg_5(Sc,Sy)),1);

* output ---------------------------------------
execute_unload '%out_dir%/main/merged_output.gdx'
iamc_gdx,data_all
Sc,Sv,Sr,Sy,Su
MSc_stat
MSc_endyr
;
File scen_table /'%out_dir%/main/scenario_table.csv'/
    put scen_table; scen_table.pw=3000; scen_table.pc=5;
    put 'Scenario' 'Status' 'calc_end_year' 'scen_base' 'scen_cpol' 'scen_soceco' 'scen_techpol' 'scen_other';
    loop((Sc,St,Sy2,Sca,c1,c2,c3,c4)$summary_load(Sc,St,Sy2,Sca,c1,c2,c3,c4),
        put / Sc.tl St.tl Sy2.tl Sca.tl c1.tl c2.tl c3.tl c4.tl);
    putclose scen_table
;
