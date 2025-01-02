Time Series Analysis is used in the stock markets to identify any patterns, so that an appropriate prediction can be made for future investment decisions. The dataset on which the Time Series analysis is conducted in this study, represents the return (in AUD 100) of a share market trader's investment portfolio. The dataset comprises of 179 observations out of a possible 252 trading days in a year. The aim of the analysis is to find a time series model that fits the dataset and create a prediction for the next 5 trading days.

To identify the best fitting time series model, a series of descriptive analysis is conducted. A visual inspection of the TS plot helps to identify the Trend, Seasonality, Changing Variance, Behavior and Change points. A set of possible models are selected by using the model building strategy. A thorough diagnostic checking is conducted using Residual Analysis to select the best fitting model among quadratic, cosine, cyclical, seasonal or a combination trend model. The best fitting model is then used to develop a prediction for the next five trading days. R programming software is used for this study. Important snippets of the code is provided in the results section and the entire code used for this project can be found in the Appendix Section.

From the Model fitting and residual Analysis, it is quite evident that none of the models can provide a perfect fit. The residual analysis shows a significant seasonality and changing variance which is not being captured by the models above. ACF plots shows significant autocorrelation in the lags despite combining a seasonal model with the quartic model. The leftover auto correlations in the ACF could also indicate a stochastic trend and therefore would require a stochastic trend model in order to find randomness in the residual analysis and a perfectly fitting model for the given dataset. For the purpose of this exercise, forecasting was done with the Quartic model in order to follow the principle of parsimony.

References

•
Dr. Demirhan (2024) ‘Analysis of Trends' [PowerPoint slides, MATH1318], RMIT University, Melbourne.

•
Jonathan D. Cryer and Kung-Sik Chan (2008) Time Series Analysis: With Applications in R, Springer New York, NY
