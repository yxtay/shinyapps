### Central Limit Theorem

This Shiny app serves to demonstrate the **Central Limit Theorem**. 
The theorem states that the **arithmetic mean** of a **sufficiently large number** of 
**independent** and **identically distributed** random variables will be 
**approximately normally distributed**. 
This is **regardless of the underlying distribution**, 
as long as the expected value and variance are well defined.

The normality of a sample distribution can be checked by comparing 
the kernel density plot against the normal density. Alternatively, one can observe the QQ plot.

#### Settings

**Probability Distribution** - 
A list of standard distributions from the base R package are available. 
Random samples are generated from the selected distribution. 
For more information on each distribution, please refer to the 
[R documentation](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Distributions.html).

**Sample Size** - 
Sample size refers to the number of observations in a sample. 
From each sample, the sample mean is computed to derive 
one observation for the distribution of sample means. 
The sample size can be varied to investigate the number of observations required for 
the sample means to become approximately normally distributed.

**Sample Count** - 
Sample count refers to the number of times the samples are replicated. 
Hence, the sample count determines the number of observations of sample means. 
A sufficiently large sample count is necessary to generate a 
representative empirical distribution of the sample means.

The total number of observations generated from the underlying distribution is: 
(*sample size*) * (*sample count*).

**Parameters** - 
Parameters refer to the parameters of the underlying probability distributions. 
Due to the different number of parameters and parameter specifications, 
the slider bars updates dynamically depending on the distribution selected. 
The parameters are named according to the R documentation.