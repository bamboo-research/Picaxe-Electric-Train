    setfreq M32

    SYMBOL poten = b4
    SYMBOL duty = b5

setup:

    FVRSETUP FVR4096
    adcconfig %001                                  ; Vref- is 0V, Vref+ is V+

main:

    pause 100                                       ; wait for 0.5 s
    readadc B.2, poten                              ; read potentiometer

    IF poten >= 0 AND poten <  51 THEN
    let duty = 191                                  ; slow reverse
    ELSEIF poten >= 51 AND poten < 102 THEN
    let duty = 127                                  ; slow forward
    ELSEIF poten >= 102 AND poten < 153 THEN
    let duty = 95                                   ; medium forward
    ELSEIF poten >= 153 AND poten < 204 THEN
    let duty = 47                                   ; fast forward
    ELSEIF poten >= 204 AND poten < 255 THEN
    let duty = 0                                    ; very fast forward
    ENDIF

    hpwm 1, 0, 0, 79, duty                          ; complementary pwm at 100kHz

goto main
