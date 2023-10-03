* output iamc template

$eolcom //

$setglobal scen_id %scen_name%
$include '%prog_dir%/scenario/%scenario%.gms'
$if %reg_mode%==GLOBAL           $setglobal startyr 2005

$include '%prog_dir%/prog/set.gms'
$include '%prog_dir%/prog/parameters.gms'

Set
    ELE_TECH
    ELE_CAP(L)
*    L_EXP                               'L for international trade'
*    K_EXP                               'K for international trade'
    J_EXP
    M_JX(J,J_EXP,R)
*    M_LKX(L,L_EXP,R,K,K_EXP)
*    M_LX(L,L_EXP,R)
*    M_KX(K,K_EXP,R)
    SE_L(I,L)
    SE_K(I,K)
    SE_J(I,J)
    SE_LK(I,L,K)
    SE_LJ(I,L,J)
    J_VRECUR(J)                         'VRE curtailment'
    L_VRECUR(L)                         'VRE curtailment'
    K_PRM2
    J_PG(J)
    L_PG(L)
    ELETYPE
    M_ELEGEN(L_PG,ELETYPE)
    L_HYGGEN(L)
    K_CG(K)
;
Parameter
    ve_l(R,I,K,H)                       'total energy demand'
    vq_l(R,I,M,H)                       'emissions'
    vs_l(R,I,L,H)                       'stock capacity'
    vx_l(R,I,L,H)                       'activity'
    vr_l(R,I,L,H)                       'new installed capacity'
    vc_l(R,I,L,L1,H)                    'retrofit capacity'
    vp_l(R,I,L,H)                       'replaced capacity'
    vserv_l(R,I,J,H)                    'service supply'
    res_occ_l(R,I,L,H)                  'slack variable for operating stock balance'
    res_end_l(MR,INT,H)                 'slack variable for input output balance'
    eq_eng_m(R,I,K,H)                   'Marginal cost of energy demand'
    eq_svc_m(R,I,J,H)                   'Marginal cost of energy supply'
    eq_gec_m(MQ,MG,H)                   'Marginal cost of emissions'
    ve_l0(R,I,K)
    vq_l0(R,I,M)
    vs_l0(R,I,L)
    vx_l0(R,I,L)
    vr_l0(R,I,L)
    vc_l0(R,I,L,L1,H)
    vp_l0(R,I,L)
    vserv_l0(R,I,J)
    res_occ_l0(R,I,L)
    res_end_l0(MR,INT)
    eq_eng_m0(R,I,K)
    eq_svc_m0(R,I,J)
    eq_gec_m0(MQ,MG)
    a_t(R,I,L,J,H)                      'average output coefficient'
    e_t(R,I,L,K,H)                      'average input coefficient'
    cn_t(R,I,L,YEAR)                    'annualized initial cost'
    tax(MQ,MG)                          'emission tax'
    tax_t(MQ,MG,H)                      'emission tax'
    ssc_load(R,I,L,H,H)                 'stock with ages time series'
    t_int_t(H)
;
$gdxin '%prog_dir%/data/%input_gdx%.gdx'
$load H,I,J,K,L,M,N,O,R_ALL,R,INT,ME,MG,MQ,MR,M_MR,MR_INT,M_MG,M_MQ,M_ME,M_N,M_O,ML,M_ML,MK,M_MK,ML_RT,YEAR,Y5,K_EXRES,ELE_CAP_VRE,L_CAPDEC,J_PG,L_PG,ELETYPE,M_ELEGEN,J_VRECUR,J_EXP,M_JX,L_HYGGEN,K_CG
$load FL_IL,FL_ILJ,FL_ILK,FL_IK,FL_IJ,FL_INJ,FL_ILO,FL_ILR,FL_RP,FL_INTK,FL_INTJ,FL_NOTINT_K,FL_NOTINT_J,FL_DMPG,FL_DMPG2
$load v_year,alpha,tn,ind_t
$gdxin

$call sed -e "s/^/\$batinclude '\%prog_dir\%\/tools\/gms2iamc\/prog\/gdx_load.gms' /g" "%outputdir%/gams_output/set/year_list/%scen_name%.txt" > "%outputdir%/data/inc/merge_year_%scen_name%.inc"
$include '%outputdir%/data/inc/merge_year_%scen_name%.inc'

SE_L(I,L)$sum(R,FL_IL(R,I,L))       =yes;
SE_K(I,K)$sum(R,FL_IK(R,I,K))       =yes;
SE_J(I,J)$sum(R,FL_IJ(R,I,J))       =yes;
SE_LK(I,L,K)$sum(R,FL_ILK(R,I,L,K)) =yes;
SE_LJ(I,L,J)$sum(R,FL_ILJ(R,I,L,J)) =yes;

Set
    Y_IAMC(H)/2005*%endyr%/
    Y(Y_IAMC)/2005*%endyr%/;
Y(Y_IAMC)$(v_year(Y_IAMC) gt year_inf or v_year(Y_IAMC) lt %startyr%)=no;
Alias (Y,Y2),(ELE_CAP,ELE_CAP1);

Set
    SE0 'sector aggregation'/
$include '%prog_dir%/tools/gms2iamc/define/sector.gms'
        /
    PE 'primary energy aggregation'/
$include '%prog_dir%/tools/gms2iamc/define/pe_set.gms'
        /
    FE 'final energy aggregation'/
$include '%prog_dir%/tools/gms2iamc/define/fe_set.gms'
        /
    IAMCT_ES 'energy and service supply for iamc template' /
$include '%prog_dir%/tools/gms2iamc/define/es_set.gms'
    /
    PW 'power generation'/
$include '%prog_dir%/tools/gms2iamc/define/pw_set.gms'
        /
;
$include '%prog_dir%/tools/gms2iamc/prog/iamc_inp_global.gms'
Parameter   iamcrgdx(VAR,RG,Y_IAMC);
iamcrgdx(VAR,RG,Y_IAMC)$(iamcr(VAR,RG,Y_IAMC) ne NA)=iamcr(VAR,RG,Y_IAMC);

execute_unload '%outputdir%/gams_output/gdx_secondary/gdx/%scen_name%.gdx'
iamcrgdx,VAR,UNIT,RG,t_int_t;
