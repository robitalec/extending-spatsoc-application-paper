---
title: Jolles_2017
---
Jolles, Jolle W., Neeltje J. Boogert, Vivek H. Sridhar, Iain D. Couzin, and Andrea Manica. 2017. “Consistent Individual Differences Drive Collective Behavior and Group Functioning of Schooling Fish.” _Current Biology_ 27 (18): 2862-2868.e7. [https://doi.org/10.1016/j.cub.2017.08.004](https://doi.org/10.1016/j.cub.2017.08.004).

---

Data
- sticklebacks
- observations
- video recording
- [computer vision](computer%20vision.md) with OpenCV

Method
- Individual characteristics
	- Velocity = forward finite difference
	- Speed
	- Direction = atan2
	- Acceleration = finite difference of velocity
	- Turning speed = finite difference of angle
- Within group positions
	- [[nearest neighbours]] distance
	- Center distance
		- Distance of  each fish to the center of the group
	- Relative position to center
	- Relative angle from center of group to each individual
- Group characteristics
	- Speed of the group center
	- [[group cohesion]]
		- Mean inter individual distances based on pairwise distances between all individuals in a group
	- [[group polarization]]
		- Alignment of the fish relative to each other, ranges from 0 to 1, complete non-alignment to complete alignment
- Propagation of motion
	- Using [Katz_2011](Katz_2011.md), [Nagy_2010](Nagy_2010.md)


Code: https://github.com/vivekhsridhar/individual_differences
Data: https://www.repository.cam.ac.uk/items/6dcf8f29-79df-4e62-8e93-2e6357a4ee51

Supplemental: https://www.cell.com/cms/10.1016/j.cub.2017.08.004/attachment/ba6b7125-3575-4e90-b1ce-092dcd58e851/mmc1.pdf
