library(shiny)

###
# probability distribution list for selection ----
###

choices <- list(
    "Beta(shape1, shape2)" = "beta",
    "Binomial(size, prob)" = "binom",
    "Cauchy(location, scale)" = "cauchy",
    "Chi-Squared(df)" = "chisq",
    "Exponential(rate)" = "exp",
    "F(df1, df2)" = "f",
    "Gamma(shape, rate)" = "gamma",
    "Geometric(prob)" = "geom",
    "Hypgergeometric(m, n, k)" = "hyper",
    "Lognormal(meanlog, sdlog)" = "lnorm",
    "Negative Binomial(size, prob)" = "nbinom",
    "Normal(mean, sd)" = "norm",
    "Poisson(lambda)" = "pois",
    "Student's t(df)" = "t",
    "Uniform(min, max)" = "unif",
    "Weibull(shape, scale)" = "weibull"
)

###
# instructions tab ----
###

tabInstructions <- function() {
    tabPanel("Instructions",
             h3("Central Limit Theorem"),
             p("This Shiny app serves to demonstrate the",
               strong("Central Limit Theorem."),
               "The theorem states that the arithmetic mean ",
               "of a sufficiently large number of ",
               "independent and identically distributed random variables",
               "will be approximately", strong("normally"), "distributed.",
               "This is regardless of the underlying distribution, ",
               "as long as the expected value and variance are well defined."),
             p("The normality of a sample distribution can be checked ",
               "by comparing the kernel density plot against the normal density. ",
               "Alternatively, one can observe the QQ plot."),
             
             h4("Settings"),
             p(strong("Probability Distribution"), "- ",
               "A list of standard distributions from the base R package are available. ",
               "Random samples are generated from the selected distribution. ",
               "For more information on each distribution, please refer to the ",
               a("R documentation.", 
                 href = "https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Distributions.html")),
             
             p(strong("Sample Size"), "- ",
               "Sample size refers to the number of observations in a sample. ",
               "From each sample, the sample mean is computed",
               "to derive one observation for the distribution of sample means. ",
               "The sample size can be varied to investigate the number of observations ",
               "required for the sample means to become approximately normally distributed."),
             p(strong("Sample Count"), "-",
               "Sample count refers to the number of times the samples are replicated. ",
               "Hence, the sample count determines the number of observations of sample means.",
               "A sufficiently large sample count is necessary to generate ",
               "a representative empirical distribution of the sample means."),
             p("The total number of observations generated from the underlying distribution is: ",
               "(sample size) * (sample count)."),
             
             p(strong("Parameters"), "- ",
               "Parameters refer to the parameters of the underlying probability distributions. ",
               "Due to the different number of parameters and parameter specifications, ",
               "the slider bars updates dynamically depending on the distribution selected.",
               "The parameters are named according to the R documentation.")
    )
}

###
# shiny ui ----
###

shinyUI(pageWithSidebar(
    
    headerPanel("Demonstration of Central Limit Theorem on Different Probability Distributions"),
    
    # side panel for settings for sample generation
    column(4,
           
           wellPanel(
               # selection of distributions
               selectInput("dist", "Probability distribution",
                           choices),
               
               # sliders for sample count and size
               sliderInput("size", "Sample size", 
                           min = 10, max = 1e3, value = 100),
               
               sliderInput("count", "Sample count", 
                           min = 1e2, max = 1e3, value = 500)
               ),
           
           wellPanel(
               h4("Parameters"),
               
               # sliders for distribution parameters setting
               uiOutput("par1Input"),
               uiOutput("par2Input"),
               uiOutput("par3Input"),
               actionButton("button", "New sample")    
           ),
           
           strong("Created by YuXuan Tay"),
           p(a("LinkedIn", 
               href = "https://www.linkedin.com/in/yxtay/"), 
             "|",
             a("Github", 
               href = "https://github.com/yxtay/")),
           
           p(strong("Source Code:"),
             a("Github repository", 
               href = "https://github.com/yxtay/shinyapps/tree/master/rv-clt"))
    ),
    
    # Show a tabset that includes base plots, qqplot, ggplot, sample summary and about
    mainPanel(
        tabsetPanel(
            tabPanel("Base Plot",
                     plotOutput("sampleBasePlot"),
                     plotOutput("meansBasePlot")), 
            
            tabPanel("QQ Plot",
                     plotOutput("sampleQQplot"),
                     plotOutput("meansQQplot")),

            tabPanel("Sample Summary",
                     h4("Sample"),
                     verbatimTextOutput("sampleSummary"),
                     h4("Means"),
                     verbatimTextOutput("meansSummary")),
            
            tabInstructions()
        )
    )
))