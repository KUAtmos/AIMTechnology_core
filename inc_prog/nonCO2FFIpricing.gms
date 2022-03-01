CO2FFIprice(YEAR)                   =EQ_GEC.m('FFI','CO2');
emtax('nonFFI','GHG_Kyoto_Gases')   =CO2FFIprice(YEAR);

if(CO2FFIprice(YEAR) gt 0, 
    Solve Enduse minimizing VTC using LP;
    Break$(Enduse.modelstat>2);
    year_inf=v_year(YEAR);
    )
;