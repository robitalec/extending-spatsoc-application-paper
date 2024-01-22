---
title: Dodge_2008
---
Dodge, Somayeh, Robert Weibel, and Anna-Katharina Lautenschütz. 2008. “Towards a Taxonomy of Movement Patterns.” _Information Visualization_ 7 (3–4): 240–52. [https://doi.org/10.1057/PALGRAVE.IVS.9500182](https://doi.org/10.1057/PALGRAVE.IVS.9500182).

---
Accompanying wiki: http://movementpatterns.pbworks.com/w/page/21692527/Patterns%20of%20Movement

Table 1 movement [[parameters]]

| Primitive  | Primitive | Primary derivatives | Secondary derivatives  |
|-----------------------------------------------------|-----------|---------------------|------------------------|
| [Spatial](spatial.md) (x,  y)                                     | Position  | [Distance](distance.md)            | Spatial distribution   |
| [Spatial](spatial.md) (x,  y)                                     | Position  | [Direction](direction.md)           | Change of [direction](direction.md)    |
| [Spatial](spatial.md) (x,  y)                                     | Position  | Spatial extent      | Sinuosity              |
| [Temporal](temporal.md) (t)                                        | Instance  | Duration            | Temporal distribution |
| [Temporal](temporal.md) (t)                                        | Interval  | Travel time         | Change of duration     |
| [Spatio-temporal](spatio-temporal.md) (x, y, t)                           | NA        | [Speed](speed.md)               | [Acceleration](acceleration.md)           |
| [Spatio-temporal](spatio-temporal.md) (x, y, t)                           | NA        | [Velocity](velocity.md)            | Approaching rate       |

Defined in terms of [[absolute]] (related to the reference system) and [[relative]] (related to the movement of other individuals)


Table 2
Number of objects involved in a movement

- Individual: N = 1
- Group: N > 1, relationship is functional
- Cohor: N > 1, but relationship is  statistical


Types of paths:
- continuous 
- discontinuous paths, made up of steps

Influencing factors
- intrinsic properties of  the moving object
- [spatial](spatial.md) constraints
- environment
- influences  of other agents

Scale/granularity (see more in [[Laube_2005]])
- [spatial](spatial.md)
- [temporal](temporal.md)

[[pattern]]
- Primitive [pattern](pattern.md)
	- [[co-location in space]]: same positions in space
		- ordered co-location
		- unordered co-location
		- symmetrical co-location
	- [[concentration]]: zone of high density
	- incidents (Laube_2002)
		- [[concurrence]]: same values of motion attributes at the same time (synchronous movement)
		- [[co-incidence]] in space and time ([[Andrienko_2007]])
			- full [co-incidence](co-incidence.md): same positions at the same time
			- lagged [co-incidence](co-incidence.md): same positions after a time delay
	- [[opposition]]: bi- or multi-polar arrangement of motion parameter values, such as spatial splitting of a group into two opposite directions
	- [[dispersion]]: opposite of [concurrence](concurrence.md), non-uniform or random motion
	- [[constancy]]: movement [parameters](parameters.md) remain the same or only have minor changes for a particular duration  
	- [[sequence]]: ordered list of visits to a series of locations
		- [[spatio-temporal]] [sequence](sequence.md)  is an ordered subsequence of locations with timestamps
	- [[periodicity]]: [[temporal]] periodic [pattern](pattern.md) 
		- [spatio-temporal](spatio-temporal.md) [periodicity](periodicity.md): same [pattern](pattern.md) or [pattern](pattern.md) sequences  at regularly spaced time intervals,  eg. migrating geese every year ([Andrienko_2007](Andrienko_2007.md))
	- [[meet]]: set of individuals forming as stationary cluster
		- fixed [meet](meet.md): all individuals remain together for the entire time interval ([Gudmundsson_2006](Gudmundsson_2006.md))
		- varying [meet](meet.md): individuals change during the time interval ([Gudmundsson_2006](Gudmundsson_2006.md))
	- [Moving cluster](moving%20cluster.md): set of individuals that remain within some [distance](distance.md) threshold for a specific duration (also called a [[flock]] in [Gudmundsson_2006](Gudmundsson_2006.md))
		- fixed [moving cluster](moving%20cluster.md): individuals stay the same
		- varying [moving cluster](moving%20cluster.md): individuals may change as long as  there are a set minimum number of individuals
	- [[temporal relations]]: [temporal](temporal.md) relations between events eg. a rest after a long continuous flight
	- [[synchronization]]: 
		- full [[synchronization]]: similar changes of movement [parameters](parameters.md) occurring at the same time [Andrienko_2007](Andrienko_2007.md)
		- lagged [[synchronization]]: similar changes of movement [parameters](parameters.md) occurring after a time delay ([Andrienko_2007](Andrienko_2007.md))
- Generic [pattern](pattern.md): compound [pattern](pattern.md)
	- [[isolated object]]: individual not influenced by or with any influence on other individuals
	- [[symmetry]]: [sequence](sequence.md) of [pattern](pattern.md) where same [pattern](pattern.md) are arranged in reverse order (eg. migration N-S then S-N)
	- [[repetition]]: [sequence](sequence.md) of [pattern](pattern.md) or [pattern](pattern.md) [sequence](sequence.md) at different time intervals (eg. eye scanning  page up and down repeatedly)
	- [[propagation]]: one individual starts a movement parameter and others adopt the same [pattern](pattern.md). Compared to [trend-setter](trend-setter.md), does not necessarily require an influential [trend-setter](trend-setter.md) object (eg. geese gradually starting migration north).
	- [[convergence]]/[[divergence]]
		- [[convergence]]: movement of individuals towards a common location
			-  Not necessarily at the same time. For at the same time, see [encounter](encounter.md).
		- [[divergence]]: movement of individuals away from a common location
			- Not necessarily at the same time. For at the same time, see [breakup](breakup.md).
	- [[encounter]]/[[breakup]]
		- [[encounter]]: moving to and meeting at the same location.  A specific form of [convergence](convergence.md) where objects arrive at the same time. 
		- [[breakup]]: movement of individuals away from a common location at a common time. A specific form of [divergence](divergence.md) that adds a [temporal](temporal.md) constraint
	- [trend](trend.md)/[fluctuation](fluctuation.md)
		- [[trend]]: consistent changes in movement [pattern](pattern.md) (eg. air plane in a circular holding [pattern](pattern.md) has a constant rate of change of movement [direction](direction.md))
		- [[fluctuation]]: irregular changes in movement [parameters](parameters.md) of individuals
	- [[trend-setter](trend-setter.md)]: individuals that anticipate movement patterns and are afterwards followed by other individuals  ([Laube_2005a](Laube_2005a.md))
		- non-varying [trend-setter](trend-setter.md): fixed subset of other individuals
		- varying [trend-setter](trend-setter.md): flexible subset of other individuals
- Behavioural [pattern](pattern.md) (many behavioural patterns can be defined from these generic patterns, the authors leave further definitions to domain specialist)
	- pursuit/evasion
		- Very high [speed](speed.md) movement with large amounts of turning over a potentially large area
		- Pursuit/evasion is a combination of [leadership](leadership.md) and [trend](trend.md)-setting movements as the evader leads and affects the pursuer's movement [parameters](parameters.md)
	- fighting
		- High [speed](speed.md) movements with large amounts of tightly intertwined turning, looping and frequent contact
		- Combination  of pursuit/evasion, attack and defence. Complex combination of different patterns including incidents, [concurrence](concurrence.md), [repetition](repetition.md), [co-location in space](co-location%20in%20space.md) and time. If fighting occurs among a group of animals, other types of patterns might be involved such as [convergence](convergence.md), [divergence](divergence.md), [encounter](encounter.md), [breakup](breakup.md), [leadership](leadership.md). 
	- play: combination of pursuit, evasion, fighting, courtship where individuals may repeatedly switch roles between pursuer and evader, attacker and defender. 
	- [flock](flock.md): represented by the generic [pattern](pattern.md) of [moving cluster](moving%20cluster.md) 
	- [[leadership]]: [leader](leader.md) may be defined as one that isn't followed by anyone and is followed by a sufficient number of other individuals at a proximate  [distance](distance.md)
		- A specific kind of [trend-setter](trend-setter.md)  mostly associated with animal or human behaviour
		- In contrast to [trend-setter](trend-setter.md), [leadership](leadership.md) requires [spatio-temporal](spatio-temporal.md)  proximity and this requirement is less strict in [trend-setter](trend-setter.md)
	- congestion: slower than usual movement, longer trips, increased queuing. A combination of [meet](meet.md), [concurrence](concurrence.md), [constancy](constancy.md). Jams form areas of [concentration](concentration.md)
	- saccade/fixation
		- fixation: pauses over informative  regions  of  interest
		- saccade: rapid movements  between fixations

