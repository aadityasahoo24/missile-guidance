# Description
This is a Simulink model of a guided missile that follows a target that also maneuvers away
There are 3 files involved:

1. `data.m` file that contains all parameters that can be tuned for the missile, target and PN control parameters
2. `model.slx` file is the simulink block model that simulates the missile and stores the data that is needed for the animation. It contains the following subsystems: 
	a. Missile dynamics
	b. Target dynamics
	c.  Relative dynamics
	d. Control + Time delay + Saturation
Data is logged through different scopes
3. `animate.m` file takes all the data logged from the model scopes and animates them so that we can easily visualise the missile, the target maneuvering and also the LOS and the range