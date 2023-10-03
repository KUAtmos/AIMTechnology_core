$if %scen_id%==Baseline     $setglobal scen_name Baseline
$if %scen_id%==500C         $setglobal scen_name 500C

$if %scen_id%==Baseline     $setglobal scen_cpol Baseline
$if %scen_id%==500C         $setglobal scen_cpol 500C

$setglobal startyr  2005
$setglobal endyr    2100
$setglobal interval5    on
$setglobal interval5start 2050
$setglobal ndc_cont     off

$setglobal scen_soceco NA
$setglobal scen_other NA

$if %scen_id%==Baseline     $setglobal input_gdx Baseline
$if %scen_id%==500C         $setglobal input_gdx NPi500

$setglobal scen_base Baseline
$setglobal scen_soceco NA
$setglobal scen_techpol NA
$setglobal scen_other NA
