;======================================================
;   Electric Train on PICAXE microcontroller
;   ELEC3204 Major Project
;   Date: 29/05/2017
;   Authors: Martin Abeleda
;            Aminah Thipayawat
;            Haibo Wang
;   Description:
;            Implementation of an electric train on
;            the PICAXE microcontroller. The train has
;            an open loop and a closed loop mode. In
;            the open loop mode, the speed is changed
;            using a potentiometer and drives forwards
;            and reverse. In closed loop mode, there is
;            a fixed speed setpoint.
;======================================================
    setfreq M32

    SYMBOL mode = b0
    SYMBOL sensor = b1
    SYMBOL duty = b2
    SYMBOL poten = b3
    SYMBOL setpoint = b4

    SYMBOL MODE_BUTTON = pinC.3
    SYMBOL STOP_BUTTON = pinC.4
    SYMBOL SPEED_SENSOR = B.1
    SYMBOL POTENTIOMETER = B.2
    SYMBOL OPEN_LED = B.3
    SYMBOL CLOSED_LED = B.4

setup:

    let mode = 0
    let setpoint = 95                       
    gosub openLoopSetup
    
    FVRSETUP FVR4096
    adcconfig %001                                  ; Vref- is 0V, Vref+ is V+

main:

    
    IF MODE_BUTTON = 1 THEN
    pause 500
    IF MODE_BUTTON = 1 THEN
    gosub stateChange
    ENDIF
    ENDIF	
    
    IF STOP_BUTTON = 1 THEN
    pause 500
    IF STOP_BUTTON = 1 THEN
    gosub eStop
    ENDIF
    ENDIF

    IF mode = 0 THEN                                ; open loop state
    goto openLoop
    ELSEIF mode = 1 THEN                            ; closed loop state
    goto closedLoop
    ELSEIF mode = 2 THEN
    goto stopState
    ENDIF
    
openLoop:

    pause 100                                       ; wait for 0.5 s
    readadc POTENTIOMETER, poten                    ; read potentiometer

    IF poten >= 0 AND poten <  51 THEN
    let duty = 191                                  ; slow reverse
    ELSEIF poten >= 51 AND poten < 102 THEN
    let duty = 160                                  ; stop
    ELSEIF poten >= 102 AND poten < 153 THEN
    let duty = 127                                  ; slow forward
    ELSEIF poten >= 153 AND poten < 204 THEN
    let duty = 95                                   ; medium forward
    ELSEIF poten >= 204 AND poten < 255 THEN
    let duty = 47                                   ; fast forward
    ENDIF
    
    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

    goto main

closedLoop:

    pause 300                                       ; wait for 0.5 s
    readadc SPEED_SENSOR, sensor                    ; implement feedback from sensor
    sertxd(#sensor, "  ", #duty, cr, lf)            ; debugging

    if sensor > setpoint AND duty < 159 THEN        ; if sensed speed is too slow
    inc duty                                        ; slow down motor
    endif
    if sensor < setpoint AND duty > 5 THEN          ; if sensed speed is too fast
    dec duty                                        ; speed up motor
    endif
    if sensor = setpoint THEN                       ; if the speed is correct
    let duty = duty                                 ; use the dame duty cycle
    endif

    hpwm 1, 0, 0, 79, duty                          ; set pwm

    goto main
    
    
stopState:

    sertxd("E-Stop", cr, lf)
    high OPEN_LED                                    ; change state LEDs
    high CLOSED_LED
    goto main 

closedLoopSetup:

    let duty = 95                                   ; initialise duty cycle
    low OPEN_LED                                    ; change state LEDs
    high CLOSED_LED

    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

    return

openLoopSetup:

    high OPEN_LED                                   ; change state LEDs
    low CLOSED_LED

    return
    
stateChange:

    IF mode = 0 THEN                               
    let mode = 1
    gosub closedLoopSetup
    ELSEIF mode = 1 THEN
    let mode = 0
    gosub openLoopSetup
    ELSEIF mode = 2 THEN
    let mode = 0
    gosub openLoopSetup
    ENDIF

    return  
    
eStop:

    let mode = 2
    let duty = 160
    hpwm 1, 0, 0, 79, duty
    
    return
      
