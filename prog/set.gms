Set
    H                       'Year'
    I                       'sector'
    J                       'service'
    K                       'energy'
    L                       'device'
    M                       'emission gas type'
    N                       'service sub-group for total service share control'
    O                       'service sub-group for individual technology share control'
    R_ALL                   'Region'
    R(R_ALL)                'Region'
    INT                     'internal service and energy'
    ME                      'energy supply constraint group'
    MG                      'emission constraint group by gas'
    MQ                      'emission constraint group by sector-region'
    MR                      'region class for intermediate service balance'
    ML                      'technology group for stock and flow balances'
    MK                      'energy group for energy supply constraint'
    M_MR(R,I,MR)            'sector+region mapping for internal input-output balance'
    MR_INT(MR,INT)          'group of internal input-output balance'
    M_MG(M,MG)              'gas mapping'
    M_MQ(R,I,MQ)            'emission constraint group'
    M_ME(R,I,ME)            'energy supply constraint mapping'
    M_N(L,J,N)              'service sub-group mapping'
    M_O(L,J,O)              'technology mapping for service sub-groups'
    M_ML(ML,L)              'technology group mapping'
    M_MK(MK,K)              'energy group mapping'
    ML_RT(L,L)              'technology retrofit mapping'
    dummy2                  'dummy set for houly power generation' /1,2/
    MAXMIN                  /MAX,MIN/
    YEAR(H)                 'calculation period'
    Y5(H)                   'Year by 5-year step'
    K_EXRES(MK)             'exhaustible resources'
    L_CAPDEC(L)             'devices, maximum capacity decreases during lifetime'
    ELE_CAP_VRE(L)          'VRE capacity'
    FL_IL(R,I,L)
    FL_ILJ(R,I,L,J)
    FL_ILK(R,I,L,K)
    FL_IK(R,I,K)
    FL_IJ(R,I,J)
    FL_INJ(R,I,N,J)
    FL_ILO(R,I,L,O)
    FL_ILR(R,I,L,L)
    FL_INTK(INT,K)
    FL_INTJ(INT,J)
    FL_NOTINT_K(K)
    FL_NOTINT_J(J)
    FL_DMPG(R,I,L,J,L,J)
    FL_DMPG2(R,I,L,J)
    FL_LH(R,L,H)            'technology cohort term'
    FL_RP(R,I,L)            'device replacement mapping'
;
Alias (I,I1),(J,J1),(L,L1),(YEAR,YEAR1,YEAR2),(H,H2),(R,R2,R3),(MR,MR2),(MQ,MQ2)
;