CO2FFIprice                         =EQ_GEC.m('WOR','CO2FFI');

$ifthen.ndc_cpconv %NDC2020%==on

emtax_d2030(MQ)=0;
$ife %calc_year%>2030 $include '%1/inc_prog/ndc_cpdiff.gms'

if(CO2FFIprice gt 0 and v_year('%calc_year%')>2030, 

    emtax(MQ,'CO2FFI')$sum(R,sameas(R,MQ) and emtax_d2030(MQ) and v_year('%calc_year%') le 2050)=CO2FFIprice+emtax_d2030(MQ)*(2050-v_year('%calc_year%'))/(2050-2030);
    emtax(MQ,'CO2FFI')$(emtax(MQ,'CO2FFI') lt 0)=0;

    Solve AIMTechnology minimizing VTC using LP;
    if(AIMTechnology.modelstat>2,
        year_inf=%calc_year%;
    );
);

$else.ndc_cpconv

if(CO2FFIprice gt 0, 

    emtax(MQ,MG)$carpri_add(MQ,MG,'%calc_year%')   =CO2FFIprice+carpri_add(MQ,MG,'%calc_year%')/1000;

    Solve AIMTechnology minimizing VTC using LP;
    if(AIMTechnology.modelstat>2,
        year_inf=%calc_year%;
    );
);

$endif.ndc_cpconv
