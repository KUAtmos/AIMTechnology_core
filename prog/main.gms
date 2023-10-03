$title AIM/Technology V2.1 main program

$eolcom //

$include '%prog_dir%/scenario/%scen_group%.gms'
$include '%prog_dir%/inc_prog/config.gms'
$setglobal f_interp '%prog_dir%/inc_prog/f_interp.gms'
$setglobal fill_parameter '%prog_dir%/inc_prog/fill_parameter.gms'
$setglobal data_dir '%prog_dir%/data'

$include '%prog_dir%/prog/set.gms'
$include '%prog_dir%/prog/parameters.gms'
$include '%prog_dir%/inc_prog/load_parameter.gms'
$if %CGEiter%==on $include '%prog_dir%/inc_prog/cgeiter.gms'

$batinclude '%prog_dir%/prog/calc.gms' %prog_dir%

$exit