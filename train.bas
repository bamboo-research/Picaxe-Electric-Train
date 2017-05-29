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

#DEFINE OPEN_LOOP   0                               ; open loop state
#DEFINE CLOSED_LOOP 1                               ; closed loop state
#DEFINE SETPOINT 95                                 ; closed loop SETPOINT reference

    setfreq M32

    SYMBOL mode = b0
    SYMBOL sensor = b1
    SYMBOL duty = b2
    SYMBOL pot = b3
    SYMBOL duty = b4

    SYMBOL MODE_BUTTON = B.0
    SYMBOL SPEED_SENSOR = B.1
    SYMBOL POTENTIOMETER = B.2
    SYMBOL OPEN_LED = B.3
    SYMBOL CLOSED_LED = B.4

setup:

    let state = OPEN_LOOP                           ; initialise in open loop state
    adcconfig %000                                  ; Vref- is 0V, Vref+ is V+
    setint %00000001,%00000001                      ; interrupt on input 0 high

main:

    IF mode = OPEN_LOOP                             ; open loop state
    goto openLoop
    ELSEIF mode = CLOSED_LOOP                       ; closed loop state
    goto closedLoop

openLoop:

    pause 100                                       ; wait for 0.5 s
    readadc POTENTIOMETER, pot                      ; read potentiometer

    IF pot >= 0 AND pot <  51 THEN
    let duty = 191                                  ; slow reverse
    ELSEIF pot >= 51 AND pot < 102 THEN
    let duty = 127                                  ; slow forward
    ELSEIF pot >= 102 AND pot < 153 THEN
    let duty = 95                                   ; medium forward
    ELSEIF pot >= 153 AND pot < 204 THEN
    let duty = 47                                   ; fast forward
    ELSEIF pot >= 204 AND pot < 255 THEN
    let duty = 0                                    ; very fast forward

    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

    goto main

closedLoop:

    pause 500                                       ; wait for 0.5 s
    readadc SPEED_SENSOR, sensor                    ; implement feedback from sensor
    sertxd(#sensor, "  ", #duty, cr, lf)            ; debugging

    if sensor > SETPOINT AND duty < 159 THEN        ; if sensed speed is too slow
    inc duty                                        ; slow down motor
    endif
    if sensor < SETPOINT AND duty > 5 THEN          ; if sensed speed is too fast
    dec duty                                        ; speed up motor
    endif
    if sensor = SETPOINT THEN                       ; if the speed is correct
    duty = duty                                     ; use the dame duty cycle
    endif

    hpwm 1, 0, 0, 79, duty                          ; set pwm

    goto main

interrupt:

    IF mode = OPEN_LOOP THEN                        ; Switch modes on interrupt
    mode = CLOSED_LOOP
    gosub closedLoopSetup
    ELSEIF mode = CLOSED_LOOP THEN
    mode = OPEN_LOOP
    gosub openLoopSetup
    ENDIF

    setint %00000001,%00000001                      ; set interrupt again

    return

closedLoopSetup:

    let SETPOINT = 95                               ; initialise desired speed
    let duty = 95                                   ; initialise duty cycle
    low OPEN_LED                                    ; change state LEDs
    high CLOSED_LED

    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

    return

openLoopSetup:

    high OPEN_LED                                   ; change state LEDs
    low CLOSED_LED

    return
