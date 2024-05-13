
if (!require(plotly)) install.packages("plotly")
if (!require(processx)) install.packages("processx")

plot_data <- function(x, y, z, type = "surface") {
  print(plot_ly(x = x, y = y, z = z, type = type))
}

plot_function <- function(f, type = "surface") {
  x <- 1:100 / 10
  y <- x
  z <- mapply(function(xi) mapply(function(yi) f(xi, yi), y), x)
  plot_data(x, y, z, type)
}

plot_zeros <- function(f, g) {
  plot_function(function(x, y) f(x, y) - g(x, y), type = "contour")
}

# f <- function(x, y) x**2
# g <- function(x, y) y**2

# plot_function(f)
# plot_zeros(f, g)