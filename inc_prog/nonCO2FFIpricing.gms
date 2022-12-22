CO2FFIprice                         =EQ_GEC.m('FFI','CO2');
emtax('nonFFI','GHG_Kyoto_Gases')   =CO2FFIprice;

if(CO2FFIprice gt 0, 
    Solve Enduse minimizing VTC using LP;
    if(Enduse.modelstat>2,
        year_inf=%calc_year%;
    );
;