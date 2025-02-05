CO2FFIprice                         =EQ_GEC.m('WOR','CO2FFI');

if(CO2FFIprice gt 0, 
*    emtax('JPN','CO2FFI')           =CO2FFIprice+0.3;
    emtax(MQ,MG)$carpri_add(MQ,MG,'%calc_year%')   =CO2FFIprice+carpri_add(MQ,MG,'%calc_year%')/1000;

    Solve AIMTechnology minimizing VTC using LP;
    if(AIMTechnology.modelstat>2,
        year_inf=%calc_year%;
    );
);