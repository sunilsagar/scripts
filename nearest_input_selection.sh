read -p "Provide Kiosk Monkey damage %age in multiple of 10, eg 10, 20, 30 .. " s

remainder=$(echo "${s} % 10" | bc)
echo $remainder
if [ $remainder -eq '0' ]; then
echo "Great, we will your input, below are the servers"
else
sn=$(awk '{for (i=1; i<=NF; i++) $i = int( ($i+5) / 10) * 10 "%"} 1' <<< "$s")
echo "Will use nearest damage $sn, below are the servers."
fi
