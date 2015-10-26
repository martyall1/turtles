#Turtles

The goal is to model a turtle population on a torus (ie they live on the surface of a donut).
The rules are very simple:
1. An initial population of turtles of size n walks aroung and eats grass.
2. The grass grows back after t seconds.
3. Male and Female turtles which collide have offspring with probability p.
4. At each time interval, the turtles have a certain probability of dying. 

It's a natural phenomenon that the fate of the turtles is extremely sensative to n,p and t. 
Almost surely they will either consume all the resources and all die out, or the population will
live forever. 
