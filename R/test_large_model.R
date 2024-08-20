library(lavaan)

# Number of variables
num_vars <- 100

# Create variable names
variables <- paste0("V", 1:num_vars)

# Create a complicated SEM model with multiple latent variables and paths
sem_model <- "
# Latent variables
LV1 =~ V1 + V2 + V3 + V4 + V5
LV2 =~ V6 + V7 + V8 + V9 + V10
LV3 =~ V11 + V12 + V13 + V14 + V15
LV4 =~ V16 + V17 + V18 + V19 + V20
LV5 =~ V21 + V22 + V23 + V24 + V25
LV6 =~ V26 + V27 + V28 + V29 + V30
LV7 =~ V31 + V32 + V33 + V34 + V35
LV8 =~ V36 + V37 + V38 + V39 + V40
LV9 =~ V41 + V42 + V43 + V44 + V45
LV10 =~ V46 + V47 + V48 + V49 + V50

# Higher-order latent variables
HLV1 =~ LV1 + LV2 + LV3 + LV4 + LV5
HLV2 =~ LV6 + LV7 + LV8 + LV9 + LV10

# Complex paths
HLV1 ~ LV6 + LV7
HLV2 ~ LV3 + LV4

# Interactions
LV1 ~ LV6*LV7
LV2 ~ LV8*LV9
LV3 ~ LV5*LV10

# Residual correlations
V51 ~~ V52 + V53
V54 ~~ V55 + V56
V57 ~~ V58 + V59
V60 ~~ V61 + V62
V63 ~~ V64 + V65
V66 ~~ V67 + V68
V69 ~~ V70 + V71
V72 ~~ V73 + V74
V75 ~~ V76 + V77
V78 ~~ V79 + V80

# Regressions between observed variables
V81 ~ V82 + V83 + V84
V85 ~ V86 + V87 + V88
V89 ~ V90 + V91 + V92
V93 ~ V94 + V95 + V96
V97 ~ V98 + V99 + V100
"

# Simulate data based on the model
set.seed(123)
sim_data <- simulateData(sem_model, sample.nobs = 100)

# Fit the model to the simulated data
fit_big <- sem(sem_model, data = sim_data)

# Summary of the model fit
summary(fit, fit.measures = TRUE, standardized = TRUE)
