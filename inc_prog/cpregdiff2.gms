CO2FFIprice                         =EQ_GEC.m('WOR','CO2FFI');

emtax_d2030(MQ)=0;
$ife %calc_year%>2030 $include '%1/inc_prog/ndc_cpdiff2.gms'

if(CO2FFIprice gt 0 and v_year('%calc_year%')>2030 and v_year('%calc_year%')<2070, 

    emtax(MQ,'CO2FFI')$sum(R,sameas(R,MQ) and carpri_add(MQ,'CO2FFI','%calc_year%') and v_year('%calc_year%') le 2070)=CO2FFIprice+(emtax_d2030(MQ)+carpri_add(MQ,'CO2FFI','%calc_year%')/1000)*(2070-v_year('%calc_year%'))/(2070-2030);
    emtax(MQ,'CO2FFI')$sum(R,sameas(R,MQ) and not carpri_add(MQ,'CO2FFI','%calc_year%') and v_year('%calc_year%') le 2070)=emtax_d2030(MQ)*(2070-v_year('%calc_year%'))/(2070-2030);
    emtax(MQ,'CO2FFI')$(emtax(MQ,'CO2FFI') lt 0)=0;

    Solve AIMTechnology minimizing VTC using LP;
    if(AIMTechnology.modelstat>2,
        year_inf=%calc_year%;
    );
);
