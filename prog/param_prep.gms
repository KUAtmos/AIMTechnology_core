$eolcom //

$include '%prog_dir%/scenario/%scen_group%.gms'
$include '%prog_dir%/prog/set.gms'
$include '%prog_dir%/prog/parameters.gms'

$gdxin '%prog_dir%/data/%input_gdx%.gdx'
$load H,YEAR,v_year
$gdxin

Set
    YEAR_C(H) 'years for simulation loop'
;
YEAR_C(YEAR)=yes;
YEAR_C(YEAR)$(v_year(YEAR) gt %endyr%)=no;

file f_year_list /'%outputdir%/data/year_list/%scen_id%.txt'/
    put f_year_list;
    loop(YEAR_C,
        put YEAR_C.tl /);
    putclose f_year_list;

$exit