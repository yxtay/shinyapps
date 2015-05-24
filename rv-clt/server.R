library(shiny)

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
    hist(sample, breaks = 30, freq = F, col ="skyblue",
         main = title, xlab = "Values")
    lines(density(sample, bw = "nrd"), col = "blue3", lwd = 2)
    curve(dnorm(x, mean(sample), sd(sample)), n = 512,
          xlim = par("usr")[1:2], add = T, col = "red3", lwd = 2)
    legend("topright", bty = "n",
           legend = c("kernel density", "normal density"),
           col = c("blue3", "red3"), lwd = 2)
}

# plotting function for qqplot
doQQplot <- function(sample, title) {
    title <- paste0("Normal Q-Q Plot of ", title)
    qqnorm(sample, pch = 4, main = title, col = rgb(0, 0, 0, 0.2))
    qqline(sample, col = "red3", lwd = 2)
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
    # Dynamic UI input for up to 3 parameters created from loop
    ###
    
    lapply(1:3, function(i) {
        output[[paste0("parInput", i)]] <- renderUI({
            distPar <- distInfo()$par
            
            if (length(distPar) >= i) {
                parSpec <- distPar[[i]]
                
                sliderInput(paste0("par", i), 
                            names(distPar)[[i]],
                            min = parSpec[1], max = parSpec[2],
                            value = parSpec[3], step = parSpec[4])
            }
        })
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
        # argument for number of observations is "nn" for hypergeometric
        try(names(values) <- c(switch(input$dist, hyper = "nn", "n"),
                             names(distInfo()$par)),
            silent = T)
        
        # form function call string to be used for plot title
        call <- paste(names(values), values, 
                      sep = " = ", collapse = ", ")
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
    
    # sample summaries
    output$sampleSummary <- renderPrint(summary(sample()$sample))
    output$meansSummary <- renderPrint(summary(sample()$means))
})