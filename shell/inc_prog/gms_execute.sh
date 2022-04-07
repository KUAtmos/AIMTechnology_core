scen_id=$1

gams ${prog_dir}/prog/main.gms lo=2 --reg_mode=${region} --prog_dir=${prog_dir} --outputdir=${out_dir} \
     --debug=${debug} --scen_group=${scenario} --scen_id=${scen_id} --Nthreads=${Nthreads} \
     o=${out_dir}/gams_output/log/${scen_id}_main.lst logfile=${out_dir}/gams_output/log/${scen_id}_main.log

echo ${scen_id} > ${prog_dir}/exe/tmp/enduse_main/end/${scen_id}.dat
