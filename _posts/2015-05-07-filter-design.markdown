---
layout: post
title:  "Filter UI design"
date:   2015-05-07 13:54:50
categories: dev
---

Design mockups for a SVF (State Variable Filter) with the following functionality:

- Filter Mode 
  - Modes: 1. Low Pass, 2. Band Pass, 3. Hi Pass, 4. Notch.
  - Value: Float, 0.0f - 3.0f, interpolates between each filter mode
- Filter Cutoff Freq
  - Value: Float, 0 - 3000 range
- Filter Resonance Amt
  - Value: Float, 0 - 1
- Filter Envelope Attack Length
  - Value: Float, 0 - 2000ms range
- Filter Envelope Cutoff Frequency Start
  - Value: Float, 0 - 3000 range

<br />

## SVF UI Mockups

![](media/svf-Screen Shot 2015-05-07 at 2.05.00 PM.png)

Implementing Filter Mode as a circular slider component. Res and Cutoff are X/Y inside the circular slider ring.

![](media/svf-Screen Shot 2015-05-05 at 9.51.15 PM.png)

Illustrations of various filter ctrl states.

![](media/svf-Screen Shot 2015-05-05 at 9.49.21 PM.png)

Futher illustrations depicting interpolations between filter states.

![](media/filter-env-Screen Shot 2015-05-16 at 9.41.04 AM.png)

Filter Envelope Editor

## PD Patches

Main filter patch

![](media/svf-Screen Shot 2015-05-15 at 11.39.01 PM.png)

Filter mode crossfader (for circular control)

![](media/filter-crossfade-Screen Shot 2015-05-15 at 11.40.27 PM.png)

Filter Envelope

![](media/filters-Screen Shot 2015-05-15 at 8.11.02 PM.png)

[mix~]

![](media/filters-Screen Shot 2015-05-15 at 8.10.54 PM.png)

[mix~help]

![](media/filters-Screen Shot 2015-05-15 at 8.10.50 PM.png)


## [video] Skeletal UI control structure demo

<iframe width="640" height="480" src="https://www.youtube.com/embed/Y85d89PdBfU" frameborder="0" allowfullscreen></iframe>




