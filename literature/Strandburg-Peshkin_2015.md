---
title: Strandburg-Peshkin_2015
---
Strandburg-Peshkin, Ariana, Damien R. Farine, Iain D. Couzin, and Margaret C. Crofoot. 2015. “Shared Decision-Making Drives Collective Movement in Wild Baboons.” _Science_ 348 (6241): 1358–61. [https://doi.org/10.1126/science.aaa5099](https://doi.org/10.1126/science.aaa5099).

---

Decision making

- olive baboons
- stable, multi-male, multi-female troops
- 80% with [GPS](GPS.md) collars but true number of collars varied between 16-25 / 26
- [temporal resolution](temporal%20resolution.md) 1 second fix rate during daylight

Conflicting past results in this system for identifying influential individuals

Automated procedure for extracting movement initiations, based on relative movements of pairs of individuals including disparity and strength. Successful pulls, failed pulls (anchors) or neither. Successful pull = i moves more than j during the first, but less than j during the second segment. Failed pull = i moves more during booth segments. Excluded where individuals' distance was too similar

- disparity 
	- disparity = |displacement i t1 t2 - displacement j t1 t2| |displacement i t2 t3 - displacement j t2 t3| / |displacement i t1 t2 + displacement j t1 t2| |displacement i t2 t3 + displacement j t2 t3|
	- 0-1 where 0 individuals move equally during both time steps, 1 one individual moves while the other is still
	- authors use a threshold of 0.1

- strength
	- strength = |sij t2 - sij t1| | sij t3 - sij t2| / |sij t2 + sij t1| | sij t3 + sij t2|
	- 0-1 where 0 is negligible change in dyadic distance and 1 where difference is very large
	- eg 1 where very close, then very far, then very close again
	- authors use a threshold of 0.1


> Code for extracting pulls and anchors from trajectory data will be made available online.




[Supplementary](https://www.science.org/doi/abs/10.1126/science.aaa5099#supplementary-materials)