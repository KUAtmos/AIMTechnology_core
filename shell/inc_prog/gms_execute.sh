scen_id=$1

for i in `cat ${prog_dir}/data/year_list/${scen_id}.txt`; do
     mkdir -p ${out_dir}/gams_output/log/${scen_id} 2>/dev/null
     mkdir -p ${out_dir}/gams_output/gdx_primary/${scen_id} 2>/dev/null
     gams ${prog_dir}/prog/main.gms lo=2 --calc_year=${i} --reg_mode=${region} --prog_dir=${prog_dir} --outputdir=${out_dir} \
          --debug=${debug} --scen_group=${scenario} --scen_id=${scen_id} --Nthreads=${Nthreads} \
          o=${out_dir}/gams_output/log/${scen_id}/${i}.lst logfile=${out_dir}/gams_output/log/${scen_id}/${i}.log
     echo ${i} >> ${out_dir}/gams_output/set/year_list/${scen_id}.txt
     if [ -e ${out_dir}/modelstat/summary/${scen_id}.txt ]; then break; fi
     done

echo ${scen_id} > ${prog_dir}/exe/tmp/enduse_main/end/${scen_id}.dat
