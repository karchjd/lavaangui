library(lavaan)

# Simulate data
set.seed(123)
n <- 50  # number of persons
t <- 10  # number of time points
p <- 3   # number of variables per time point

# Create an empty data frame
data <- data.frame(matrix(NA, nrow = n * t, ncol = p * t))

# Fill the data frame with random data
for (i in 1:(p * t)) {
  data[, i] <- rnorm(n * t)
}

# Naming the variables for clarity
colnames(data) <- c(paste0("x1_t", 1:t), paste0("x2_t", 1:t), paste0("x3_t", 1:t))

# Define the cross-lagged panel model with latent variables
model <- '
  # Define latent variables for each observed variable at each time point
  L1_t1 =~ x1_t1
  L1_t2 =~ x1_t2
  L1_t3 =~ x1_t3
  L1_t4 =~ x1_t4
  L1_t5 =~ x1_t5
  L1_t6 =~ x1_t6
  L1_t7 =~ x1_t7
  L1_t8 =~ x1_t8
  L1_t9 =~ x1_t9
  L1_t10 =~ x1_t10

  L2_t1 =~ x2_t1
  L2_t2 =~ x2_t2
  L2_t3 =~ x2_t3
  L2_t4 =~ x2_t4
  L2_t5 =~ x2_t5
  L2_t6 =~ x2_t6
  L2_t7 =~ x2_t7
  L2_t8 =~ x2_t8
  L2_t9 =~ x2_t9
  L2_t10 =~ x2_t10

  L3_t1 =~ x3_t1
  L3_t2 =~ x3_t2
  L3_t3 =~ x3_t3
  L3_t4 =~ x3_t4
  L3_t5 =~ x3_t5
  L3_t6 =~ x3_t6
  L3_t7 =~ x3_t7
  L3_t8 =~ x3_t8
  L3_t9 =~ x3_t9
  L3_t10 =~ x3_t10

  # Autoregressive paths
  L1_t2 ~ L1_t1
  L1_t3 ~ L1_t2
  L1_t4 ~ L1_t3
  L1_t5 ~ L1_t4
  L1_t6 ~ L1_t5
  L1_t7 ~ L1_t6
  L1_t8 ~ L1_t7
  L1_t9 ~ L1_t8
  L1_t10 ~ L1_t9
  
  L2_t2 ~ L2_t1
  L2_t3 ~ L2_t2
  L2_t4 ~ L2_t3
  L2_t5 ~ L2_t4
  L2_t6 ~ L2_t5
  L2_t7 ~ L2_t6
  L2_t8 ~ L2_t7
  L2_t9 ~ L2_t8
  L2_t10 ~ L2_t9

  L3_t2 ~ L3_t1
  L3_t3 ~ L3_t2
  L3_t4 ~ L3_t3
  L3_t5 ~ L3_t4
  L3_t6 ~ L3_t5
  L3_t7 ~ L3_t6
  L3_t8 ~ L3_t7
  L3_t9 ~ L3_t8
  L3_t10 ~ L3_t9

  # Cross-lagged paths
  L1_t2 ~ L2_t1 + L3_t1
  L2_t2 ~ L1_t1 + L3_t1
  L3_t2 ~ L1_t1 + L2_t1

  L1_t3 ~ L2_t2 + L3_t2
  L2_t3 ~ L1_t2 + L3_t2
  L3_t3 ~ L1_t2 + L2_t2

  L1_t4 ~ L2_t3 + L3_t3
  L2_t4 ~ L1_t3 + L3_t3
  L3_t4 ~ L1_t3 + L2_t3

  L1_t5 ~ L2_t4 + L3_t4
  L2_t5 ~ L1_t4 + L3_t4
  L3_t5 ~ L1_t4 + L2_t4

  L1_t6 ~ L2_t5 + L3_t5
  L2_t6 ~ L1_t5 + L3_t5
  L3_t6 ~ L1_t5 + L2_t5

  L1_t7 ~ L2_t6 + L3_t6
  L2_t7 ~ L1_t6 + L3_t6
  L3_t7 ~ L1_t6 + L2_t6

  L1_t8 ~ L2_t7 + L3_t7
  L2_t8 ~ L1_t7 + L3_t7
  L3_t8 ~ L1_t7 + L2_t7

  L1_t9 ~ L2_t8 + L3_t8
  L2_t9 ~ L1_t8 + L3_t8
  L3_t9 ~ L1_t8 + L2_t8

  L1_t10 ~ L2_t9 + L3_t9
  L2_t10 ~ L1_t9 + L3_t9
  L3_t10 ~ L1_t9 + L2_t9
'

# Fit the model
fit <- sem(model, data = data)

lavaangui(fit)
