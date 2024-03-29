* Heat
HETC    .(HET,HET_COL)
HETG    .(HET,HET_NGS)
HETO    .(HET,HET_OIL)
HETB    .(HET,HET_BMS)

* Hydrogen
H2P     .(H2,H2_ELE)
H2B     .(H2,H2_BMS,H2_BMS_wo_CCS)
H2BX    .(H2,H2_BMS,H2_BMS_w_CCS)
H2G     .(H2,H2_NGS,H2_NGS_wo_CCS   ,H2_FOS,H2_FOS_wo_CCS)
H2GX    .(H2,H2_NGS,H2_NGS_w_CCS    ,H2_FOS,H2_FOS_w_CCS)
H2C     .(H2,H2_COL,H2_COL_wo_CCS   ,H2_FOS,H2_FOS_wo_CCS)
H2CX    .(H2,H2_COL,H2_COL_w_CCS    ,H2_FOS,H2_FOS_w_CCS)
NH3P    .(H2,H2_ELE                                         ,NH3,NH3_ELE)
NH3B    .(H2,H2_BMS,H2_BMS_wo_CCS                           ,NH3,NH3_BMS,NH3_BMS_wo_CCS)
NH3BX   .(H2,H2_BMS,H2_BMS_w_CCS                            ,NH3,NH3_BMS,NH3_BMS_w_CCS)
NH3G    .(H2,H2_NGS,H2_NGS_wo_CCS   ,H2_FOS,H2_FOS_wo_CCS   ,NH3,NH3_NGS,NH3_NGS_wo_CCS)
NH3GX   .(H2,H2_NGS,H2_NGS_w_CCS    ,H2_FOS,H2_FOS_w_CCS    ,NH3,NH3_NGS,NH3_NGS_w_CCS)
NH3C    .(H2,H2_COL,H2_COL_wo_CCS   ,H2_FOS,H2_FOS_wo_CCS   ,NH3,NH3_COL,NH3_COL_wo_CCS)
NH3CX   .(H2,H2_COL,H2_COL_w_CCS    ,H2_FOS,H2_FOS_w_CCS    ,NH3,NH3_COL,NH3_COL_w_CCS)

* Liquids
OILM2   .(LIQ,LIQ_OIL)
OILM2C  .(LIQ,LIQ_OILC)
CRNL1   .(LIQ,LIQ_BIM)
CRNL1C  .(LIQ,LIQ_BIMC)
CRNL0   .(LIQ,LIQ_BIM1)
SYFM1   .(LIQ,LIQ_SYF)

* Gases
NGSM1G  .(GAS,GAS_NGS)
NGSM2L  .(GAS,GAS_NGS)
SYMM1   .(GAS,GAS_SYM)

* Solids
COLM1   .SOL_COL
CRNM1   .SOL_BIM
