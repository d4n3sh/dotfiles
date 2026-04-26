#!/bin/bash

# Hot pink from wallpaper (3-milad-fakurian.jpg)
COLOR="E41C91"

# ASUS Aura LED Controller (device #2) — motherboard ARGB/RGB headers
liquidctl --match "ASUS" --pick 0 initialize
liquidctl --match "ASUS" --pick 0 set sync color static $COLOR

# NZXT Control Hub — led3/led4: F420 RGB fans, led5: F120 RGB fan
liquidctl --match "Control Hub" initialize
liquidctl --match "Control Hub" set led3 color fixed $COLOR
liquidctl --match "Control Hub" set led4 color fixed $COLOR
liquidctl --match "Control Hub" set led5 color fixed $COLOR

# NZXT Kraken 2024 Elite RGB — ring LEDs not supported by liquidctl yet
liquidctl --match "Kraken" initialize
liquidctl --match "Kraken" set lcd screen liquid
