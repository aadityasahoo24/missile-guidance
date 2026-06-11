# Active homing missile guidance system

## 1. Description
This is a simulation of an active homing missile guided by PN control that tracks a maneuvering target. This model simulates the behaviour of both the missile as well as the target, and then gives the control command to the missile based on the dynamics between the 2 objects.
A visualisation is also done using the `animate.m` file.

## 2. Files contained
1. `data.m` contains the configuration and simulation parameters
2. `model.slx` containing the dynamics of the system and the control logic
3. `animate.m` contains the post processing and visualisation script


## 3. Running the simulation

### Step 1: Configure parameters
Open the `data.m` file and modify the parameters like missile acceleration and velocity, target maneuvering strategy, and the controller parameters like the gain and approach velocity
Then run the file to store the variables (which will be used by the simulation) in the base workspace.

### Step 2: Simulate the model
Open and run the `model.slx` file. Adjust the time of the simulation (in seconds). I have used a time of 10 minutes.
Then go to the XY graph in the top-right corner, that receives data from both the missile dynamics and the target dynamics subsystems in the block diagram.
Click the option of "Export Data" in the graph, and save the data to the base workspace with the name you want.

### Step 3: Generate animation
Once the data has been logged to the workspace, open the `animate.m` file. Change the name of the variable from which all the data is extracted (i.e. the name given to the exported data in step 2)
When this is done, simply run the code and a plotted figure will be generated that shows the position of the missle and the target, their paths and also the Line of Sight (LOS). It is using the line of sight and the relative angle between the 2 using which the control law is calculated.

## 4. Working 
This simulation is a 2DOF engagement between the missile (interceptor) and the target. At each simulation step, the states ($x, y, v_x, v_y$) of both are calculated through their respective subsystems.
Then the vectors are sent through the Relative dynamics subsystem that calculates the Line of Sight (LOS) relationship between them. We get 
1. Range i.e. euclidean distance between them. This is done using $$ R =  \sqrt{\Delta x^2 + {\Delta y}^2} $$
2. $\lambda$ i.e. the relative angle between them. 
This is done using the formula $$ \lambda = arctan(\frac{y}{y}) $$
3. $\dot{\lambda}$ i.e. the rate of the change of the angle between them. This is not done by differentiation the angle, but by taking the analytical derivation. This allows for accurate differentiation even when data is noisy. Using this we do not need an estimation filter. $$ \dot{\lambda} = \frac {v_y \cdot x - v_x \cdot y} {R^2}$$

Once we have these variables, we can use this to calculate the control law. 
The control in our case is being given by something called the Proportional navigation law, which gives the acceleration command for the missile based on: $$ a_{cmd} = N \cdot V_c \cdot \dot{\lambda} $$

Here N is just a proportional constant supposed to be between 3 and 5. I have chosen 3
$V_c$  is the closing velocity - i.e. velocity at the point of contact.

We feed the $\dot{\lambda}$ to the PN control subsystem, that generates the command acceleration required by the missile to catch up to the target.

Since the acceleration cannot be a super high value, there is a saturation that keeps it between $\pm 30g$ (which is the range is which most real-world missiles operate.)
I also pass it through a time delay block for added realism

And so with this we get a guidance mechanism for our missile such that it intercepts stationary, moving and maneuvering targets.

## Control loop
![alt text](image.png)

## Demo


## Future changes
This model is not perfect; a lot of things need to be improved. Some of these things include: 
1. Adding kinetic equations such as drag, aerodynamics, etc.
2. The entire system can be converted to state space form
3. Add obstacle detection and avoidance.
4. Guidance + Control has been added. Navigation for more advanced application
