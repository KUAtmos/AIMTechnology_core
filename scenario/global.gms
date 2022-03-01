$if %scen_id%==Baseline     $setglobal scen_name Baseline
$if %scen_id%==1000C        $setglobal scen_name 1000C

$if %scen_id%==Baseline     $setglobal scen_cpol Baseline
$if %scen_id%==1000C        $setglobal scen_cpol 1000C

$setglobal startyr  2005
$setglobal endyr    2010

$setglobal ndc_cont     off

$setglobal scen_soceco NA
$setglobal scen_other NA

$if %scen_cpol%==Baseline   $setglobal input_gdx Baseline
$if %scen_cpol%==1000C      $setglobal input_gdx 1000C

$setglobal scen_base Baseline
$setglobal scen_soceco NA
$setglobal scen_techpol NA
$setglobal scen_other NA
