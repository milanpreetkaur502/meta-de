#!/bin/sh

vnstat -i wwan0 --add
systemctl restart vnstat

OUTFILE="/tmp/devicestats"
BATTFILE="/tmp/battery_parameters"
LUXFILE="/tmp/light_intensity"
WEATHERFILE="/tmp/met"

function general_info () {
    # reading board serial number and deleting any null character in it
    printf "General info\n"
    BRD_SERIAL_NUM=$(tr -d '\0' </sys/firmware/devicetree/base/serial-number)
} # done

function get_cpu () {
    printf "Cpu info\n"
    CORE_A53_TEMP=$(echo "scale=2 ; $(cat /sys/class/thermal/thermal_zone0/temp) / 1000" | bc -l)
    CORE_A72_TEMP=$(echo "scale=2 ; $(cat /sys/class/thermal/thermal_zone1/temp) / 1000" | bc -l)

    case $1 in
        _A53_0) CPU_USAGE_A53_0=$(printf %.3f $(echo "100-((($ID2_0-$ID1_0) * 100) / ($US2_0-$US1_0+$NI2_0-$NI1_0+$SY2_0-$SY1_0+$ID2_0-$ID1_0+$IO2_0-$IO1_0+$IR2_0-$IR1_0+$SO2_0-$SO1_0+$ST2_0-$ST1_0+$GU2_0-$GU1_0+$GN2_0-$GN1_0))" | bc -l ));;
        _A53_1) CPU_USAGE_A53_1=$(printf %.3f $(echo "100-((($ID2_1-$ID1_1) * 100) / ($US2_1-$US1_1+$NI2_1-$NI1_1+$SY2_1-$SY1_1+$ID2_1-$ID1_1+$IO2_1-$IO1_1+$IR2_1-$IR1_1+$SO2_1-$SO1_1+$ST2_1-$ST1_1+$GU2_1-$GU1_1+$GN2_1-$GN1_1))" | bc -l ));;
        _A53_2) CPU_USAGE_A53_2=$(printf %.3f $(echo "100-((($ID2_2-$ID1_2) * 100) / ($US2_2-$US1_2+$NI2_2-$NI1_2+$SY2_2-$SY1_2+$ID2_2-$ID1_2+$IO2_2-$IO1_2+$IR2_2-$IR1_2+$SO2_2-$SO1_2+$ST2_2-$ST1_2+$GU2_2-$GU1_2+$GN2_2-$GN1_2))" | bc -l ));;
        _A53_3) CPU_USAGE_A53_3=$(printf %.3f $(echo "100-((($ID2_3-$ID1_3) * 100) / ($US2_3-$US1_3+$NI2_3-$NI1_3+$SY2_3-$SY1_3+$ID2_3-$ID1_3+$IO2_3-$IO1_3+$IR2_3-$IR1_3+$SO2_3-$SO1_3+$ST2_3-$ST1_3+$GU2_3-$GU1_3+$GN2_3-$GN1_3))" | bc -l ));;
        _A72_0) CPU_USAGE_A72_0=$(printf %.3f $(echo "100-((($ID2_4-$ID1_4) * 100) / ($US2_4-$US1_4+$NI2_4-$NI1_4+$SY2_4-$SY1_4+$ID2_4-$ID1_4+$IO2_4-$IO1_4+$IR2_4-$IR1_4+$SO2_4-$SO1_4+$ST2_4-$ST1_4+$GU2_4-$GU1_4+$GN2_4-$GN1_4))" | bc -l ));;
        _A72_1) CPU_USAGE_A72_1=$(printf %.3f $(echo "100-((($ID2_5-$ID1_5) * 100) / ($US2_5-$US1_5+$NI2_5-$NI1_5+$SY2_5-$SY1_5+$ID2_5-$ID1_5+$IO2_5-$IO1_5+$IR2_5-$IR1_5+$SO2_5-$SO1_5+$ST2_5-$ST1_5+$GU2_5-$GU1_5+$GN2_5-$GN1_5))" | bc -l ));;
        *) CPU_USAGE=$(printf %.3f $(echo "100-((($ID2-$ID1) * 100) / ($US2-$US1+$NI2-$NI1+$SY2-$SY1+$ID2-$ID1+$IO2-$IO1+$IR2-$IR1+$SO2-$SO1+$ST2-$ST1+$GU2-$GU1+$GN2-$GN1))" | bc -l ));;
    esac
} # done

function get_gpu () {
    printf "Gpu info\n"
    # calculate GPU temperatures
    GPU_0_TEMP=$(echo "scale=2 ; $(cat /sys/class/thermal/thermal_zone2/temp) / 1000" | bc -l)
    GPU_1_TEMP=$(echo "scale=2 ; $(cat /sys/class/thermal/thermal_zone3/temp) / 1000" | bc -l)

    # calculate GPU metrics
    local GPU_FREE=$(cat /sys/kernel/debug/gc/meminfo | awk 'NR == 3 {print $3}')
    local GPU_USED=$(cat /sys/kernel/debug/gc/meminfo | awk 'NR == 4 {print $3}')
    local GPU_TOTAL=$(cat /sys/kernel/debug/gc/meminfo | awk 'NR == 7 {print $3}')

    local GPU_PERCENT_TMP=$(echo "( $GPU_USED / $GPU_TOTAL ) * 100 " | bc -l) # temporary variable
    GPU_USAGE=$(printf %.3f $GPU_PERCENT_TMP)
} # done

function get_ram () {
    printf "Ram info\n"
    # calculate RAM metrics
    RAM_TOTAL=$(printf %.3f $(echo "$(free | awk 'NR == 2 {print $2}') / (1024*1024)" | bc -l))
    RAM_FREE=$(printf %.3f $(echo "$(free | awk 'NR == 2 {print $4}') / (1024*1024)" | bc -l))
    local RAM_USED=$(printf %.3f $(echo "$(free | awk 'NR == 2 {print $3}') / (1024*1024)" | bc -l))
    local RAM_SHARED=$(printf %.3f $(echo "$(free | awk 'NR == 2 {print $5}') / (1024*1024)" | bc -l))
    local RAM_CACHE=$(printf %.3f $(echo "$(free | awk 'NR == 2 {print $6}') / (1024*1024)" | bc -l))

    local TMP=$(echo "( ( $RAM_USED + $RAM_SHARED + $RAM_CACHE ) / $RAM_TOTAL ) * 100 " | bc -l) # temporary variable
    RAM_USAGE=$(printf %.3f $TMP)
} # done

function get_connectivity () {
    printf "Internet info\n"
    # check internet connectivity
#     wget -q --spider http://google.com 

#     if [ $? -eq 0 ]; then 
    local TMP=$(cat /tmp/netstatus)
    if [ $TMP = "connected" ]; then
        NETWORK_CONNECTED="true"
    else
        NETWORK_CONNECTED="false"
    fi 

    # get signal value
    NETWORK_SIGNAL=$(mmcli -m 0 | awk '/signal quality/ {print $4}') 
    NETWORK_SIGNAL=${NETWORK_SIGNAL::-1}
} # done

function get_data () {
    printf "Data info\n"
    # get usage for ethernet
    DATA_ETH0_RX=$(printf %.3f $(echo "$(vnstat -i eth0 --xml m | awk -F'[<>]' '/<total>/ {print $5}') / (1024*1024)" | bc -l))
    DATA_ETH0_TX=$(printf %.3f $(echo "$(vnstat -i eth0 --xml m | awk -F'[<>]' '/<total>/ {print $9}') / (1024*1024)" | bc -l))

    # get usage for wwan
    # bug if iterface not found will throw a error on stderr and variables will remain empty
    DATA_WWAN0_RX=$(printf %.3f $(echo "$(vnstat -i wwan0 --xml m | awk -F'[<>]' '/<total>/ {print $5}') / (1024*1024)" | bc -l))
    DATA_WWAN0_TX=$(printf %.3f $(echo "$(vnstat -i wwan0 --xml m | awk -F'[<>]' '/<total>/ {print $9}') / (1024*1024)" | bc -l))
} # done

function get_power () {
    printf "Power info\n"
    if [ -f "${BATTFILE}" ]; then
        if [ $(wc -l ${BATTFILE} | awk 'NR == 1 {print $1}') -eq 5 ]; then
            BATT_TEMP=$(cat ${BATTFILE} | awk -F':' 'NR == 3 {print $2}' | tr -d '",')
        
            local TMP=$(echo "$(cat ${BATTFILE} | awk -F':' 'NR == 2 {print $2}' | tr -d '",') / 1000" | bc -l) # temporary variable
            BATT_VOLTAGE=$(printf %.3f $TMP)

            # local TMP=$(echo "$(cat ${BATTFILE} | awk 'NR == 3 {print $4}') / 1000" | bc -l) # temporary variable
            # BATT_AVG_CURRENT=$(printf %.3f $TMP)

            local TMP=$(echo "$(cat ${BATTFILE} | awk -F':' 'NR == 4 {print $2}' | tr -d '",') / 1000" | bc -l) # temporary variable
            BATT_CURRENT=$(printf %.3f $TMP)
        else
            printf "${BATTFILE} lines not equal to 5\n"
            BATT_TEMP=-1
            BATT_VOLTAGE=-1
            BATT_AVG_CURRENT=-1
            BATT_CURRENT=-1
        fi
    else
        printf "${BATTFILE} not found\n"
        BATT_TEMP=-1
        BATT_VOLTAGE=-1
        BATT_AVG_CURRENT=-1
        BATT_CURRENT=-1
    fi
} # done

function get_weather () {
    printf "Weather info\n"
    if [ -f "${LUXFILE}" ]; then
        W_LUX=$(cat ${LUXFILE} | awk -F':' 'NR == 2 {print $2}' | tr -d '",')
    else
        printf "${LUXFILE} not found"
        W_LUX=-1
    fi

    if [ -f "${WEATHERFILE}" ]; then
        W_TEMPERATURE=$(cat ${WEATHERFILE} | awk -F':' 'NR == 3 {print $2}' | tr -d '",')
        W_HUMIDITY=$(cat ${WEATHERFILE} | awk -F':' 'NR == 2 {print $2}' | tr -d '",')
    else
        printf "${WEATHERFILE} not found"
        W_TEMPERATURE=-1
        W_HUMIDITY=-1
    fi

} # done

while true; do

    # taking reading at one instant for cpu usage
    #overall
    read -r VAL US1 NI1 SY1 ID1 IO1 IR1 SO1 ST1 GU1 GN1 <<< $(head -1 /proc/stat)
    #cpu0
    read -r VAL US1_0 NI1_0 SY1_0 ID1_0 IO1_0 IR1_0 SO1_0 ST1_0 GU1_0 GN1_0 <<< $(head -2 /proc/stat | tail -1)
    #cpu1
    read -r VAL US1_1 NI1_1 SY1_1 ID1_1 IO1_1 IR1_1 SO1_1 ST1_1 GU1_1 GN1_1 <<< $(head -3 /proc/stat | tail -1)
    #cpu2
    read -r VAL US1_2 NI1_2 SY1_2 ID1_2 IO1_2 IR1_2 SO1_2 ST1_2 GU1_2 GN1_2 <<< $(head -4 /proc/stat | tail -1)
    #cpu3
    read -r VAL US1_3 NI1_3 SY1_3 ID1_3 IO1_3 IR1_3 SO1_3 ST1_3 GU1_3 GN1_3 <<< $(head -5 /proc/stat | tail -1)
    #cpu4
    read -r VAL US1_4 NI1_4 SY1_4 ID1_4 IO1_4 IR1_4 SO1_4 ST1_4 GU1_4 GN1_4 <<< $(head -6 /proc/stat | tail -1)
    #cpu5
    read -r VAL US1_5 NI1_5 SY1_5 ID1_5 IO1_5 IR1_5 SO1_5 ST1_5 GU1_5 GN1_5 <<< $(head -7 /proc/stat | tail -1)
     

    general_info
    get_gpu
    get_ram
    get_connectivity
    get_data
    get_power
    get_weather

    sleep 9
    # taking reading again after 10 secs
    #overall
    read -r VAL US2 NI2 SY2 ID2 IO2 IR2 SO2 ST2 GU2 GN2 <<< $(head -1 /proc/stat)
    #cpu0
    read -r VAL US2_0 NI2_0 SY2_0 ID2_0 IO2_0 IR2_0 SO2_0 ST2_0 GU2_0 GN2_0 <<< $(head -2 /proc/stat | tail -1)
    #cpu1
    read -r VAL US2_1 NI2_1 SY2_1 ID2_1 IO2_1 IR2_1 SO2_1 ST2_1 GU2_1 GN2_1 <<< $(head -3 /proc/stat | tail -1)
    #cpu2
    read -r VAL US2_2 NI2_2 SY2_2 ID2_2 IO2_2 IR2_2 SO2_2 ST2_2 GU2_2 GN2_2 <<< $(head -4 /proc/stat | tail -1)
    #cpu3
    read -r VAL US2_3 NI2_3 SY2_3 ID2_3 IO2_3 IR2_3 SO2_3 ST2_3 GU2_3 GN2_3 <<< $(head -5 /proc/stat | tail -1)
    #cpu4
    read -r VAL US2_4 NI2_4 SY2_4 ID2_4 IO2_4 IR2_4 SO2_4 ST2_4 GU2_4 GN2_4 <<< $(head -6 /proc/stat | tail -1)
    #cpu5
    read -r VAL US2_5 NI2_5 SY2_5 ID2_5 IO2_5 IR2_5 SO2_5 ST2_5 GU2_5 GN2_5 <<< $(head -7 /proc/stat | tail -1)

    get_cpu ""
    get_cpu "_A53_0"
    get_cpu "_A53_1"
    get_cpu "_A53_2"
    get_cpu "_A53_3"
    get_cpu "_A72_0"
    get_cpu "_A72_1"

    echo "{
        \"time\":\"$(date +"%Y-%m-%dT%H:%M:%S")\",
        \"cpuInfo\":{
            \"temperatures\":{
                \"A53\":$CORE_A53_TEMP,
                \"A72\":$CORE_A72_TEMP
            },
            \"usage\":$CPU_USAGE,
            \"usageDetailed\":{
                \"A53-0\":$CPU_USAGE_A53_0,
                \"A53-1\":$CPU_USAGE_A53_1,
                \"A53-2\":$CPU_USAGE_A53_2,
                \"A53-3\":$CPU_USAGE_A53_3,
                \"A72-0\":$CPU_USAGE_A72_0,
                \"A72-1\":$CPU_USAGE_A72_1
            }
        },
        \"gpuInfo\":{
            \"cores\":2,
            \"temperatures\":{
                \"GPU0\":$GPU_0_TEMP,
                \"GPU1\":$GPU_1_TEMP
            },
            \"memoryUsage\":$GPU_USAGE
        },
        \"ramInfo\":{
            \"total\":$RAM_TOTAL,
            \"usage\":$RAM_USAGE,
            \"free\":$RAM_FREE
        },
        \"generalInfo\":{
            \"board_serial\":\"$BRD_SERIAL_NUM\"
        },
        \"internet\":{
            \"connectivity\":$NETWORK_CONNECTED,
            \"signal\":$NETWORK_SIGNAL
        },
        \"dataInfo\":{
            \"ethernet\":{
                \"rx\":$DATA_ETH0_RX,
                \"tx\":$DATA_ETH0_TX
            },
            \"wwan\":{
                \"rx\":$DATA_WWAN0_RX,
                \"tx\":$DATA_WWAN0_TX
            }
        },
        \"powerInfo\":{
            \"battery_temp\":$BATT_TEMP,
            \"voltage\":$BATT_VOLTAGE,
            \"current\":$BATT_CURRENT
        },
        \"weather\":{
            \"lux\":$W_LUX,
            \"temperature\":$W_TEMPERATURE,
            \"humidity\":$W_HUMIDITY
        }
    }" > ${OUTFILE} 
done
