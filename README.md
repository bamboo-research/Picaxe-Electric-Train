# picaxe-electric-train
An electric train system incorporating open-loop and closed-loop H-Bridge motor control using the PICAXE microcontroller for the ELEC3204 major project.  

## Authors
* Martin Abeleda
* Aminah Thipayawat
* Haibo Wang

## Operation
This project is programmed in the BASIC programming language for the PICAXE.

The train has an open loop and a closed loop mode. In the open loop mode, the speed is changed using a potentiometer and drives forwards and reverse. In closed loop mode, there is a fixed speed setpoint. Feedback is implemented by operating a DC motor as a generator. The generator output is fed through a voltage divider and low-pass filter to step-down the voltage and remove high frequency noise.

### State Diagram
![](https://github.com/martinabeleda/picaxe-electric-train/blob/master/train-state-diagram.png)

### Interface Design
![](https://github.com/martinabeleda/picaxe-electric-train/blob/master/user-interface.png)

## Hardware
* PICAXE
* H-Bridge board
* 2x DC Motors
* 1x Button
* 2x LEDs

## References
PICAXE documentation:
[Getting Started](http://www.picaxe.com/docs/picaxe_manual1.pdf)
[BASIC Commands](http://www.picaxe.com/docs/picaxe_manual2.pdf)
