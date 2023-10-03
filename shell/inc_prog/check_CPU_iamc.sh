time_interval2=$1
Source_scenario=$2

loop_cpu_check2() {
    nprocess2=0
    start_all2=TRUE
    finish_all2=TRUE
    for i in $(ls ${out_dir}/gams_output/gdx_primary); do
        if [ -e ${prog_dir}/exe/tmp/gms2iamc/start/`basename -s .gdx ${Source_scenario}_${i}`.dat ]; then
            if [ ! -e ${prog_dir}/exe/tmp/gms2iamc/end/`basename -s .gdx ${Source_scenario}_${i}`.dat ]; then
                nprocess2=$(($nprocess2+1))
                fi
            fi
        if [ ! -e ${prog_dir}/exe/tmp/gms2iamc/start/`basename -s .gdx ${Source_scenario}_${i}`.dat ]; then
            start_all2='FALSE'
            fi
        if [ ! -e ${prog_dir}/exe/tmp/gms2iamc/end/`basename -s .gdx ${Source_scenario}_${i}`.dat ]; then
            finish_all2='FALSE'
            fi
        done
    sleep ${time_interval2} 
    if [ ${nprocess2} -ge ${NCPU} ]; then
        loop_cpu_check2
        fi
    if [ "${start_all2}" = "TRUE" ]; then
        if [ "${finish_all2}" = "FALSE" ]; then
            loop_cpu_check2
            fi
        fi
    }

loop_cpu_check2
