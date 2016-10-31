library(isofor)

## create dummy data
N = 1e3
x = c(rnorm(N, 0, 0.25), rnorm(N*0.05, -1.5, 1))
y = c(rnorm(N, 0, 0.25), rnorm(N*0.05,  1.5, 1))
pch = c(rep(0, N), rep(1, (0.05*N))) + 2
d = data.frame(x, y)

rngs = lapply(d, range)
ex = do.call(expand.grid, lapply(rngs, function(x) seq(x[1], x[2], diff(x)/20)))

## create isolation forest
mod = iForest(d, 100, phi=32)
p = predict(mod, d)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$Score <- renderPlot({
    col = ifelse(p > input$threshold, "red", "blue")

    # draw the histogram with the specified number of bins
    plot(d, col = col, pch = pch, cex=2)
    title("Dummy Data with Outliers")
  })

  output$Depth <- renderPlot({
    mod = iForest(d, as.integer(input$ntree), 2^as.integer(input$depth))
    p = predict(mod, ex)
    plt = cbind(ex, z=p)

    lattice::contourplot(z~x+y, plt, cuts=10, labels=TRUE, region=TRUE)
  })
})
