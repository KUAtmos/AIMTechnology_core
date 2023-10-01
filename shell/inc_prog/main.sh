#!/bin/bash -x
set -u

main_parallel_run() {
    for i in "${scen_id[@]}"; do
        echo ${i} > ${prog_dir}/exe/tmp/enduse_main/start/${i}.dat
        echo ${i} started...
        . ${prog_dir}/shell/inc_prog/gms_execute.sh ${i} &
        . ${prog_dir}/shell/inc_prog/check_CPU.sh 10
        done
    }
gms2iamc_parallel_run() {
    for i in "${scen_id[@]}"; do
        rm -f ${prog_dir}/exe/tmp/gms2iamc/start/${scenario}_${i}.dat
        rm -f ${prog_dir}/exe/tmp/gms2iamc/end/${scenario}_${i}.dat
        done
    for i in $(ls ${out_dir}/gams_output/gdx_primary); do
        echo `basename -s .gdx ${i}` > ${prog_dir}/exe/tmp/gms2iamc/start/`basename -s .gdx ${scenario}_${i}`.dat
        echo "Processing result files for" `basename -s .gdx ${i}`
        . ${prog_dir}/shell/inc_prog/gms2iamcexe.sh `basename -s .gdx ${i}` &
        . ${prog_dir}/shell/inc_prog/check_CPU_iamc.sh 3 ${scenario}
        done
    for i in $(ls ${out_dir}/gams_output/gdx_primary); do
        rm -f ${prog_dir}/exe/tmp/gms2iamc/end/${scenario}_${i}.dat
        done
    }

# main program start ------------------------------------------
gams_sys_dir=`which gams --skip-alias|xargs dirname`
echo AIM/Technology-${region}
echo Scenario name: ${scenario}

cd ../
export prog_dir=$PWD
export prog_dir_base=`basename $PWD`

mkdirlist="exe/tmp/enduse_main exe/tmp/enduse_main/start exe/tmp/enduse_main/end exe/tmp/gms2iamc exe/tmp/gms2iamc/start exe/tmp/gms2iamc/end"
for j in ${mkdirlist}; do
    mkdir -p ${j} 2>/dev/null
    rm -r ${j}/* 2>/dev/null
    done

cd ${prog_dir}/exe

export out_dir=${prog_dir}/output/${scenario}/cons

mkdirlist="${prog_dir}/output/${scenario} ${out_dir} ${out_dir}/gams_output ${out_dir}/gams_output/gdx_merged ${out_dir}/gams_output/gdx_primary \
    ${out_dir}/gams_output/gdx_secondary/gdx ${out_dir}/gams_output/gdx_secondary/gdx_trade ${out_dir}/gams_output/gdx_secondary/gdx_ele ${out_dir}/gams_output/gdx_secondary/gdx_misc ${out_dir}/gams_output/gdx_secondary/tech_share \
    ${out_dir}/gams_output/power ${out_dir}/gams_output/check ${out_dir}/gams_output/log ${out_dir}/gams_output/set/year_list \
    ${out_dir}/modelstat ${out_dir}/modelstat/warningmsg ${out_dir}/modelstat/errormsg \
    ${out_dir}/data ${out_dir}/data/year_list ${out_dir}/data/inc \
    ${out_dir}/main ${out_dir}/iiasadb ${out_dir}/plot"
for j in ${mkdirlist}; do mkdir -p ${j} 2>/dev/null; done
for i in "${scen_id[@]}"; do mkdir ${out_dir}/gams_output/log/${i} 2>/dev/null; done

rm -f ${out_dir}/gams_output/set/scenario_list.txt 2>/dev/null
for i in "${scen_id[@]}"; do echo ${i} >> ${out_dir}/gams_output/set/scenario_list.txt; done

# main calculation ------------------------------------------
if [ "${run_parallel}" = "on" ]; then
    main_parallel_run
    else
    for i in "${scen_id[@]}"; do
        . ${prog_dir}/shell/inc_prog/gms_execute.sh ${i}
        echo ...
        done
    fi

# generate iamc template ------------------------------------------
gms2iamc_parallel_run

for i in $(ls ${out_dir}/modelstat/scen_name); do echo `basename -s .txt ${i}` >> ${out_dir}/gams_output/set/scenario_list.txt; done
cat ${out_dir}/modelstat/summary/*.txt > ${out_dir}/modelstat/summary.csv

gams ${prog_dir}/tools/iamc_merge/prog/iamc_merge.gms lo=2 --prog_dir=${prog_dir}/tools/iamc_merge --out_dir=${out_dir} --reg_mode=${region} \
    o=${out_dir}/gams_output/log/iamc_merge.lst logfile=${out_dir}/gams_output/log/iamc_merge.log

read -p "All processes finished."
exit