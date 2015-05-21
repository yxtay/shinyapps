**Central Limit Theorem Demonstration**

This [Shiny app](https://yxtay.shinyapps.io/rv-clt/) serves to demonstrate the Central Limit Theorem.

It has also been an exercise for me to gain better understanding in developing a Shiny app. 
Specifically, a dynamic UI is required due to probability distributions requiring different number of parameters. 
I also have to think of a suitable structure to store the specifications of the distributions. 
The resulting varying number of inputs also mean I have to find a solution to feed different number of arguments 
to the sample generating function in a straightforward manner.

A good understanding of the reactive function is also necessary to save computation time and ensure that a consistent sample is used for a number of different plots.

It has been a useful learning experience for me. I hope you benefit from it as much as I did. 
For any query or suggestion for code improvement, please contact me on [Github](https://github.com/yxtay/).
