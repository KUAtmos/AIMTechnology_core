$gdxin '%data_dir%/%input_gdx%.gdx'
$load H,I,J,K,L,M,N,O,R,INT,ME,MG,MQ,MR,M_MR,MR_INT,M_MG,M_MQ,M_ME,M_N,M_O,ML,M_ML,MK,M_MK,YEAR,Y5,K_EXRES,ELE_CAP_VRE,L_CAPDEC
$load FL_IL,FL_ILJ,FL_ILK,FL_IK,FL_IJ,FL_INJ,FL_ILO,FL_INTK,FL_INTJ,FL_NOTINT_K,FL_NOTINT_J,FL_DMPG,FL_DMPG2
$load serv_t,ge_t,gas_t,emax_t,emin_t,qmax_t,an_t,en_t,gam_t,sc_base,bn_t,go_t,thmx_t,thmn_t,chmx_t,chmn_t,ommx_t,ommn_t,sgmx_t,sgmn_t,tumx_t,tumn_t,romx_t,romn_t,phi_t,xi_t,scn_t,v_year,alpha,tn,emtax_t,res_end_up,essc,tumx_dec
$gdxin

$evalGlobal.Set start_year YEAR.firsttl

$ifthen.load_prevyr %calc_year%==%start_year%
sc_load(R,I,L,H)$FL_IL(R,I,L)=0;
emax_ex_load(ME,MK)$K_EXRES(MK)=0;
emax_ex_y_load(ME,MK)$K_EXRES(MK)=0;
ve_p(R,I,K)$FL_IK(R,I,K)=0;
vq_p(R,I,M)=0;
vs_p(R,I,L)$FL_IL(R,I,L)=0;
vx_p(R,I,L)$FL_IL(R,I,L)=0;
vr_p(R,I,L)$FL_IL(R,I,L)=0;
vserv_p(R,I,J)$FL_IJ(R,I,J)=0;
res_occ_p(R,I,L)$FL_IL(R,I,L)=0;
res_end_p(MR,INT)$MR_INT(MR,INT)=0;
res_serv_p(R,I,J)$FL_IJ(R,I,J)=0;
dvpg_p(R,I,L,J,dummy2)$FL_ILJ(R,I,L,J)=0;
$else.load_prevyr
$eval prev_year %calc_year%-1
$gdxin '%outputdir%/gams_output/gdx_primary/%scen_name%/%prev_year%.gdx'
$load sc_load=sc,emax_ex_load=emax_ex,emax_ex_y_load=emax_ex_y
$load ve_p=ve_l,vq_p=vq_l,vs_p=vs_l,vx_p=vx_l,vr_p=vr_l,vserv_p=vserv_l,res_occ_p=res_occ_l,res_end_p=res_end_l,res_serv_p=res_serv_l,dvpg_p=dvpg_l
$gdxin
;
$endif.load_prevyr
