# Applied regression activity
# Visualization and modeling

# Load packages
library(tidyverse)
library(janitor)
library(broom)
library(car)

# Load data
load("data/analysis/analytical_data.RData")

# Preliminary data cleaning
analytical_data <- analytical_data |>
  filter(!is.na(violence))

# For a more complicated analysis, I would further investigate why certain instances of violence were listed as NA. Depending on the research question or purpose of analysis, it may not be appropriate to remove NA values.

# Scatterplot with regression line
ggplot(analytical_data, aes(x = density, y = deprivation)) +
  geom_point() +
  geom_smooth(method = "lm")

# Scatterplot with log(deprivation), and regression line
ggplot(analytical_data, aes(x = density,              # predictor
                            y = log(deprivation))) +  # outcome
  geom_point() +
  geom_smooth(method = "lm")

# Scatterplot: effect of deprivation on violence, with regression line
ggplot(analytical_data, aes(x = deprivation,
                            y = violence)) +
  geom_point() +
  geom_smooth(method = "lm")

# Scatterplot: effect of deprivation on violence, with curved regression line (using quadtratic)
ggplot(analytical_data, aes(x = deprivation,
                            y = violence)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2))

# Scatterplot: effect of deprivation on violence
# Regression line in red
# Curved regression line in blue (using quadtratic)
ggplot(analytical_data, aes(x = deprivation,
                            y = violence)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2)) +
  geom_smooth(method = "lm", formula = y ~ x, color = "red")

# Effect of deprivation on crime, controlling for population density
lm_1 <- lm(violence ~ deprivation + density, data = analytical_data)
tidy(lm_1)

# Explanation: One unit increase in deprivation is associated with a 0.35 increase in violence, controlling for population density. Weakly positive relationship and statistically significant evidenced by low p-value.

# Which model is better?: Compare how much of the variance is explained by each model.
# Run ANOVA
lm_2 <- lm(violence ~ density, data = analytical_data)
anova(lm_1, lm_2)

# The first model, using deprivation to predict violence while controlling for population density, is better than the second model, using deprivation alone to predict violence. This is evidenced by the fact that the first model has a much smaller RSS and a small p-value.

# Overall fit of the model
summary(lm_1)

# While the first model is a better fit than the second model, the r^2 shows that only around 7% of the variation in violence is explained by deprivation and population density.

# Predict violence given a certain level of deprivation and population density
predict(lm_1, newdata = data.frame(deprivation = 30,
                                   density = 10000))

# Predict violence for all rows, and print the last few values
predict(lm_1, newdata = analytical_data) |> tail()

# Compare with fitted model predictions, and print the last few values
fitted(lm_1) |> tail()

# Relationship between deprivation and violence after controlling for density. Visualizes the contribution of deprivation to explaining the variation in violence.
avPlot(lm_1, variable = "deprivation")
ggplot(analytical_data, aes(x = deprivation, y = violence)) +
  geom_point() +
  geom_smooth(method = "lm")

# Scatterplot
# x = .fitted, the model's predicted violence counts
# y =.resid, the difference between the actual violence counts and the model's predicted violence counts

lm_1 |>
  augment() |>
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_smooth()