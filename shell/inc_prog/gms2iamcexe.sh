scen_id=$1

gams ${prog_dir}/tools/gms2iamc/prog/gms2iamc.gms lo=2 --prog_dir=${prog_dir} --outputdir=${out_dir} --reg_mode=${region} --scen_name=${scen_id} --scenario=${scenario} --endyr=2100 \
    o=${out_dir}/gams_output/log/${scen_id}_iamc.lst logfile=${out_dir}/gams_output/log/${scen_id}_iamc.log
echo $1 > ${prog_dir}/exe/tmp/gms2iamc/end/${scenario}_$1.dat
