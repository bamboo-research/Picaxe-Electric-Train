setfreq M32

SYMBOL sensor = b1
SYMBOL duty = b2
SYMBOL setpoint = b3

setup:

    FVRSETUP FVR4096
    adcconfig %001

    let setpoint = 95
    let duty = 95
    
    hpwm 1, 0, 0, 79, duty

main:

    readadc B.1, sensor
    sertxd(#sensor, "   ", #duty, cr, lf)
    ;sertxd(#duty, cr, lf)
    
    if sensor > setpoint AND duty < 159 THEN
    inc duty
    endif
    if sensor < setpoint AND duty > 5 THEN
    dec duty
    endif
    if sensor = setpoint THEN
    duty = duty
    endif

    hpwm 1, 0, 0, 79, duty

goto main
