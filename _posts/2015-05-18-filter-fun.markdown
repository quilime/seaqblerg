---
layout: post
title:  "Filter Fun"
date:   2015-05-18 21:59:50
categories: dev
author: gabe
---

Some progress on filter UI today.

As a temporary solution to hook up discreet controls that modify the same value, I implented some logic in the Update loop to check to see if each respective control was being actively dragged, in which case, it would set the Voice Value (which is the "absolute truth"). If it's not being dragged, then it takes the voice data sets the ctrl position accordingly. 

This is considered a temp solution as it doesn't account for touch stealing. For our final solution we'll need to incorporate a  method that takes into account the touch event timestamp delta.

Also, worked w/Ryan to get SVG's importing correctly so we have icons!

## [video] Playing with Linked Filter Controls

<iframe width="640" height="480" src="https://www.youtube.com/embed/R1EwPGjJHpA?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>




