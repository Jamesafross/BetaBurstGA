set.seed(1)

x <- rnorm(50)
y <- rnorm(50)
# Do x and y come from the same distribution?
ks.test(x, y)
