execute_load '%outputdir%/gams_output/gdx_primary/%scen_name%/%1.gdx'
a,e,cn=cn_t,serv,gam,ge,gas,bn,br,bp,go,phi,xi
scn,ssc=ssc_unload
ve_l0=ve_l,vq_l0=vq_l,vs_l0=vs_l,vx_l0=vx_l,vr_l0=vr_l,vserv_l0=vserv_l,vc_l0=vc_l,vp_l0=vp_l
res_occ_l0=res_occ_l,res_end_l0=res_end_l,eq_eng_m0=eq_eng_m,eq_gec_m0=eq_gec_m,eq_svc_m0=eq_svc_m
tax=tax_t,year_inf,v_year,t_int
;

a_t(R,I,L,J,'%1')$FL_ILJ(R,I,L,J)       =a(R,I,L,J);
e_t(R,I,L,K,'%1')$FL_ILK(R,I,L,K)       =e(R,I,L,K);

serv_t(R,I,J,'%1')$(FL_IJ(R,I,J) and FL_NOTINT_J(J))=serv(R,I,J);
ge_t(R,I,K,'%1')$FL_IK(R,I,K)           =ge(R,I,K);
gas_t(R,I,K,M,'%1')$FL_IK(R,I,K)        =gas(R,I,K,M);
bn_t(R,I,L,'%1')$FL_IL(R,I,L)           =bn(R,I,L);
br_t(R,I,L,L1,'%1')$FL_ILR(R,I,L,L1)    =br(R,I,L,L1);
bp_t(R,I,L,'%1')$FL_RP(R,I,L)           =bp(R,I,L);
go_t(R,I,L,'%1')$FL_IL(R,I,L)           =go(R,I,L);
cn_t(R,I,L,'%1')$FL_IL(R,I,L)           =cn(R,I,L);
phi_t(R,I,L,J,'%1')$FL_ILJ(R,I,L,J)     =phi(R,I,L,J);
xi_t(R,I,L,K,'%1')$FL_ILK(R,I,L,K)      =xi(R,I,L,K);
scn_t(R,I,L,'%1')$FL_IL(R,I,L)          =scn(R,I,L);

ve_l(R,I,K,'%1')$FL_IK(R,I,K)           =ve_l0(R,I,K);
vq_l(R,I,M,'%1')                        =vq_l0(R,I,M);
vs_l(R,I,L,'%1')$FL_IL(R,I,L)           =vs_l0(R,I,L);
vx_l(R,I,L,'%1')$FL_IL(R,I,L)           =vx_l0(R,I,L);
vr_l(R,I,L,'%1')$FL_IL(R,I,L)           =vr_l0(R,I,L);
vc_l(R,I,L,L1,'%1')$FL_ILR(R,I,L,L1)    =sum(H,vc_l0(R,I,L,L1,H));
vp_l(R,I,L,'%1')$FL_RP(R,I,L)           =vp_l0(R,I,L);
vserv_l(R,I,J,'%1')$FL_IJ(R,I,J)        =vserv_l0(R,I,J);
res_occ_l(R,I,L,'%1')$FL_IL(R,I,L)      =res_occ_l0(R,I,L);
res_end_l(MR,INT,'%1')$MR_INT(MR,INT)   =res_end_l0(MR,INT);
eq_eng_m(R,I,K,'%1')$FL_IK(R,I,K)       =eq_eng_m0(R,I,K);
eq_svc_m(R,I,J,'%1')$FL_IJ(R,I,J)       =eq_svc_m0(R,I,J);
eq_gec_m(MQ,MG,'%1')                    =eq_gec_m0(MQ,MG);
tax_t(MQ,MG,'%1')                       =tax(MQ,MG);
ssc_load(R,I,L,H,'%1')$(FL_IL(R,I,L) and v_year(H) le %1) $=ssc(R,I,L,H);
t_int_t('%1')                           =t_int;
