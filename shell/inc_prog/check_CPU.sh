time_interval=$1

loop_cpu_check() {
    nprocess=0
    start_all=TRUE
    finish_all=TRUE
    for i in "${scen_id[@]}"; do
        if [ -e ${prog_dir}/exe/tmp/enduse_main/start/${i}.dat ]; then
            if [ ! -e ${prog_dir}/exe/tmp/enduse_main/end/${i}.dat ]; then
                nprocess=$(($nprocess+1))
                fi
            fi
        if [ ! -e ${prog_dir}/exe/tmp/enduse_main/start/${i}.dat ]; then
            start_all='FALSE'
            fi
        if [ ! -e ${prog_dir}/exe/tmp/enduse_main/end/${i}.dat ]; then
            finish_all='FALSE'
            fi
        done
    sleep ${time_interval} 
    if [ ${nprocess} -ge ${NCPU} ]; then
        loop_cpu_check
        fi
    if [ "${start_all}" = "TRUE" ]; then
        if [ "${finish_all}" = "FALSE" ]; then
            loop_cpu_check
            fi
        fi
    }

loop_cpu_check