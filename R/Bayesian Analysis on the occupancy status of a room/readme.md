This project contains the work completed for the Applied Bayesian Statistics (MATH2269) final project. 

The project involves predicting the occupancy status of a room based on various environmental factors using Robust Logistic Bayesian Regression implemented in JAGS.

**Dataset**

The dataset used for this project is sourced from the UC Irvine Machine Learning Repository. It contains 20,560 instances, but for this study, a subset of 500 instances is used for training, with 21 instances reserved for testing. The dataset consists of the following features:

* Temperature (continuous)
* Humidity (continuous)
* Light (continuous)
* Humidity Ratio (continuous)
* CO2 (continuous)
* Occupancy Status (binary: 1 = occupied, 0 = not occupied)

To model the Occupancy status using the other predictors, Robust Logistic Bayesian regression analysis using JAGS Model is conducted. The analysis starts off at descriptive level to identify the mathematical model, which further helps in identifying and setting up the prior distribution. Based on the prior distribution, a suitable Bayesian model is used to conduct the analysis. Diagnostic checking is done on the mean and variance to ensure that the model fits well. Based on the suitability, predictions are made for the occupation status.

**Findings**

With every unit increase in temperature, the likelihood of room occupancy is 2.5 times the likelihood of non occupancy. This suggests a strong positive relationship between temperature and the likelihood of occupancy, implying that higher temperatures may be associated with occupied spaces. With every unit increase in Humidity, the likelihood of
room non-occupancy is 2.46 times the likelihood of occupancy. This negative relationship suggests that higher humidity levels may be associated with unoccupied spaces. With every unit increase in light, the likelihood of room occupancy is 1.02 times the likelihood of non occupancy. With every unit increase in CO2, the likelihood of room occupancy is 1.009 times the likelihood of non occupancy. In both these cases, since the odds ratio is so close to 1, it could also be interpreted that light and CO2 have no association with the occupancy of a room. In other words, the odds of occupancy given there is light or CO2 is the same as the odds of occupancy given there is no light or CO2. The odds ratio for Humidity ratio is 0, indicating that as the humidity ratio increases the likelihood of occupancy approaches 0.

**References**
* Dr. Demirhan (2024) ‘Logistic Regression’ [PowerPoint slides, MATH2269], RMIT University, Melbourne
* Goodwin, G., & Ryu, S. Y. (2023). Understanding the odds: Statistics in public health. Frontiers for Young Minds, 10. https://doi.org/10.3389/frym.2022.926624
* UCI Machine Learning Repository. (n.d.). https://archive.ics.uci.edu/dataset/357/occupancy+detection
