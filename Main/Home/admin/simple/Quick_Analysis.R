library(dplyr)

library(magrittr)

library(MASS)

data <- read.csv("workingdata.csv")
 
# remove numbering column
#data <- data %>% select(-no)

hist(data$y) # right skewed
hist(data$x1) # a little right skewed
hist(data$x2) # very right skewed
hist(data$x3)
hist(data$x4) # some high outliers
hist(data$x5) # factor, mostly 1s and 2s

data$x5 <- as.factor(data$x5)

# The categorical variable x5 is itself a significant term for predicting the response variable y. However, it may be risky to use ANOVA when the response variable is so right skewed. We should consider transforming the data to something more normal.
aov(data = data, y ~ x5)

# Also should consider other predictors.
# Remove outliers
data <- data %>% filter(x2 < 10000000 & x4 < 1)

# Try a few different models. x2 is also quite right skewed. Some variables are not good predictors.
lm(data = data, y ~ x1 + log(x2) + x3 + x4 + x5) %>% summary
lm(data = data, y ~ x1 + log(x2) + x3 + x5) %>% summary
lm(data = data, log(y) ~ x1 + log(x2) + x3 + x5) %>% summary

# Stepwise model selection leads us to this final model with x1, log(x2), x3, and x5 as predictors for log(y). Since the data has been transformed, you will need to undo the transformation when interpreting coefficients. To summarize, however, x1 and the third category in x5 are positively correlated with the log of the response variable y. log(x2), x3, and the second category in x5 are the opposite.

# Given the relationship between linear regression and ANCOVA, we can see similar results when using the same model in ANOVA. x1, log(x2), x3, and x5 are significant predictors of the response variable log(y).

aov(data = data, log(y) ~ x1 + log(x2) + x3 + x5) %>% summary
