    setfreq M32

    SYMBOL sensor = b1
    SYMBOL duty = b2
    SYMBOL setpoint = b3

setup:

    let setpoint = 95                               ; initialise desired speed
    let duty = 95                                   ; initialise duty cycle
    
    FVRSETUP FVR4096
    adcconfig %001                                  ; Vref- is 0V, Vref+ is V+
    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

main:

    pause 500                                       ; wait for 0.5 s
    readadc B.1, sensor                             ; implement feedback from sensor
    sertxd(#sensor, "  ", #duty, cr, lf)            ; debugging

    if sensor > setpoint AND duty < 159 THEN        ; if sensed speed is too slow
    inc duty                                        ; slow down motor
    endif
    if sensor < setpoint AND duty > 5 THEN          ; if sensed speed is too fast
    dec duty                                        ; speed up motor
    endif
    if sensor = setpoint THEN                       ; if the speed is correct
    duty = duty                                     ; use the dame duty cycle
    endif

    hpwm 1, 0, 0, 79, duty                          ; set pwm

goto main
