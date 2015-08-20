library(shiny)
library(shinythemes)
library(markdown)

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
# shiny ui ----
###

fluidPage(
    
    titlePanel("Demonstration of Central Limit Theorem on Different Probability Distributions"),
    
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
           
           # sliders for distribution parameters setting
           uiOutput("parInput"),
           
           actionButton("button", "New sample"),
           
           hr(),
           
           p(strong("Created by YuXuan Tay"),
             br(),
             a("LinkedIn", 
               href = "https://www.linkedin.com/in/yxtay/"), 
             "|",
             a("Github", 
               href = "https://github.com/yxtay/")),
           
           p(strong("Source Code:"),
             a("Github repository", 
               href = "https://github.com/yxtay/shinyapps/tree/master/rv-clt"))
    ),
    
    # Show a tabset that includes base plots, qqplot, sample summary and instructions
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
            
            tabPanel("Instructions",
                     includeMarkdown("instructions.md")),
            
            tabPanel("About",
                     includeMarkdown("readme.md"))
        )
    ),
    
    theme = shinytheme("cosmo")
)
