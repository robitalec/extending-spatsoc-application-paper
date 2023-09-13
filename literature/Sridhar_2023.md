---
title: Sridhar_2023
---
Sridhar, Vivek H., Jacob D. Davidson, Colin R. Twomey, Matthew M. G. Sosna, Máté Nagy, and Iain D. Couzin. 2023. “Inferring Social Influence in Animal Groups across Multiple Timescales.” _Philosophical Transactions of the Royal Society B: Biological Sciences_ 378 (1874): 20220062. [https://doi.org/10.1098/rstb.2022.0062](https://doi.org/10.1098/rstb.2022.0062).

---
Code
- https://github.com/vivekhsridhar/INFL_2022

Supplemental materials
- https://figshare.com/articles/journal_contribution/Inferring_social_influence_in_animal_groups_across_multiple_timescales_SI/21967120


Behavioural research focuses on behaviours at relatively short temporal scales, often matching observations. Behavioural coupling where multiple animals interact can introduce new timescales of importance. The predictive power of pairwise interactionns depends on the timescale of analysis. Short timescales are best predicted by relative position of neighbours, where the distribution of influence across group members is relatively linear with a small slope. Long timescales are best predicted by both relative position and kinematics, as nonlinearity increases and a subset of individuals are disproportionately influential. Timescale influences results therefore it is important to consider multiple scales.

The authors note the use of terms [[influence]] and [[leader]] interchangeably 


Data
- homing pigeon [GPS](GPS.md) 
- filmed golden shiners

Methods
- Positional features
	- Relative distance and angular position of individuals with respect to every other individual in the group
		- Distance = difference between position of i at time t and position of j at time t
		- Angular position = angle between velocity vector of i and vector dij = position i - position j at time t . In other words, the difference between vector and the vector that would have otherwise moved i to individual j. Absolute value.
- Kinematic variables ([Jolles_2017](Jolles_2017.md), [Pettit_2015](Pettit_2015.md))
	- Absolute kinematic variables
		- Speed and rate of change of velocity
			- Speed = magnitude of the velocity vector  eg. difference between position at time t and time  t - delta t, divided by delta t
			- Acceleration = difference between speed at time t and time t - delta t, divided by delta t
	- Relative kinematic variables
		- Pairwise differences in absolute kinematic variables
	- Difference in speed and acceleration between individual and every other individual in the group
- [Nagy_2010](Nagy_2010.md)'s directional correlation technique 
	- Time lags of 7, 15, 30, 60 s
- Binary engaged in [leader](leader.md) [follower](follower.md) or not
- Bayesian GLM in Stan

Sensitivity analysis of angular threshold and time threshold


