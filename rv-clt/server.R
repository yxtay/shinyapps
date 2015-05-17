library(shiny)
library(ggplot2)

###
# probability distributions list ----
###

# probability distribution list with function name and list of parameter specifications
# parameter specification follows c(min, max, value, step) following sliderInput arguments
dist <- list(
    beta = list(func = rbeta, 
                par = list(shape1 = c(0.1, 100, 0.5, 0.1), 
                           shape2 = c(0.1, 100, 1.5, 0.1))),
    binom = list(func = rbinom, 
                 par = list(size = c(5, 100, 10, 1), 
                            prob = c(0.05, 0.95, 0.2, 0.01))),
    cauchy = list(func = rcauchy, 
                  par = list(location = c(-10, 10, 0, 0.1), 
                             scale = c(0.1, 5, 1, 0.1))),
    chisq = list(func = rchisq, 
                 par = list(df = c(0.1, 100, 1, 0.1))),
    exp = list(func = rexp, 
               par = list(rate = c(0.1, 100, 1, 0.1))),
    f = list(func = rf, 
             par = list(df1 = c(1, 100, 10, 0.1), 
                        df2 = c(2, 100, 10, 0.1))),
    gamma = list(func = rgamma, 
                 par = list(shape = c(0.1, 100, 1, 0.1), 
                            rate = c(0.1, 100, 1, 0.1))),
    geom = list(func = rgeom, 
                par = list(prob = c(0.05, 0.95, 0.2, 0.01))),
    hyper = list(func = rhyper, 
                 par = list(m = c(10, 30, 30, 1), 
                            n = c(10, 30, 10, 1), 
                            k = c(5, 50, 20, 1))),
    lnorm = list(func = rlnorm, 
                 par = list(meanlog = c(-10, 10, 0, 0.1), 
                            sdlog = c(0.01, 2, 1, 0.01))),
    multinom = list(func = rmultinom, 
                    par = list("size", 
                               "prob")),
    nbinom = list(func = rnbinom, 
                  par = list(size = c(1, 100, 10, 1), 
                             prob = c(0.05, 0.95, 0.2, 0.01))),
    norm = list(func = rnorm, 
                par = list(mean = c(-10, 10, 0, 0.1), 
                           sd = c(0.1, 100, 1, 0.1))),
    pois = list(func = rpois, 
                par = list(lambda = c(0.1, 100, 1, 0.1))),
    t = list(func = rt, 
             par = list(df = c(1, 100, 10, 0.1))),
    unif = list(func = runif, 
                par = list(min = c(-10, 0, 0, 0.1), 
                           max = c(0.1, 10, 1, 0.1))),
    weibull = list(func = rweibull, 
                   par = list(shape = c(0.1, 100, 1, 0.1), 
                              scale = c(0.1, 100, 1, 0.1)))
)

###
# plotting functions ----
###

# plotting function for base plot
doPlot <- function(sample, title){
    title <- paste0("Distribution of ", title)
    hist(sample, freq = F, col = "skyblue",
         main = title, xlab = "Values")
    lines(density(sample, bw = "nrd"), col = "blue3", lwd = 2)
    smean <- mean(sample, na.rm = T)
    ssd <- sd(sample, na.rm = T)
    limits <- par("usr")
    x <- seq(limits[1], limits[2], length.out = 100)
    lines(x, dnorm(x, smean, ssd), col = "red3", lwd = 2)
    legend("topright", bty = "n",
           legend = c("kernel density", "normal density"),
           col = c("blue3", "red3"),
           lwd = 2)
}

# plotting function for qqplot
doQQplot <- function(sample, title) {
    title <- paste0("Normal Q-Q Plot of ", title)
    qqnorm(sample, pch = 4, main = title, col = rgb(0, 0, 0, 0.2))
    qqline(sample, col = "red3", lwd = 2)
}

# plotting function for ggplot
doGGplot <- function(sample, title) {
    title <- paste0("Distribution of ", title)
    smean <- mean(sample, na.rm = T)
    ssd <- sd(sample, na.rm = T)
    ggplot(data.frame(sample)) + 
        geom_histogram(aes(x = sample, y = ..density..),
                       fill = "skyblue",
                       color = "black") + 
        geom_density(aes(x = sample, color = "kernel density"), size = 1) + 
        stat_function(fun = dnorm, 
                      arg = list(mean = smean, sd = ssd),
                      aes(color = "normal density"),
                      size = 1) +
        labs(title = title, x = "Values", y = "Density") +
        scale_color_discrete("") + 
        theme_bw()
}

###
# shiny server ----
###

shinyServer(function(input, output) {
    
    # selected distribution specs
    distInfo <- reactive({
        spec <- dist[[input$dist]]
    })
    
    ###
    # Dynamic UI input for up to 3 parameters
    ###
    
    # 1st parameter
    output$par1Input <- renderUI({
        # trigger from distribution selection
        input$dist
        
        par1spec = distInfo()$par[[1]]
        sliderInput("par1", names(distInfo()$par)[1],
                    min = par1spec[1], max = par1spec[2],
                    value = par1spec[3], step = par1spec[4])
    })
    
    # 2nd parameter
    output$par2Input <- renderUI({
        # trigger from distribution selection
        input$dist
        
        if(length(distInfo()$par) >= 2) { # for 2nd parameter
            par2spec = distInfo()$par[[2]]
            sliderInput("par2", names(distInfo()$par)[2],
                        min = par2spec[1], max = par2spec[2],
                        value = par2spec[3], step = par2spec[4])
        }
    })
    
    # 3rd parameter
    output$par3Input <- renderUI({
        # trigger from distribution selection
        input$dist
        
        if(length(distInfo()$par) >= 3) { # for 3rd parameter
            par3spec = distInfo()$par[[3]]
            sliderInput("par3", names(distInfo()$par)[3],
                        min = par3spec[1], max = par3spec[2],
                        value = par3spec[3], step = par3spec[4])
        }
    })
    
    ###
    # sample generation
    ###
    
    sample <- reactive({
        # triggered also by button press
        input$button
        
        # gather arguments for sample generation into a vector
        values <- c(input$count * input$size,
                    switch(length(distInfo()$par),
                         c(input$par1),
                         c(input$par1, input$par2),
                         c(input$par1, input$par2, input$par3)))
        try(names(values) <- c(switch(input$dist, hyper = "nn", "n"),
                             names(distInfo()$par)),
            silent = T)
        
        # form function call string to be used for plot title
        call <- paste(names(values), values, sep = " = ", collapse = ", ")
        call <- sprintf("r%s(%s)", input$dist, call)
        
        # generate sample and compute sample means
        sample <- do.call(distInfo()$func, as.list(values))
        means <- colMeans(matrix(sample, input$size), na.rm = T)
        
        list(call = call, sample = sample, means = means)
    })
    
    ###
    # plots
    ###
    
    # base plots
    output$sampleBasePlot <- renderPlot({
        try(doPlot(sample()$sample, sample()$call), silent = T)
    })
    
    output$meansBasePlot <- renderPlot({
        try(doPlot(sample()$means, "Sample Means"), silent = T)
    })
    
    # qqplot
    output$sampleQQplot <- renderPlot({
        try(doQQplot(sample()$sample, sample()$call), silent = T)
    })
    
    output$meansQQplot <- renderPlot({
        try(doQQplot(sample()$means, "Sample Means"), silent = T)
    })
    
    # ggplot
    output$sampleGGplot <- renderPlot({
        try(doGGplot(sample()$sample, sample()$call), silent = T)
        })
    
    output$meansGGplot <- renderPlot({
        try(doGGplot(sample()$means, "Sample Means"), silent = T)
    })
    
    # sample summaries
    output$sampleSummary <- renderPrint(summary(sample()$sample))
    output$meansSummary <- renderPrint(summary(sample()$means))
})