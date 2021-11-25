#!/bin/sh

IFTTT_EVENT="temperature_reading"
IFFTT_KEY="j0-wI-LTDh1lU7yJ9-T2MOEG8S5rz54s8c-FCDaVSzU"
SIMULATED="y"

DEGREE_CELSIUS=$(echo -e '\xc2\xb0')C

read_core_temperature()
{
    echo $(vcgencmd measure_temp) | egrep -o '[0-9]{2}.[0-9]{1}'
}

read_simulated_temperature()
{
    local LOW=$1
    local HIGH=$2

    shuf -i $LOW-$HIGH -n 1
}
 
while true
do
    if [ -z "$SIMULATED" ]; then
        coreTemp=$(read_core_temperature)
    else
        coreTemp=$(read_simulated_temperature 20 60)
    fi
   
    echo "BCM2835 SoC core temperature: $coreTemp$DEGREE_CELSIUS"
    curl -H "Content-Type: application/json" -d '{"CoreTemperature":"$coreTemp"}' https://maker.ifttt.com/trigger/$IFTTT_EVENT/json/with/key/$IFTTT_KEY 2>1
    
    sleep 1
done
