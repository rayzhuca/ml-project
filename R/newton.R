# source("zeros.R")
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


# newton method functions
root1d <- function(f, fPrime, guess, tol) {
    x <- guess
    eps <- 0
    while (abs(f(x)) > tol) {
        x <- x - f(x) / fPrime(x)
        eps <- eps + 1
    }
    x
}


# estimates the `i`th partial derivative of a function `f`` with input dimension `dim` on `x`
pderiv <- function(f, i, x, dim) {
    h <- rep(0, dim)
    h[i] <- 0.00001
    (do.call(f, as.list(x + h)) - do.call(f, as.list(x - h))) / (2 * h[i])
}


# fPrimes is a vector of partial derivatives of f
root <- function(f, dim, tol, grad = NA, learning_rate = 0.01, max_iter = Inf, guess = NA) {
    no_grad <- all(is.na(grad))
    no_guess <- all(is.na(guess))

    x <- `if`(no_guess, rep(0, dim), guess)
    eps <- 0
    d <- rep(0, dim)
    f_x <- do.call(f, as.list(x))

    while (abs(f_x) > tol & eps < max_iter) {
        if (no_grad) {
            for (i in 1:dim) {
                d[i] = pderiv(f, i, x, dim)
            }
        } else {
            d <- mapply(do.call, grad, list(as.list(x)))
        }
        
        x <- x - learning_rate * d / f_x
        f_x <- do.call(f, as.list(x))
        eps <- eps + 1
    }
    x
}

# g <- function(x, y) (x - 2) * (y - 2)
# gGrad <- c(function(x, y) y - 2, function(x, y) x - 2)
# gGuess <- c(5, 10)

# print("test with grad")

# x <- root(g, 2, tol, guess = gGuess, grad=gGrad, max_iter=10000000)
# print(x)
# print(do.call(g, as.list(x)))

# print("test without grad")

# x <- root(g, 2, tol, guess = gGuess, max_iter=10000000)
# print(x)
# print(do.call(g, as.list(x)))
