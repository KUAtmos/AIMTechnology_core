$if %scen_id%==Baseline     $setglobal scen_name Baseline
$if %scen_id%==NPi500       $setglobal scen_name NPi500

$if %scen_id%==Baseline     $setglobal scen_cpol Baseline
$if %scen_id%==NPi500       $setglobal scen_cpol NPi500

$setglobal startyr          2005
$setglobal endyr            2100
$setglobal interval5        on
$setglobal interval5start   2030
$setglobal ndc_cont         off

$setglobal scen_soceco NA
$setglobal scen_other NA

$if %scen_id%==Baseline     $setglobal input_gdx Baseline
$if %scen_id%==NPi500       $setglobal input_gdx NPi500

$setglobal scen_base Baseline
$setglobal scen_soceco NA
$setglobal scen_techpol NA
$setglobal scen_other NA
