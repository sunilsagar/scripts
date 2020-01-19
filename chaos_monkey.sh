#!/bin/bash

damage=$1

declare chaos_monkey1=(opt1 opt2 opt5 opt10)
declare chaos_monkey2=(opt2 opt4 opt5 opt10)
declare chaos_monkey3=(opt3 opt5 opt6 opt10)
declare chaos_monkey4=(opt4 opt5 opt10)
declare chaos_monkey5=(opt5 opt10)
declare chaos_monkey6=(opt6 opt10)
declare chaos_monkey7=(opt7 opt10)
declare chaos_monkey8=(opt8 opt10)
declare chaos_monkey9=(opt9 opt10)
declare chaos_monkey10=(opt10)

declare damage10_opt1=(sel30 sel10 sel10)
declare damage10_opt2=(sel15 sel5 sel5)
declare damage10_opt5=(sel6 sel2 sel2)
declare damage10_opt10=(sel3 sel1 sel1)
declare damage20_opt2=(sel30 sel10 sel10)
declare damage20_opt4=(sel15 sel5 sel5)
declare damage20_opt5=(sel12 sel4 sel4)
declare damage20_opt10=(sel6 sel2 sel2)
declare damage30_opt3=(sel30 sel10 sel10)
declare damage30_opt5=(sel18 sel6 sel6)
declare damage30_opt6=(sel15 sel5 sel5)
declare damage30_opt10=(sel9 sel3 sel3)
declare damage40_opt4=(sel30 sel10 sel10)
declare damage40_opt5=(sel24 sel8 sel8)
declare damage40_opt10=(sel12 sel4 sel4)
declare damage50_opt5=(sel30 sel10 sel10)
declare damage50_opt10=(sel15 sel5 sel5)
declare damage60_opt6=(sel30 sel10 sel10)
declare damage60_opt10=(sel18 sel6 sel6)
declare damage70_opt7=(sel30 sel10 sel10)
declare damage70_opt10=(sel21 sel7 sel7)
declare damage80_opt8=(sel30 sel10 sel10)
declare damage80_opt10=(sel24 sel8 sel8)
declare damage90_opt9=(sel30 sel10 sel10)
declare damage90_opt10=(sel27 sel9 sel9)
declare damage10_opt10=(sel30 sel10 sel10)

damage_var=$((${damage} / 10 |bc))

chaos_monkey=chaos_monkey$damage_var[@]
echo "${!chaos_monkey}" > /tmp/tmpopt
opt_sel=$(cat /tmp/tmpopt | sed 's/ /\n/g' | shuf -n 1)

echo "$opt_sel"


damage_opt=damage${damage}_${opt_sel}[@]
echo ${!damage_opt}

na_server=$(echo ${!damage_opt} | awk '{print $1}' | sed 's/sel//g')
ap_server=$(echo ${!damage_opt} | awk '{print $2}' | sed 's/sel//g')
em_server=$(echo ${!damage_opt} | awk '{print $3}' | sed 's/sel//g')
echo $na_server
echo $ap_server
echo $em_server

echo "select option in AAAS Activity Option : Chaos_Monkey_$opt_sel"
echo "with below servers, copy and paste them to hosts sections :"
