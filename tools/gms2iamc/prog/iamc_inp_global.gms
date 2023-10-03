Set
    M_S(I,SE0)     'sector aggregation'/
$include '%prog_dir%/tools/gms2iamc/define/sector_global_map.gms'
        /
    PE_MAP(K,PE)    'primary energy mapping'/
$include '%prog_dir%/tools/gms2iamc/define/pe_global_map.gms'
        /
    FE_MAP(K,FE)    'final energy mapping'/
$include '%prog_dir%/tools/gms2iamc/define/fe_global_map.gms'
        /
    ES_MAP(J,IAMCT_ES) 'secondary energy mapping'/
$include '%prog_dir%/tools/gms2iamc/define/es_global_map.gms'
        /
    ES_INP_MAP(K,SE0,IAMCT_ES) 'secondary energy input mapping'/
$include '%prog_dir%/tools/gms2iamc/define/es_inp_global_map.gms'
        /
    PW_MAP(ELETYPE,PW) 'power mapping'/
$include '%prog_dir%/tools/gms2iamc/define/pw_global_map.gms'
        /
    ELE_CAP(L) /
$include '%prog_dir%/tools/gms2iamc/define/pc_global.gms'
    /
    PC_MAP(ELE_CAP,PW) 'power capacity mapping'/
$include '%prog_dir%/tools/gms2iamc/define/pc_global_map.gms'
        /
    VAR 'IAMC database variables (as explanatory text)' /
$include '%prog_dir%/tools/gms2iamc/define/variable.gms'
        /
    UNIT(VAR)   'IAMC database units (as explanatory text)' /
$include '%prog_dir%/tools/gms2iamc/define/unit.gms'
        /
;
Set
    RG /set.R
        World
        R5OECD90+EU 'OECD90 and EU (and EU candidate) countries'
        R5REF       'Countries from the Reforming Ecomonies of the Former Soviet Union'
        R5ASIA      'Asian countries except Japan'
        R5MAF       'Countries of the Middle East and Africa'
        R5LAM       'Latin American countries'
        /
    RG32(RG) /set.R/
    RG5(RG) /R5OECD90+EU,R5REF,R5ASIA,R5MAF,R5LAM/
    M_RG(R,RG) /
$include '%prog_dir%/tools/gms2iamc/define/region_global_map.gms'
        /
    MQ_RG(MQ,RG) /
$include '%prog_dir%/tools/gms2iamc/define/region_global_emiss_map.gms'
        /
    RG_RG(RG,RG) /
$include '%prog_dir%/tools/gms2iamc/define/region_global_agg_map.gms'
        /
;
Alias (RG,RG1)
;
Parameter
    eu2iamc_emi(RG,SE0,M,H)                 'Emissions in kt'
    eu2iamc_prm(R,SE0,PE,H)                 'Primary energy in PJ'
    eu2iamc_fin(R,SE0,FE,H)                 'Final energy in PJ'
    eu2iamc_sec(R,IAMCT_ES,H)               'energy and service output'
    eu2iamc_sec_inp(R,IAMCT_ES,H)           'energy and service input'
    eu2iamc_ele(R,PW,H)                     'Electricity supply in PJ'
    eu2iamc_cap(RG,PW,H)                    'Capacity of power plant in GW'
    eu2iamc_cap_add(RG,PW,H)                'Capacity addition of power plant in GW'
    eu2iamc_eleinv(RG,PW,H)
    eu2iamc_invc(RG,I,H)                    'Investment in million US$'
    eu2iamc_invc_npv(RG,I,H)                'Discounted investment in million US$'
    bn_th(R,I,L,H)                          'initial cost including existing stocks in the simulation start year'
    eu2iamc_invc_ann(RG,I,H)                'Annualized investment in million US$, including existing stocks'
;
eu2iamc_emi(RG,SE0,M,YEAR)              =sum(R$M_RG(R,RG),sum(I$M_S(I,SE0),vq_l(R,I,M,YEAR)));
eu2iamc_prm(R,SE0,PE,YEAR)              =sum(I$M_S(I,SE0),sum(K$(PE_MAP(K,PE) and FL_IK(R,I,K)),ve_l(R,I,K,YEAR)));
eu2iamc_fin(R,SE0,FE,YEAR)              =sum(I$M_S(I,SE0),sum(K$(FE_MAP(K,FE) and FL_IK(R,I,K)),ve_l(R,I,K,YEAR)));
eu2iamc_sec(R,IAMCT_ES,YEAR)            =sum(I,sum(J$(ES_MAP(J,IAMCT_ES) and FL_IJ(R,I,J)),vserv_l(R,I,J,YEAR)));
eu2iamc_sec_inp(R,IAMCT_ES,YEAR)        =sum((I,SE0)$M_S(I,SE0),sum(K$(ES_INP_MAP(K,SE0,IAMCT_ES) and FL_IK(R,I,K)),ve_l(R,I,K,YEAR)));
eu2iamc_ele(R,PW,YEAR)                  =sum(ELETYPE$PW_MAP(ELETYPE,PW),sum(I$sameas(I,'ELE'),sum(L_PG$M_ELEGEN(L_PG,ELETYPE),sum(J_PG$FL_ILJ(R,I,L_PG,J_PG),(1+phi_t(R,I,L_PG,J_PG,YEAR))*a_t(R,I,L_PG,J_PG,YEAR)*vx_l(R,I,L_PG,YEAR)))));
eu2iamc_cap(RG,PW,YEAR)                 =sum(R$M_RG(R,RG),sum(ELE_CAP$PC_MAP(ELE_CAP,PW),sum(I$sameas(I,'ELE'),vs_l(R,I,ELE_CAP,YEAR))));
bn_th(R,I,L,H)$(v_year(H) lt %startyr%) $=bn_t(R,I,L,'%startyr%');
bn_th(R,I,L,H)$(v_year(H) ge %startyr%) $=bn_t(R,I,L,H);
eu2iamc_invc(RG,I,YEAR)                 =sum(R$M_RG(R,RG),sum(L$FL_IL(R,I,L),bn_t(R,I,L,YEAR)*vr_l(R,I,L,YEAR)+bp_t(R,I,L,YEAR)*vp_l(R,I,L,YEAR))+sum((L,L1)$FL_ILR(R,I,L,L1),br_t(R,I,L,L1,YEAR)*vc_l(R,I,L,L1,YEAR)));
eu2iamc_invc_ann(RG,I,YEAR)             =sum(R$M_RG(R,RG),sum(L$FL_IL(R,I,L),sum(H$(v_year(H) le v_year(YEAR)),ssc_load(R,I,L,H,YEAR)*bn_th(R,I,L,H))/tn(R,L)));

Parameter
    gwp(M)/
        CO2e    1
        CO2i    1
        CO2bc   1
        CO2dc   1
        CO2f    1
        CO2l    1
        CO2b    1
        CH4     25
        CH4l    25
        CH4f    25
        N2O     298
        N2Ol    298
        HFC     1430
        PFC     7390
        SF6     22800
        /
;
Parameter
    iamcr(VAR,RG,Y_IAMC);
iamcr(VAR,RG,Y_IAMC)=NA;

Set
    VAR_emi(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_emi_set.gms'
    /
    m_VAR_emi(VAR_emi,SE0,M) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_emi_map.gms'
    /
    VAR_prm(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_prm_set.gms'
    /
    m_VAR_prm(VAR_prm,SE0,PE) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_prm_map.gms'
    /
    VAR_fin(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_fin_set.gms'
    /
    m_VAR_fin(VAR_fin,SE0,FE) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_fin_map.gms'
    /
    VAR_sec(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_sec_set.gms'
    /
    m_VAR_sec(VAR_sec,IAMCT_ES) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_sec_map.gms'
    /
    VAR_sec_inp(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_sec_inp_set.gms'
    /
    m_VAR_sec_inp(VAR_sec_inp,IAMCT_ES) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_sec_inp_map.gms'
    /
    VAR_ele(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_ele_set.gms'
    /
    m_VAR_ele(VAR_ele,PW) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_ele_map.gms'
    /
    VAR_cap(VAR) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_cap_set.gms'
    /
    m_VAR_cap(VAR_cap,PW) /
$include '%prog_dir%/tools/gms2iamc/define/iamc_code/g_cap_map.gms'
    /
;

* Socio-economic --------------------

iamcr('Pop',RG,Y)                           =sum(RG1$RG_RG(RG1,RG),sum(MQ$MQ_RG(MQ,RG1),ind_t(MQ,'Pop',Y)))/1000;
iamcr('GDP_MER',RG,Y)                       =sum(RG1$RG_RG(RG1,RG),sum(MQ$MQ_RG(MQ,RG1),ind_t(MQ,'GDP_MER',Y)))/1000;
iamcr('GDP_PPP',RG,Y)                       =sum(RG1$RG_RG(RG1,RG),sum(MQ$MQ_RG(MQ,RG1),ind_t(MQ,'GDP_PPP',Y)))/1000;
iamcr('Pro_Ste',RG,Y)                       =sum(R$M_RG(R,RG),sum(I$sameas(I,'STL'),serv_t(R,I,'IS_DRV',Y)));
iamcr('Pro_Cem',RG,Y)                       =sum(R$M_RG(R,RG),sum(I$sameas(I,'IYC'),serv_t(R,I,'IYC_DRV',Y)));
iamcr('Ene_Ser_Tra_Fre',RG,Y)               =sum(R$M_RG(R,RG),sum(I$sameas(I,'FRG'),serv_t(R,I,'TFTS',Y)+serv_t(R,I,'TFTL',Y)+serv_t(R,I,'TFRL',Y))); // excluding ship
iamcr('Ene_Ser_Tra_Fre_Avi',RG,Y)           =0;
* iamcr('Ene_Ser_Tra_Fre_Int_Shi',RG,Y)       =;
* iamcr('Ene_Ser_Tra_Fre_Nav',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'FRG'),serv_t(R,I,'TFND',Y)));
iamcr('Ene_Ser_Tra_Fre_Rai',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'FRT'),serv_t(R,I,'TFRL',Y)));
iamcr('Ene_Ser_Tra_Fre_Roa',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'FRR'),serv_t(R,I,'TFTS',Y)+serv_t(R,I,'TFTL',Y)));
* iamcr('Ene_Ser_Tra_Fre_Oth',RG,Y)
iamcr('Ene_Ser_Tra_Pss',RG,Y)               =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPPG',Y)+serv_t(R,I,'TPPD',Y)+serv_t(R,I,'TPBS',Y)+serv_t(R,I,'TPRL',Y)+serv_t(R,I,'TPAD',Y)+serv_t(R,I,'TIAI',Y)));
iamcr('Ene_Ser_Tra_Pss_Avi',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPAD',Y)));
iamcr('Ene_Ser_Tra_Pss_Nav',RG,Y)           =0;
iamcr('Ene_Ser_Tra_Pss_Rai',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPRL',Y)));
iamcr('Ene_Ser_Tra_Pss_Roa',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPPG',Y)+serv_t(R,I,'TPPD',Y)+serv_t(R,I,'TPBS',Y)));
iamcr('Ene_Ser_Tra_Pss_Roa_Bus',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPBS',Y)));
iamcr('Ene_Ser_Tra_Pss_Roa_LDV',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'PSR'),serv_t(R,I,'TPPG',Y)+serv_t(R,I,'TPPD',Y)));
* iamcr('Ene_Ser_Tra_Pss_Roa_2W_and_3W',RG,Y)
* iamcr('Ene_Ser_Tra_Pss_Bic_and_Wal',RG,Y)
* iamcr('Ene_Ser_Tra_Pss_Oth',RG,Y)

* Emissions  ------------

iamcr(VAR_emi,RG,Y)                     =sum((SE0,M)$(gwp(M) AND m_VAR_emi(VAR_emi,SE0,M)),eu2iamc_emi(RG,SE0,M,Y)/gwp(M))/1000;

* Primary Energy and trade --------------------

iamcr(VAR_prm,RG,Y)                     =sum((SE0,PE)$m_VAR_prm(VAR_prm,SE0,PE),sum(R$M_RG(R,RG),eu2iamc_prm(R,SE0,PE,Y)))/1000;
iamcr('Prm_Ene_Coa_wo_CCS',RG,Y)        =iamcr('Prm_Ene_Coa',RG,Y)-iamcr('Prm_Ene_Coa_w_CCS',RG,Y);
iamcr('Prm_Ene_Gas_wo_CCS',RG,Y)        =iamcr('Prm_Ene_Gas',RG,Y)-iamcr('Prm_Ene_Gas_w_CCS',RG,Y);
iamcr('Prm_Ene_Oil_wo_CCS',RG,Y)        =iamcr('Prm_Ene_Oil',RG,Y)-iamcr('Prm_Ene_Oil_w_CCS',RG,Y);

iamcr('Trd_Prm_Ene_Imp_Coa_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'COL'),ve_l(R,I,'COLS1',Y)))/1000;
iamcr('Trd_Prm_Ene_Imp_Gas_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'GAS'),(ve_l(R,I,'NGSS1',Y)+ve_l(R,I,'NGSP1',Y))))/1000;
iamcr('Trd_Prm_Ene_Imp_Oil_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'OIL'),ve_l(R,I,'CRUS1',Y)))/1000;
iamcr('Trd_Prm_Ene_Imp_Bio_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'CRN'),ve_l(R,I,'CRNS2',Y)))/1000;
iamcr('Trd_Sec_Ene_Imp_Liq_Oil_Vol',RG,Y)   =sum(R$M_RG(R,RG),sum(I$sameas(I,'OIL'),ve_l(R,I,'OILS1',Y)))/1000;
iamcr('Trd_Sec_Ene_Imp_Liq_Bio_Vol',RG,Y)   =sum(R$M_RG(R,RG),sum(I$sameas(I,'CRN'),ve_l(R,I,'CRNS1',Y)))/1000;
iamcr('Trd_Sec_Ene_Imp_Amm_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'H_H'),ve_l(R,I,'NH3S1',Y)))/1000;

iamcr('Trd_Prm_Ene_Exp_Coa_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'COL'),sum(J$sum(R2,M_JX(J,'COLR1',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Prm_Ene_Exp_Gas_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'GAS'),sum(J$sum(R2,M_JX(J,'NGSR1',R2)+M_JX(J,'NGSR2',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Prm_Ene_Exp_Bio_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'CRN'),sum(J$sum(R2,M_JX(J,'CRNR2',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Prm_Ene_Exp_Oil_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'OIL'),sum(J$sum(R2,M_JX(J,'CRUR1',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Sec_Ene_Exp_Liq_Oil_Vol',RG,Y)   =sum(R$M_RG(R,RG),sum(I$sameas(I,'OIL'),sum(J$sum(R2,M_JX(J,'OILR1',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Sec_Ene_Exp_Liq_Bio_Vol',RG,Y)   =sum(R$M_RG(R,RG),sum(I$sameas(I,'CRN'),sum(J$sum(R2,M_JX(J,'CRNR1',R2)),vserv_l(R,I,J,Y))))/1000;
iamcr('Trd_Sec_Ene_Exp_Amm_Vol',RG,Y)       =sum(R$M_RG(R,RG),sum(I$sameas(I,'H_H'),sum(J$sum(R2,M_JX(J,'NH3R1',R2)),vserv_l(R,I,J,Y))))/1000;

iamcr('Trd_Prm_Ene_Coa_Vol',RG,Y)           =iamcr('Trd_Prm_Ene_Exp_Coa_Vol',RG,Y)-iamcr('Trd_Prm_Ene_Imp_Coa_Vol',RG,Y);
iamcr('Trd_Prm_Ene_Gas_Vol',RG,Y)           =iamcr('Trd_Prm_Ene_Exp_Gas_Vol',RG,Y)-iamcr('Trd_Prm_Ene_Imp_Gas_Vol',RG,Y);
iamcr('Trd_Prm_Ene_Oil_Vol',RG,Y)           =iamcr('Trd_Prm_Ene_Exp_Oil_Vol',RG,Y)-iamcr('Trd_Prm_Ene_Imp_Oil_Vol',RG,Y);
iamcr('Trd_Prm_Ene_Bio_Vol',RG,Y)           =iamcr('Trd_Prm_Ene_Exp_Bio_Vol',RG,Y)-iamcr('Trd_Prm_Ene_Imp_Bio_Vol',RG,Y);
iamcr('Trd_Sec_Ene_Liq_Bio_Vol',RG,Y)       =iamcr('Trd_Sec_Ene_Exp_Liq_Bio_Vol',RG,Y)-iamcr('Trd_Sec_Ene_Imp_Liq_Bio_Vol',RG,Y);
iamcr('Trd_Sec_Ene_Liq_Oil_Vol',RG,Y)       =iamcr('Trd_Sec_Ene_Exp_Liq_Oil_Vol',RG,Y)-iamcr('Trd_Sec_Ene_Imp_Liq_Oil_Vol',RG,Y);
iamcr('Trd_Sec_Ene_Hyd_Vol',RG,Y)           =iamcr('Trd_Sec_Ene_Exp_Hyd_Vol',RG,Y)-iamcr('Trd_Sec_Ene_Imp_Hyd_Vol',RG,Y);
iamcr('Trd_Sec_Ene_Amm_Vol',RG,Y)           =iamcr('Trd_Sec_Ene_Exp_Amm_Vol',RG,Y)-iamcr('Trd_Sec_Ene_Imp_Amm_Vol',RG,Y);

iamcr('Prm_Ene_Sec_Ene_Trd',RG,Y)           =-iamcr('Trd_Sec_Ene_Liq_Bio_Vol',RG,Y)-iamcr('Trd_Sec_Ene_Amm_Vol',RG,Y);
iamcr('Prm_Ene',RG,Y)                       =iamcr('Prm_Ene',RG,Y)+iamcr('Prm_Ene_Sec_Ene_Trd',RG,Y);

* Final Energy (EJ) --------------------

iamcr(VAR_fin,RG,Y)                     =sum(R$M_RG(R,RG),sum((SE0,FE)$m_VAR_fin(VAR_fin,SE0,FE),eu2iamc_fin(R,SE0,FE,Y)))/1000;

iamcr('Sec_Ene_Inp_Coa_Bla_Fur',RG,Y)   =sum(R$M_RG(R,RG),ve_l(R,'STL','CKK',Y))/1000;

* Secondary Energy --------------------

iamcr(VAR_ele,RG,Y)                     =sum(R$M_RG(R,RG),sum(PW$m_VAR_ele(VAR_ele,PW),eu2iamc_ele(R,PW,Y)))/1000;
iamcr(VAR_sec,RG,Y)                     =sum(R$M_RG(R,RG),sum(IAMCT_ES$m_VAR_sec(VAR_sec,IAMCT_ES),eu2iamc_sec(R,IAMCT_ES,Y)))/1000;
iamcr(VAR_sec_inp,RG,Y)                 =sum(R$M_RG(R,RG),sum(IAMCT_ES$m_VAR_sec_inp(VAR_sec_inp,IAMCT_ES),eu2iamc_sec_inp(R,IAMCT_ES,Y)))/1000;

iamcr('Sec_Ene_Ele_Tra_Los',RG,Y)       =sum(R$M_RG(R,RG),sum(I,vserv_l(R,I,'ET_ELT',Y)+vserv_l(R,I,'ET_ELX',Y)+vserv_l(R,I,'ET_RSC',Y)+vserv_l(R,I,'ET_RSH',Y)+vserv_l(R,I,'ET_SSC',Y)+vserv_l(R,I,'ET_SSH',Y)
                                                               -vserv_l(R,I,'ED_ELD',Y)-vserv_l(R,I,'ED_EXD',Y)-vserv_l(R,I,'ED_RSC',Y)-vserv_l(R,I,'ED_RSH',Y)-vserv_l(R,I,'ED_SSC',Y)-vserv_l(R,I,'ED_SSH',Y)))/1000;
iamcr('Sec_Ene_Ele_Cur',RG,Y)           =sum(R$M_RG(R,RG),sum(J_VRECUR,vserv_l(R,'ELE',J_VRECUR,Y)))/1000;

iamcr('Sec_Ene_Ele_Heat',RG,Y)              =iamcr('Sec_Ene_Ele',RG,Y)+iamcr('Sec_Ene_Heat',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Bio',RG,Y)          =iamcr('Sec_Ene_Ele_Bio',RG,Y)+iamcr('Sec_Ene_Heat_Bio',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Coa',RG,Y)          =iamcr('Sec_Ene_Ele_Coa',RG,Y)+iamcr('Sec_Ene_Heat_Coa',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Gas',RG,Y)          =iamcr('Sec_Ene_Ele_Gas',RG,Y)+iamcr('Sec_Ene_Heat_Gas',RG,Y);
iamcr('Sec_Ene_Ele_Heat_NonBioRen',RG,Y)    =iamcr('Sec_Ene_Ele_NonBioRen',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Nuc',RG,Y)          =iamcr('Sec_Ene_Ele_Nuc',RG,Y)+iamcr('Sec_Ene_Heat_Nuc',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Oil',RG,Y)          =iamcr('Sec_Ene_Ele_Oil',RG,Y)+iamcr('Sec_Ene_Heat_Oil',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Oth',RG,Y)          =iamcr('Sec_Ene_Ele_Oth',RG,Y)+iamcr('Sec_Ene_Heat_Oth',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Bio_w_CCS',RG,Y)    =iamcr('Sec_Ene_Ele_Bio_w_CCS',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Bio_wo_CCS',RG,Y)   =iamcr('Sec_Ene_Ele_Bio_wo_CCS',RG,Y)+iamcr('Sec_Ene_Heat_Bio',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Coa_w_CCS',RG,Y)    =iamcr('Sec_Ene_Ele_Coa_w_CCS',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Coa_wo_CCS',RG,Y)   =iamcr('Sec_Ene_Ele_Coa_wo_CCS',RG,Y)+iamcr('Sec_Ene_Heat_Coa',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Gas_w_CCS',RG,Y)    =iamcr('Sec_Ene_Ele_Gas_w_CCS',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Gas_wo_CCS',RG,Y)   =iamcr('Sec_Ene_Ele_Gas_wo_CCS',RG,Y)+iamcr('Sec_Ene_Heat_Gas',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Geo',RG,Y)          =iamcr('Sec_Ene_Ele_Geo',RG,Y)+iamcr('Sec_Ene_Heat_Geo',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Hyd',RG,Y)          =iamcr('Sec_Ene_Ele_Hyd',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Oil_w_CCS',RG,Y)    =iamcr('Sec_Ene_Ele_Oil_w_CCS',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Oil_wo_CCS',RG,Y)   =iamcr('Sec_Ene_Ele_Oil_wo_CCS',RG,Y)+iamcr('Sec_Ene_Heat_Oil',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Solar',RG,Y)        =iamcr('Sec_Ene_Ele_Solar',RG,Y)+iamcr('Sec_Ene_Heat_Solar',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Win',RG,Y)          =iamcr('Sec_Ene_Ele_Win',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Oce',RG,Y)          =iamcr('Sec_Ene_Ele_Oce',RG,Y);
iamcr('Sec_Ene_Ele_Heat_SolarCSP',RG,Y)     =iamcr('Sec_Ene_Ele_SolarCSP',RG,Y);
iamcr('Sec_Ene_Ele_Heat_SolarPV',RG,Y)      =iamcr('Sec_Ene_Ele_SolarPV',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Win_Off',RG,Y)      =iamcr('Sec_Ene_Ele_Win_Off',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Win_Ons',RG,Y)      =iamcr('Sec_Ene_Ele_Win_Ons',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Fos_w_CCS',RG,Y)    =iamcr('Sec_Ene_Ele_Fos_w_CCS',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Fos_wo_CCS',RG,Y)   =iamcr('Sec_Ene_Ele_Fos_wo_CCS',RG,Y)+iamcr('Sec_Ene_Heat_Coa',RG,Y)+iamcr('Sec_Ene_Heat_Gas',RG,Y)+iamcr('Sec_Ene_Heat_Oil',RG,Y);
iamcr('Sec_Ene_Ele_Heat_Fos',RG,Y)          =iamcr('Sec_Ene_Ele_Heat_Fos_w_CCS',RG,Y)+iamcr('Sec_Ene_Ele_Heat_Fos_wo_CCS',RG,Y);

iamcr('Sec_Ene_Inp_Hyd_Ele',RG,Y)           =sum(R$M_RG(R,RG),ve_l(R,'ELE','HTP',Y))/1000;
iamcr('Sec_Ene_Inp_Hyd_Amm_Ele',RG,Y)       =sum(R$M_RG(R,RG),ve_l(R,'ELE','NH3E',Y))/1000;

iamcr('Sec_Ene_Inp_Ele_Hyd',RG,Y)           =sum(R$M_RG(R,RG),sum(I$sameas(I,'ELE'),sum((L_HYGGEN,K_CG)$FL_ILK(R,I,L_HYGGEN,K_CG),-(1+xi_t(R,I,L_HYGGEN,K_CG,Y))*e_t(R,I,L_HYGGEN,K_CG,Y)*vx_l(R,I,L_HYGGEN,Y))))/1000;

iamcr('Sec_Ene_Inp_Ele_DAC',RG,Y)           =sum(R$M_RG(R,RG),ve_l(R,'CCS','ELCN',Y))/1000;
iamcr('Sec_Ene_Inp_Hyd_DAC',RG,Y)           =sum(R$M_RG(R,RG),ve_l(R,'CCS','H_H',Y))/1000;
iamcr('Sec_Ene_Inp_SolidsBio_DAC',RG,Y)     =sum(R$M_RG(R,RG),ve_l(R,'CCS','CRN',Y))/1000;
iamcr('Sec_Ene_Inp_Gas_Nat_Gas_DAC',RG,Y)   =sum(R$M_RG(R,RG),ve_l(R,'CCS','NGS',Y))/1000;

* Prices --------------------

iamcr('Prc_Car',RG,Y)                       =smax(RG1$RG_RG(RG,RG1),sum(MQ$MQ_RG(MQ,RG1),smax(MG,eq_gec_m(MQ,MG,Y))))*1000;

* Policy cost --------------------

iamcr('Pol_Cos_Add_Tot_Ene_Sys_Cos',RG,Y)   =sum(R$M_RG(R,RG),sum((I,L)$FL_IL(R,I,L),vr_l(R,I,L,Y)*bn_t(R,I,L,Y)+vp_l(R,I,L,Y)*bp_t(R,I,L,Y)+go_t(R,I,L,Y)*vx_l(R,I,L,Y))
                                                                +sum((I,L,L1)$FL_ILR(R,I,L,L1),vc_l(R,I,L,L1,Y)*br_t(R,I,L,L1,Y))
                                                                +sum((I,K)$FL_IK(R,I,K),ge_t(R,I,K,Y)*ve_l(R,I,K,Y)))/1000;

* Carbon sequestration and utilization -----------------------------------------

iamcr('Car_Seq_CCS',RG,Y)                   =sum(R$M_RG(R,RG),sum(I,ve_l(R,I,'CCSE0',Y)+ve_l(R,I,'CCUF0',Y)))/1000; // CCU included
iamcr('Car_Seq_CCS_Fos',RG,Y)               =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCO2F',Y)))/1000;
iamcr('Car_Seq_CCS_Fos_Ene',RG,Y)           =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCO2F',Y)))/1000;
iamcr('Car_Seq_CCS_Fos_Ene_Dem_Ind',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'IND'),ve_l(R,I,'CCO2F',Y)))/1000;
iamcr('Car_Seq_CCS_Fos_Ene_Sup',RG,Y)       =sum(R$M_RG(R,RG),sum(I$M_S(I,'SUP'),ve_l(R,I,'CCO2F',Y)))/1000;
iamcr('Car_Seq_CCS_Fos_Ene_Sup_Ele',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'ELE'),ve_l(R,I,'CCO2F',Y)))/1000;
* iamcr('Car_Seq_CCS_Fos_Ene_Sup_Gas',RG,Y)
iamcr('Car_Seq_CCS_Fos_Ene_Sup_Hyd',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'H_H'),ve_l(R,I,'CCO2F',Y)))/1000;
* iamcr('Car_Seq_CCS_Fos_Ene_Sup_Liq',RG,Y)   
* iamcr('Car_Seq_CCS_Fos_Ene_Sup_Oth',RG,Y)
* iamcr('Car_Seq_CCS_Fos_Ind_Pro',RG,Y)
iamcr('Car_Seq_CCS_Bio',RG,Y)               =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCO2B',Y)))/1000;
iamcr('Car_Seq_CCS_Bio_Ene',RG,Y)           =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCO2B',Y)))/1000;
iamcr('Car_Seq_CCS_Bio_Ene_Dem_Ind',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'IND'),ve_l(R,I,'CCO2B',Y)))/1000;
iamcr('Car_Seq_CCS_Bio_Ene_Sup',RG,Y)       =sum(R$M_RG(R,RG),sum(I$M_S(I,'SUP'),ve_l(R,I,'CCO2B',Y)))/1000;
iamcr('Car_Seq_CCS_Bio_Ene_Sup_Ele',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'ELE'),ve_l(R,I,'CCO2B',Y)))/1000;
* iamcr('Car_Seq_CCS_Bio_Ene_Sup_Gas',RG,Y)
iamcr('Car_Seq_CCS_Bio_Ene_Sup_Hyd',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'H_H'),ve_l(R,I,'CCO2B',Y)))/1000;
iamcr('Car_Seq_CCS_Bio_Ene_Sup_Liq',RG,Y)   =sum(R$M_RG(R,RG),sum(I$M_S(I,'BIM'),ve_l(R,I,'CCO2B',Y)))/1000;
* iamcr('Car_Seq_CCS_Bio_Ene_Sup_Oth',RG,Y)
* iamcr('Car_Seq_CCS_Bio_Ind_Pro',RG,Y)
iamcr('Car_Seq_CCS_Ind_Pro',RG,Y)           =sum(R$M_RG(R,RG),sum(I$M_S(I,'IND'),ve_l(R,I,'CCO2I',Y)))/1000;
iamcr('Car_Seq_Fee',RG,Y)                   =sum(R$M_RG(R,RG),sum(I,ve_l(R,I,'CCUF0',Y)))/1000;
* iamcr('Car_Seq_Fee_Bio',RG,Y)               =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCUB',Y)))/1000;
* iamcr('Car_Seq_Fee_Fos',RG,Y)               =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCUF',Y)+ve_l(R,I,'CCUI',Y)))/1000;
iamcr('Car_Seq_Dir_Air_Cap',RG,Y)           =sum(R$M_RG(R,RG),sum(I$M_S(I,'ENG'),ve_l(R,I,'CCO2A',Y)))/1000;

* Capacity --------------------

iamcr(VAR_cap,RG,Y)                     =sum(PW$m_VAR_cap(VAR_cap,PW),eu2iamc_cap(RG,PW,Y));
iamcr('Cap_Hyd_Ele',RG,Y)               =sum(R$M_RG(R,RG),sum(I$sameas(I,'H_H'),vs_l(R,I,'H2CAP_ELE',Y)));

* Investment --------------------

iamcr('Inv_Add_Ene_Sup',RG,Y)           =sum(I$M_S(I,'SUP'),eu2iamc_invc(RG,I,Y))/1000-sum(I$M_S(I,'CCS'),eu2iamc_invc(RG,I,Y))/1000;
iamcr('Inv_Add_CCS',RG,Y)               =sum(I$M_S(I,'CCS'),eu2iamc_invc(RG,I,Y))/1000;

iamcr('Inv_Ann_Ind',RG,Y)               =sum(I$M_S(I,'IND'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Res_and_Com_Com',RG,Y)   =sum(I$M_S(I,'COM'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Res_and_Com_Res',RG,Y)   =sum(I$M_S(I,'RES'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Tra',RG,Y)               =sum(I$M_S(I,'TRP'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Tra_Pss',RG,Y)           =sum(I$M_S(I,'PSS'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Tra_Fre',RG,Y)           =sum(I$M_S(I,'FRG'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup_Ele',RG,Y)       =sum(I$M_S(I,'ELE'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup',RG,Y)           =sum(I$M_S(I,'SUP'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup_Oil',RG,Y)       =sum(I$M_S(I,'OLR'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup_Coa',RG,Y)       =sum(I$M_S(I,'COK'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup_Nat_Gas',RG,Y)   =sum(I$M_S(I,'GPR'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ene_Sup_Bio',RG,Y)       =sum(I$M_S(I,'BIM'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ind_Ste',RG,Y)           =sum(I$M_S(I,'STL'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ind_Cem',RG,Y)           =sum(I$M_S(I,'CEM'),eu2iamc_invc_ann(RG,I,Y))/1000;
iamcr('Inv_Ann_Ind_Oth',RG,Y)           =sum(I$M_S(I,'XID'),eu2iamc_invc_ann(RG,I,Y))/1000;

