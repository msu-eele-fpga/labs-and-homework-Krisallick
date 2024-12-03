#!/bin/bash
HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"

echo 0x02 > $BASE_PERIOD

# Enable software-control mode
echo 1 > $HPS_LED_CONTROL


while true
do
    echo 0x05 > $LED_REG
    sleep 0.125
    echo 0x0A > $LED_REG
    sleep 0.125
done