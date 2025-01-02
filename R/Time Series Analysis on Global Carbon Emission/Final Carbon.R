library(TSA)
library(fUnitRoots)
library(lmtest)
library(tseries)
library(readr)
library(forecast)
library(Hmisc)

#adding the sort function
sort.score <- function(x, score = c("bic", "aic")){
  if (score == "aic"){
    x[with(x, order(AIC)),]
  } else if (score == "bic") {
    x[with(x, order(BIC)),]
  } else {
    warning('score = "x" only accepts valid arguments ("aic","bic")')
  }
}

residual.analysis <- function(model, std = TRUE,start = 2, class = "ARIMA"[1]){
  library(TSA)
  library(LSTS)
  if (class == "ARIMA"){
    if (std == TRUE){
      res.model = rstandard(model)
    }else{
      res.model = residuals(model)
    }
  }else if (class == "GARCH"){
    res.model = model$residuals[start:model$n.used]
  }else if (class == "ARMA-GARCH"){
    res.model = model@fit$residuals
  }else if (class == "fGARCH"){
    res.model = model@residuals
  }else {
    stop("The argument 'class' must be either 'ARIMA' or 'GARCH' ")
  }
  par(mfrow=c(2,2))
  plot(res.model,type='o',ylab='Standardised residuals', main="Time series plot of standardised residuals")
  abline(h=0)
  hist(res.model,main="Histogram of standardised residuals")
  qqnorm(res.model,main="QQ plot of standardised residuals")
  qqline(res.model, col = 2)
  acf(res.model,main="ACF of standardised residuals")
  Box.Ljung.Test(res.model)
  print(shapiro.test(res.model))
  print(Box.test(res.model, type = "Ljung-Box"))
  print(Box.Ljung.Test(res.model))
  par(mfrow=c(1,1))
}

#Data Preprocessing
carbon <-read_csv("~/Downloads/Book6.csv")
class(carbon)
summary(carbon)
plot(carbon,type='o',ylab='carbon for electricity')

# Convert to the TS object!
carbon_TS <- ts(as.vector(carbon$Total),start=1959, end=2014) 
class(carbon_TS)
summary(carbon_TS)

plot(carbon_TS,type='o',ylab='Fossil fuel emissions', 
     main = " Time series plot of annual Fossil fuel emissions")

#Lag - checking the impact of previous year's Fossil fuel emissions on the next year's emissions
par(mfrow=c(1,2))
y = carbon_TS
x = zlag(carbon_TS) # generate the first lag of the Fossil fuel emissions time series
head(y)
head(x)
index = 2:length(x) # Create an index to get rid of the first NA value in x
cor(y[index],x[index])
plot(y[index],x[index],ylab='Fossil fuel emissions series', xlab='The first lag of Fossil fuel emissions series',
     main = "Scatter plot of the series with first lag")

# looking at the second lag
x = zlag(zlag(carbon_TS))
index = 3:length(x)
cor(y[index],x[index]) 

plot(y[index],x[index],ylab='Fossil fuel emissions series', xlab='The second lag of Fossil fuel emissions series',
     main = "Scatter plot of the series with second lag")
par(mfrow=c(1,1))

#Displying the ACF
acf(carbon_TS, lag.max = 60,main = "ACF of Fossil fuel emissions series")

#3.2 Model Specification

#ACF and PACF plots
par(mfrow=c(1,2))
acf(carbon_TS, main ="ACF plot of Fossil fuel emissions series.")
pacf(carbon_TS, main ="PACF plot of Fossil fuel emissions series.")
par(mfrow=c(1,1))

#slowly decaying trend in ACF and one significant lag in PACF indicates a trend and possible seasonality
#also indicates that the series is non-stationary

#checking for normality
qqnorm(carbon_TS, ylab="Fossil fuel emissions", xlab="Normal Scores")
qqline(carbon_TS, col = 2)
shapiro.test(carbon_TS) #Normal Data

#shapiro wilk test p-value is greater than 0.05 so it is normal, however the plot shows a couple of datapoints straying away from the QQ line

#Running a Box-Cox Transformation
BC = BoxCox.ar(carbon_TS) 
BC$ci
lambda <- BC$lambda[which(max(BC$loglike) == BC$loglike)]
lambda #Since lambda is positive but close to 0, so its near log transformation
BC.carbon_TS = (carbon_TS^lambda-1)/lambda

plot(BC.carbon_TS,type='o',ylab='Fossil fuel emissions',
     main = " Time series plot of BC transformed Fossil fuel emissions series")

#Since there was not a lot of changing variance the BC transformation didnt make much of a difference in the TS plot

#checking for normality
qqnorm(BC.carbon_TS, ylab="Fossil fuel emissions", xlab="Normal Scores")
qqline(BC.carbon_TS, col = 2)
shapiro.test(BC.carbon_TS) 

#The normality on the BC transformed data showed a slightly lower p-value. So I have decided to go ahead with the raw data for differencing and detrending the data.

adf.test(carbon_TS) #therefore non-stationary

diff.carbon_TS = diff(carbon_TS,differences = 1)
plot(diff.carbon_TS,type='o',ylab='Fossil fuel emissions series', 
     main ="Time series plot of the first difference of
      Fossil fuel emissions series")

#The plot looks better than the original time series plot. the series seems to have been detrended

# applying the tests to the differenced series.
adf.test(diff.carbon_TS) #stationary
kpss.test(diff.carbon_TS) # Stationary
pp.test(diff.carbon_TS) #Stationary

par(mfrow=c(1,2))
acf(diff.carbon_TS, main ="ACF plot of the first difference of
      Fossil fuel emissions series", lag.max = 60)
pacf(diff.carbon_TS, main ="PACF plot of the first difference of 
     Fossil fuel emissions series", lag.max = 60)
par(mfrow=c(1,1))

#p =1, q=1, d=1 Possible model from ACF and PACF ARIMA{1,1,1}. 
#the significant lag in PACF after 20 is not considered as it is a late lag

#identifying possible models
eacf(diff.carbon_TS)

#possible models from EACF
#ARIMA {1,1,0}, ARIMA {1,1,1},ARIMA {2,1,0},ARIMA {2,1,1}

res = armasubsets(y=diff.carbon_TS,nar=5,nma=5,y.name='p',ar.method='ols')
plot(res)

#The best model from BIC Table is ARIMA {1,1,0} and ARIMA {4,1,0}

#The final set of possible models are :
# ARIMA {1,1,0}, ARIMA {4,1,0},ARIMA {1,1,1},ARIMA {2,1,0},ARIMA {2,1,1}

#3.3 Model Fitting

#using raw data
#ARIMA(1,1,0)
model_110_css = Arima(carbon_TS,order=c(1,1,0),method='CSS')
lmtest::coeftest(model_110_css)

model_110_ml = Arima(carbon_TS,order=c(1,1,0),method='ML')
coeftest(model_110_ml)

#All significant coefficients in both ML and CSS

#ARIMA{4,1,0} 
model_410_css = Arima(carbon_TS,order=c(4,1,0),method='CSS')
lmtest::coeftest(model_410_css)

model_410_ml = Arima(carbon_TS,order=c(4,1,0),method='ML')
coeftest(model_410_ml)

#2 out of 4 significant coefficients in both ML and CSS

#ARIMA {1,1,1}
model_111_css = Arima(carbon_TS,order=c(1,1,1),method='CSS')
lmtest::coeftest(model_111_css)

model_111_ml = Arima(carbon_TS,order=c(1,1,1),method='ML')
coeftest(model_111_ml)

#All significant coefficients in both ML and CSS

#ARIMA {2,1,0}
model_210_css = Arima(carbon_TS,order=c(2,1,0),method='CSS')
lmtest::coeftest(model_210_css)

model_210_ml = Arima(carbon_TS,order=c(2,1,0),method='ML')
coeftest(model_210_ml)

# inconsistent results, so conducted CSS-ML
model_210_CSSml = Arima(carbon_TS,order=c(2,1,0),method='CSS-ML')
coeftest(model_210_CSSml)

#One of two insignificant coefficients

#ARIMA {2,1,1}
model_211_css = Arima(carbon_TS,order=c(2,1,1),method='CSS')
lmtest::coeftest(model_211_css)

model_211_ml = Arima(carbon_TS,order=c(2,1,1),method='ML')
coeftest(model_211_ml)

# contradicting results, so conducted CSS-ML
model_211_CSSml = Arima(carbon_TS,order=c(2,1,1),method='CSS-ML')
coeftest(model_211_CSSml)

#All significant coefficients in 2 out 3 tests


# AIC and BIC values
sort.score(AIC(model_110_ml,model_410_ml,model_111_ml,model_210_ml,model_211_ml), score = "aic")
sort.score(BIC(model_110_ml,model_410_ml,model_111_ml,model_210_ml,model_211_ml), score = "bic" )

# The ARIMA(1,1,1) and ARIMA(2,1,1) model are the best ones according to AIC and BIC

#Error Measures
Smodel_110_ml <- accuracy(model_110_ml)[1:7]
Smodel_410_ml <- accuracy(model_410_ml)[1:7]
Smodel_111_ml <- accuracy(model_111_ml)[1:7]
Smodel_210_ml <- accuracy(model_210_ml)[1:7]
Smodel_211_ml <- accuracy(model_211_ml)[1:7]

df.Smodels <- data.frame(
  rbind(Smodel_110_ml,Smodel_410_ml,Smodel_111_ml,Smodel_210_ml,Smodel_211_ml)
)
colnames(df.Smodels) <- c("ME", "RMSE", "MAE", "MPE", "MAPE", 
                          "MASE", "ACF1")

rownames(df.Smodels) <- c("ARIMA {1,1,0}", "ARIMA {4,1,0}","ARIMA {1,1,1}","ARIMA {2,1,0}","ARIMA {2,1,1}")
round(df.Smodels,  digits = 3)

#ARIMA(2,1,1) model has the lowest error measures across all the different types of errors

# The best model out of all is ARIMA(2,1,1)

# Overfitting: To further assess the selected model ARIMA(2,1,1) by overfitting
# ARIMA(3,1,1) and ARIMA(2,1,2)

# ARIMA(3,1,1)
model_311_css = Arima(carbon_TS,order=c(3,1,1),method='CSS')
lmtest::coeftest(model_311_css)

model_311_ml = Arima(carbon_TS,order=c(3,1,1),method='ML')
coeftest(model_311_ml)

#All significant model, so we have an additional model to consider

#ARIMA(2,1,2)
model_212_css = Arima(carbon_TS,order=c(2,1,2),method='CSS')
lmtest::coeftest(model_212_css)

model_212_ml = Arima(carbon_TS,order=c(2,1,2),method='ML')
coeftest(model_212_ml)

# inconsistent results, so conducted CSS-ML
model_212_CSSml = Arima(carbon_TS,order=c(2,1,2),method='CSS-ML')
coeftest(model_212_CSSml)

# 3 out of 4 coefficients are significant

# Now I will consider ARIMA(3,1,1) among the others.

sort.score(AIC(model_110_ml,model_410_ml,model_111_ml,model_210_ml,model_211_ml,model_311_ml), score = "aic")
sort.score(BIC(model_110_ml,model_410_ml,model_111_ml,model_210_ml,model_211_ml,model_311_ml), score = "bic" )

#The AIC and BIC is not so great for the new model, we can conduct a residual analysis to confirm
#Error Measures
Smodel_110_ml <- accuracy(model_110_ml)[1:7]
Smodel_410_ml <- accuracy(model_410_ml)[1:7]
Smodel_111_ml <- accuracy(model_111_ml)[1:7]
Smodel_210_ml <- accuracy(model_210_ml)[1:7]
Smodel_211_ml <- accuracy(model_211_ml)[1:7]
Smodel_311_ml <- accuracy(model_311_ml)[1:7]
df.Smodels <- data.frame(
  rbind(Smodel_110_ml,Smodel_410_ml,Smodel_111_ml,Smodel_210_ml,Smodel_211_ml,Smodel_311_ml)
)
colnames(df.Smodels) <- c("ME", "RMSE", "MAE", "MPE", "MAPE", 
                          "MASE", "ACF1")

rownames(df.Smodels) <- c("ARIMA {1,1,0}", "ARIMA {4,1,0}","ARIMA {1,1,1}","ARIMA {2,1,0}","ARIMA {2,1,1}", "ARIMA {3,1,1}")
round(df.Smodels,  digits = 3)

#ARIMA(3,1,1) model has the lowest values in 3 error measures.

#Model Diagnostics

residual.analysis(model = model_211_ml) # Best model
residual.analysis(model = model_311_ml) # New model
residual.analysis(model = model_311_css) # New model

#All the tests looks good except for a bar in the histogram. The p value in Box-Ljung test is highest for model 211, so is the significance for normality
#Model 211 is also the smaller model, so we can go ahead with it.

residual.analysis(model = model_111_ml) # testing

# testing out other models - not included in the report as they are not good models
residual.analysis(model = model_410_ml)
residual.analysis(model = model_110_ml)
residual.analysis(model = model_210_ml)

#111 model with a histogram within +3 and -3 but has a significant lag in ACF but nothing in the Box-Ljung test
#Could potentially take 111 or check GARCH models?

par(mfrow=c(1,1))


#Model Forecasting - 111
frcCSS = forecast::forecast(model_111_css,h=10)
plot(frcCSS) 
lines(Lag(fitted(model_111_css),-1), col= "blue")
legend("topleft", lty=1, pch=1, col=c("blue","black"), text.width = 5, c("Data", "Fitted "))
frcCSS

frcML = forecast::forecast(model_111_ml,h=10)
plot(frcML) 
lines(Lag(fitted(model_111_ml),-1), col= "blue")
legend("topleft", lty=1, pch=1, col=c("blue","black"), text.width = 5, c("Data", "Fitted "))
frcML
