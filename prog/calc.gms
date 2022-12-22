Variables
    VE(R,I,K)               'total energy demand'
    VQ(R,I,M)               'emissions'
    VTC                     'total energy system cost'
;
Positive Variables
    VS(R,I,L)               'stock capacity'
    VX(R,I,L)               'activity'
    VR(R,I,L)               'new installed capacity'
    VD(R,I,J)               'service supply'
    RES_OCC(R,I,L)          'slack variable for operating stock balance'
    RES_END(MR,INT)         'slack variable for input output balance'
    RES_SERV(R,I,J)         'slack variable service demand'
    DVPG(R,I,L,J,dummy2)    'dummy variable for hourly power generation change'
;
Equations
    EQ_SVC(R,I,J)           'service demand calculation'
    EQ_SDC(R,I,J)           'service demand balances'
    EQ_ENG(R,I,K)           'energy balances'
    EQ_ESCMX(ME,MK)         'max energy supply constraint'
    EQ_ESCMN(ME,MK)         'min energy supply constraint'
    EQ_SRCMX(R,I,L,J)       'max service share ratio constraint'
    EQ_SRCMN(R,I,L,J)       'min service share ratio constraint'
    EQ_STGMX(R,I,L,O)       'max service share constraint on technology in service sub-group'
    EQ_STGMN(R,I,L,O)       'min service share constraint on technology in service sub-group'
    EQ_RTCMX(R,I,ML)        'Max installed quantity constraints'
    EQ_RTCMN(R,I,ML)        'Min installed quantity constraints'
    EQ_STCMX(R,I,L)         'Max stock quantity constraints'
    EQ_STCMN(R,I,L)         'Min stock quantity constraints'
    EQ_SGCMX(R,I,N,J)       'Max sub-service group share constraints'
    EQ_SGCMN(R,I,N,J)       'Min sub-service group share constraints'
    EQ_SWCMX(R,I,J)         'Max regional service share constraints'
    EQ_SWCMN(R,I,J)         'Min regional service share constraints'
    EQ_END(MR,INT)          'endgenous service-energy balance'
    EQ_OCC(R,I,L)           'operating capacity condition'
    EQ_STK(R,I,L)           'stock balances'
    EQ_EMISS(R,I,M)         'emissions'
    EQ_GEC(MQ,MG)           'Emission constraint'
    EQ_TCE                  'Total energy system cost'
    EQ_DMPG(R,I,L,J,L1,J1)  'dummy equation for hourly power generation change'
;
EQ_SVC(R,I,J)$FL_IJ(R,I,J)..
    VD(R,I,J) =e= sum(L,(1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L));
    VD.fx(R,I,J)$(not FL_IJ(R,I,J))=0;
EQ_SDC(R,I,J)$FL_NOTINT_J(J)..
    VD(R,I,J) =e= serv(R,I,J)+RES_SERV(R,I,J);
EQ_ENG(R,I,K)$FL_IK(R,I,K)..
    VE(R,I,K) =e= -sum(L,(1+xi(R,I,L,K))*e(R,I,L,K)*VX(R,I,L));
    VE.fx(R,I,K)$(not FL_IK(R,I,K))=0;
EQ_ESCMX(ME,MK)$(emax(ME,MK) ne inf)..
    emax(ME,MK) =g= sum((R,I)$M_ME(R,I,ME),sum(M_MK(MK,K),VE(R,I,K)));
EQ_ESCMN(ME,MK)$emin(ME,MK)..
    emin(ME,MK) =l= sum((R,I)$M_ME(R,I,ME),sum(M_MK(MK,K),VE(R,I,K)));
EQ_RTCMX(R,I,ML)$tumx(R,I,ML)..
    tumx(R,I,ML) =g= sum(L$M_ML(ML,L),VR(R,I,L));
EQ_RTCMN(R,I,ML)$tumn(R,I,ML)..
    tumn(R,I,ML) =l= sum(L$M_ML(ML,L),VR(R,I,L));
EQ_STCMX(R,I,L)$romx(R,I,L)..
    romx(R,I,L) =g= VS(R,I,L);
EQ_STCMN(R,I,L)$romn(R,I,L)..
    romn(R,I,L) =l= VS(R,I,L);
EQ_SRCMX(R,I,L,J)$thmx(R,I,L,J)..
    thmx(R,I,L,J)*VD(R,I,J)  =g= (1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L);
EQ_SRCMN(R,I,L,J)$thmn(R,I,L,J)..
    thmn(R,I,L,J)*VD(R,I,J)  =l= (1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L);
EQ_STGMX(R,I,L,O)$chmx(R,I,L,O)..
    chmx(R,I,L,O)*sum((L1,J)$(M_O(L1,J,O) and FL_ILJ(R,I,L1,J)),(1+phi(R,I,L1,J))*a(R,I,L1,J)*VX(R,I,L1)) =g= sum(J$(M_O(L,J,O) and FL_ILJ(R,I,L,J)),(1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L));
EQ_STGMN(R,I,L,O)$(chmn(R,I,L,O) gt 0)..
    chmn(R,I,L,O)*sum((L1,J)$(M_O(L1,J,O) and FL_ILJ(R,I,L1,J)),(1+phi(R,I,L1,J))*a(R,I,L1,J)*VX(R,I,L1)) =l= sum(J$(M_O(L,J,O) and FL_ILJ(R,I,L,J)),(1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L));
EQ_SGCMX(R,I,N,J)$ommx(R,I,N,J)..
    ommx(R,I,N,J)*VD(R,I,J)  =g= sum((L,J1)$(FL_IL(R,I,L) and M_N(L,J1,N)),(1+phi(R,I,L,J1))*a(R,I,L,J1)*VX(R,I,L));
EQ_SGCMN(R,I,N,J)$(ommn(R,I,N,J) gt 0)..
    ommn(R,I,N,J)*VD(R,I,J)  =l= sum((L,J1)$(FL_IL(R,I,L) and M_N(L,J1,N)),(1+phi(R,I,L,J1))*a(R,I,L,J1)*VX(R,I,L));
EQ_SWCMX(R,I,J)$((sgmx(R,I,J) lt 1) and FL_IJ(R,I,J))..
    sgmx(R,I,J)*sum((R2,I1),sum(L$FL_ILJ(R2,I1,L,J),(1+phi(R2,I1,L,J))*a(R2,I1,L,J)*VX(R2,I1,L))) =g= sum(L$FL_ILJ(R,I,L,J),(1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L));
EQ_SWCMN(R,I,J)$(sgmn(R,I,J) and FL_IJ(R,I,J))..
    sgmn(R,I,J)*sum((R2,I1),sum(L$FL_ILJ(R2,I1,L,J),(1+phi(R2,I1,L,J))*a(R2,I1,L,J)*VX(R2,I1,L))) =l= sum(L$FL_ILJ(R,I,L,J),(1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L));
EQ_END(MR,INT)$MR_INT(MR,INT)..
    sum((R,I,J)$(M_MR(R,I,MR) and FL_IJ(R,I,J) and FL_INTJ(INT,J)),VD(R,I,J)) =e= sum((R,I,K)$(M_MR(R,I,MR) and FL_IK(R,I,K) and FL_INTK(INT,K)),VE(R,I,K))+RES_END(MR,INT);
EQ_OCC(R,I,L)$FL_IL(R,I,L)..
    VX(R,I,L) =e= (1+gam(R,I,L))*(VS(R,I,L)-RES_OCC(R,I,L));
EQ_STK(R,I,L)$FL_IL(R,I,L)..
    VS(R,I,L) =e= sum(H$(v_year(H) le t_y and v_year(H) ge t_y-tn(L)),ssc(R,I,L,H))+VR(R,I,L)*t_int;
EQ_EMISS(R,I,M)..
    VQ(R,I,M) =e= sum(K$FL_IK(R,I,K),gas(R,I,K,M)*VE(R,I,K));
EQ_GEC(MQ,MG)$(qmax(MQ,MG) ne inf)..
    qmax(MQ,MG) =g= sum(M$M_MG(M,MG),sum((R,I)$M_MQ(R,I,MQ),VQ(R,I,M)));
EQ_TCE..
    VTC =e= sum((R,I,L)$FL_IL(R,I,L),VX(R,I,L)*go(R,I,L))
            +sum((R,I,K)$FL_IK(R,I,K),VE(R,I,K)*ge(R,I,K))+sum((R,I,L)$FL_IL(R,I,L),cn(R,I,L)*VR(R,I,L))+sum((R,I,M),VQ(R,I,M)*sum(MG$M_MG(M,MG),sum(MQ$M_MQ(R,I,MQ),emtax(MQ,MG))))
            +sum((R,I,L,J,dummy2)$FL_DMPG2(R,I,L,J),DVPG(R,I,L,J,dummy2))*0.001;
EQ_DMPG(R,I,L,J,L1,J1)$FL_DMPG(R,I,L,J,L1,J1)..
    (1+phi(R,I,L,J))*a(R,I,L,J)*VX(R,I,L)+DVPG(R,I,L,J,'1') =e= (1+phi(R,I,L1,J1))*a(R,I,L1,J1)*VX(R,I,L1)+DVPG(R,I,L1,J1,'2');

Model Enduse/
    EQ_SVC,EQ_SDC,EQ_ENG,
    EQ_ESCMX,EQ_ESCMN,EQ_SRCMX,EQ_SRCMN,EQ_RTCMX,EQ_RTCMN,EQ_STCMX,EQ_STCMN,EQ_SGCMX,EQ_SGCMN,EQ_SWCMX,EQ_SWCMN,EQ_STGMX,EQ_STGMN
    EQ_END,
    EQ_OCC,
    EQ_STK,
    EQ_EMISS,EQ_GEC,
    EQ_TCE
    EQ_DMPG
    /
;
Parameter
    ve_l(R,I,K)         'total energy demand'
    vq_l(R,I,M)         'emissions'
    vs_l(R,I,L)         'stock capacity'
    vx_l(R,I,L)         'activity'
    vr_l(R,I,L)         'new installed capacity'
    vserv_l(R,I,J)      'service supply'
    res_occ_l(R,I,L)    'slack variable for operating stock balance'
    res_och_l(R,I,L,H)  'slack variable for operating stock balance by age group'
    res_end_l(MR,INT)   'slack variable for input output balance'
    res_serv_l(R,I,J)   'slack variable for service demand'
    ssc_unload(R,I,L,H) 'stock with ages time series'
    eq_eng_m(R,I,K)     'Marginal cost of energy'
    eq_svc_m(R,I,J)     'Marginal cost of service'
    eq_occ_m(R,I,L)     'Marginal cost of device operation'
    eq_stk_m(R,I,L)     'Marginal cost of device stock'
    eq_gec_m(MQ,MG)     'Marginal cost of emission'
    eq_rtcmx_m(R,I,ML)  'Marginal cost of new installation'
    cn_t(R,I,L)         'annualized initial cost'
    tax_t(MQ,MG)        'emission tax'
;
* default value
phi(R,I,L,J)$FL_ILJ(R,I,L,J)        =0;
xi(R,I,L,K)$FL_ILK(R,I,L,K)         =0;
serv(R,I,J)$sum(L,FL_ILJ(R,I,L,J))  =0;
sc(R,I,L,H)$FL_IL(R,I,L)            =0;
tax_2030                            =0;
cp_const                            =0;
year_inf                            =%endyr%;

* assign parameters
$batinclude %f_interp% emax 'ME,MK'   emax_t 'ME,MK'    'not K_EXRES(MK)'  
$batinclude %f_interp% a    'R,I,L,J' an_t   'R,I,L,J'  'FL_ILJ(R,I,L,J)'
$batinclude %f_interp% e    'R,I,L,K' en_t   'R,I,L,K'  'FL_ILK(R,I,L,K)'
$batinclude %f_interp% romx 'R,I,L'   romx_t 'R,I,L'    'FL_IL(R,I,L)'
$batinclude %f_interp% romn 'R,I,L'   romn_t 'R,I,L'    'FL_IL(R,I,L)'
$batinclude %f_interp% phi  'R,I,L,J' phi_t  'R,I,L,J'  'FL_ILJ(R,I,L,J)'
$batinclude %f_interp% xi   'R,I,L,K' xi_t   'R,I,L,K'  'FL_ILK(R,I,L,K)'
$batinclude %f_interp% thmx 'R,I,L,J' thmx_t 'R,I,L,J'  'FL_ILJ(R,I,L,J)'
$batinclude %f_interp% thmn 'R,I,L,J' thmn_t 'R,I,L,J'  'FL_ILJ(R,I,L,J)'
$batinclude %f_interp% chmx 'R,I,L,O' chmx_t 'R,I,L,O'  'FL_ILO(R,I,L,O)'
$batinclude %f_interp% chmn 'R,I,L,O' chmn_t 'R,I,L,O'  'FL_ILO(R,I,L,O)'
$batinclude %f_interp% emin 'ME,MK'   emin_t 'ME,MK'    1  
$batinclude %f_interp% ommx 'R,I,N,J' ommx_t 'R,I,N,J'  'FL_INJ(R,I,N,J)'  
$batinclude %f_interp% ommn 'R,I,N,J' ommn_t 'R,I,N,J'  'FL_INJ(R,I,N,J)'
$batinclude %f_interp% sgmx 'R,I,J'   sgmx_t 'R,I,J'    'FL_IJ(R,I,J)'
$batinclude %f_interp% sgmn 'R,I,J'   sgmn_t 'R,I,J'    'FL_IJ(R,I,J)'
$batinclude %f_interp% bn   'R,I,L'   bn_t   'R,I,L'    'FL_IL(R,I,L)'
$batinclude %f_interp% go   'R,I,L'   go_t   'R,I,L'    'FL_IL(R,I,L)'
$batinclude %f_interp% ge   'R,I,K'   ge_t   'R,I,K'    'FL_IK(R,I,K)'
$batinclude %f_interp% gas  'R,I,K,M' gas_t  'R,I,K,M'  'FL_IK(R,I,K)'
$batinclude %f_interp% scn  'R,I,L'   scn_t  'R,I,L'    'FL_IL(R,I,L)'

serv(R,I,J)$(FL_IJ(R,I,J) and FL_NOTINT_J(J))                   =serv_t(R,I,J,'%calc_year%');
gam(R,I,L)$FL_IL(R,I,L)                                         =gam_t(R,I,L,'%calc_year%');
t_y                                                             =%calc_year%;
t_int                                                           =1;
$if %interval5%==on t_int                                       =1+4$(%calc_year% gt 2050);
cn(R,I,L)$FL_IL(R,I,L)                                          =bn(R,I,L)*(1-scn(R,I,L))*alpha(R,I,L)*exp(tn(L)*log(1+alpha(R,I,L)))/(exp(tn(L)*log(1+alpha(R,I,L)))-1)*t_int;
cn_t(R,I,L)$FL_IL(R,I,L)                                        =cn(R,I,L)/t_int;

* update cohort information
age(H)$(%calc_year% gt v_year(H))                               =%calc_year%-v_year(H);
ssc(R,I,L,H)$(%calc_year% eq %start_year% and FL_IL(R,I,L))     =sc_base(R,I,L,H);
ssc(R,I,L,H)$(%calc_year% gt %start_year% and FL_IL(R,I,L))     =sc_load(R,I,L,H);
ssc(R,I,L,H)$(%calc_year% gt %start_year% and FL_IL(R,I,L) and age(H) ge tn(L))=0;

* update maximum installation capacity where maximum stock capacity decreases during the calculation period
essc(R,I,L_CAPDEC,YEAR)$(FL_IL(R,I,L_CAPDEC) and v_year(YEAR) ge %calc_year%)   =sum(H$(v_year(YEAR)-v_year(H) le tn(L_CAPDEC)),ssc(R,I,L_CAPDEC,H));
tumx_dec(R,I,L_CAPDEC)$FL_IL(R,I,L_CAPDEC)                                      =smin(YEAR$(v_year(YEAR) gt %calc_year% and v_year(YEAR) le %calc_year%+tn(L_CAPDEC)),romx_t(R,I,L_CAPDEC,YEAR)-essc(R,I,L_CAPDEC,YEAR))/t_int;
tumx_dec(R,I,L_CAPDEC)$(FL_IL(R,I,L_CAPDEC) and tumx_dec(R,I,L_CAPDEC) le 0)    =eps;

tumx(R,I,ML)$sum(L$M_ML(ML,L),FL_IL(R,I,L))                     =tumx_t(R,I,ML,'%calc_year%');
tumx(R,I,ML)$sum(L_CAPDEC$M_ML(ML,L_CAPDEC),FL_IL(R,I,L_CAPDEC) and tumx_dec(R,I,L_CAPDEC)) =sum(L_CAPDEC$M_ML(ML,L_CAPDEC),tumx_dec(R,I,L_CAPDEC));
tumn(R,I,ML)$sum(L$M_ML(ML,L),FL_IL(R,I,L))                     =tumn_t(R,I,ML,'%calc_year%');

emtax(MQ,MG)                                                    =emtax_t(MQ,MG,'%calc_year%');
$if %ndc_cont%==on emtax('%gas_sector%','%gas_type%')$(%calc_year% gt 2030)=tax_2030;
$if %keep_carpri%==on emtax('%gas_sector%','%gas_type%')$(%calc_year% gt %cp_const_y%)=cp_const;
qmax(MQ,MG)                                                     =qmax_t(MQ,MG,'%calc_year%');
emax_ex(ME,MK)$(K_EXRES(MK) and %calc_year% eq %start_year%)    =emax_t(ME,MK,'%start_year%');
emax(ME,MK)$(K_EXRES(MK) and %calc_year% eq %start_year%)       =emax_t(ME,MK,'%start_year%');
emax_ex(ME,MK)$(K_EXRES(MK) and %calc_year% gt %start_year%)    =emax_ex_load(ME,MK);
emax(ME,MK)$(K_EXRES(MK) and %calc_year% gt %start_year%)       =emax_ex_y_load(ME,MK);

* bound settings

RES_END.up(MR,INT)$MR_INT(MR,INT)                               =res_end_up(MR,INT,'%calc_year%');
RES_OCC.fx(R,'ELE',ELE_CAP_VRE)                                 =0;
$if %reg_mode%==GLOBAL  VE.lo(R,I,K)$FL_IK(R,I,K)               =0;
$if %reg_mode%==JPN     VE.lo(R,I,K)$FL_NOTINT_K(K)             =0;
$if %reg_mode%==JPN     VE.lo(R,'CCS','T_OIL')                  =-inf;
VE.lo(R,'H_H','CCUM0')                                          =-inf;


* optimization

Enduse.holdfixed    =1;
Solve Enduse minimizing VTC using LP;
if(Enduse.modelstat>2,
    year_inf=%calc_year%;
);
$if %nonCO2pricing%==on $include '%1/inc_prog/nonCO2FFIpricing.gms'


* output parameters

sc(R,I,L,H)$FL_IL(R,I,L)            =ssc(R,I,L,H);
sc(R,I,L,'%calc_year%')$FL_IL(R,I,L)=VR.l(R,I,L)+ssc(R,I,L,'%calc_year%')$(%calc_year% eq %start_year%);
$if %interval5%==on sc(R,I,L,H)$(FL_IL(R,I,L) and %calc_year% gt 2050 and v_year(H) le %calc_year% and v_year(H) gt %calc_year%-5)=VR.l(R,I,L);
ve_l(R,I,K)$FL_IK(R,I,K)            =VE.l(R,I,K);
vq_l(R,I,M)                         =VQ.l(R,I,M);
vs_l(R,I,L)$FL_IL(R,I,L)            =VS.l(R,I,L);
vx_l(R,I,L)$FL_IL(R,I,L)            =VX.l(R,I,L);
vr_l(R,I,L)$FL_IL(R,I,L)            =VR.l(R,I,L);
vserv_l(R,I,J)$FL_IJ(R,I,J)         =VD.l(R,I,J);
res_occ_l(R,I,L)$FL_IL(R,I,L)       =RES_OCC.l(R,I,L);
res_end_l(MR,INT)$MR_INT(MR,INT)    =RES_END.l(MR,INT);
res_serv_l(R,I,J)$FL_IJ(R,I,J)      =RES_SERV.l(R,I,J);
ssc_unload(R,I,L,H)$(FL_IL(R,I,L) and v_year(H) le %calc_year%) $=ssc(R,I,L,H);
eq_eng_m(R,I,K)$FL_IK(R,I,K)        =EQ_ENG.m(R,I,K);
eq_svc_m(R,I,J)$FL_IJ(R,I,J)        =EQ_SVC.m(R,I,J);
eq_occ_m(R,I,L)$FL_IL(R,I,L)        =EQ_OCC.m(R,I,L);
eq_stk_m(R,I,L)$FL_IL(R,I,L)        =EQ_STK.m(R,I,L);
eq_gec_m(MQ,MG)                     =EQ_GEC.m(MQ,MG);
eq_rtcmx_m(R,I,ML)$sum(M_ML(ML,L),FL_IL(R,I,L)) =EQ_RTCMX.m(R,I,ML); 
tax_t(MQ,MG)                        =emtax(MQ,MG);
$if %ndc_cont%==on tax_2030$(%calc_year% eq 2030)              =smax((MQ,MG),eq_gec_m(MQ,MG)); 
$if %keep_carpri%==on cp_const$(%calc_year% eq %cp_const_y%)   =smax((MQ,MG),eq_gec_m(MQ,MG)); 
vsw(R,I,L)$FL_IL(R,I,L)             =VS.l(R,I,L)-VR.l(R,I,L)*t_int;
vswr(R,I,L)$FL_IL(R,I,L)            =VS.l(R,I,L);

* update exhaustible resources potential
emax_ex(ME,MK)$K_EXRES(MK)          =max(0,emax_ex(ME,MK)-sum(M_MK(MK,K),sum((R,I)$(M_ME(R,I,ME) and FL_IK(R,I,K)),VE.l(R,I,K)))*t_int);
emax_ex_y(ME,MK)$K_EXRES(MK)        =emax_ex(ME,MK)/t_int;


* output scenario solution summary

file out_stat /'%outputdir%/modelstat/summary/%scen_id%.txt'/
if(year_inf lt %endyr%, 
    put out_stat;
    put '%scen_name%,Infeasible,' year_inf:4:0 ',%scen_base%,%scen_cpol%,%scen_soceco%,%scen_techpol%,%scen_other%';
    putclose out_stat;
    );
if(%calc_year% eq %endyr%, 
    put out_stat;
    put '%scen_name%,Optimal,' year_inf:4:0 ',%scen_base%,%scen_cpol%,%scen_soceco%,%scen_techpol%,%scen_other%';
    putclose out_stat;
    );

* output primary result file

execute_unload '%outputdir%/gams_output/gdx_primary/%scen_name%/%calc_year%.gdx'
$include '%prog_dir%/inc_prog/gdxoutparam.gms'
;