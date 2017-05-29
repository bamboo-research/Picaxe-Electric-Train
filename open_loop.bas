    setfreq M32

    SYMBOL pot = b4
    SYMBOL duty = b5

setup:

    adcconfig %000                                  ; Vref- is 0V, Vref+ is V+

main:

    pause 100                                       ; wait for 0.5 s
    readadc B.1, pot                                ; read potentiometer

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
