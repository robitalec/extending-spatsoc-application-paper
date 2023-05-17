---
title: Flack_2018
---

Flack, Andrea, Máté Nagy, Wolfgang Fiedler, Iain D. Couzin, and Martin Wikelski. 2018. “From Local Collective Behavior to Global Migratory Patterns in White Storks.” _Science_ 360 (6391): 911–14.

---


Social information, collective movements in 27 migrating juvenile white stocks using GPS and accelerometers

GPS bursts of 2/5 minute every 15 minute

[Supplement](https://www.science.org/doi/10.1126/science.aap7781#supplementary-materials)

Calculated time advance/delay $\Delta t$  as the time advance/delay minimizing the distance between individual i at time $t - \Delta t$ and individual j. Then checked this against position within flock

Calculated leadership using directional correlation delay as in [Nagy_2010](Nagy_2010.md) using the interval of time between -20s and 20s. $t^{*}_{ij}(t)$ = for each time step the maximal value of $C_{ij}(\tau, t)$. The average directional correlation time delay for each individual is calculated as the average of directional correlation timme delays for all flock members where the correlation is minimum 0.9 and interindividual distance less than 200m

Perl and CUDA (no code)

