library("TSA") # calling the Time Series Package
library("readr")
library("dplyr")
library(fUnitRoots)
library(lmtest)
library(tseries)
library(forecast)

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

#Data Pre-processing
temperature <- read_csv("~/OneDrive - RMIT University/Time Series Analysis/Assignment 2/assignment2Data2024.csv")
class(temperature)
summary(temperature) # creating Summary Statistics for the raw data

#Converting to a TS object
temperature_TS <- ts(as.vector(temperature$Anomaly),start=1850, end=2023, frequency = 1) 

class(temperature_TS)
summary(temperature_TS)

#creating a TS plot
plot(temperature_TS,type='o',ylab='Anamolies', 
     main = " Time series plot of Global Land Temperature Anomalies")

#Lag - checking the impact of previous year's temperature anomaly on the next year's temperature anomaly
par(mfrow=c(1,2))
y = temperature_TS
x = zlag(temperature_TS) # generate the first lag of the Global Land Temperature Anomalies time series
head(y)
head(x)
index = 2:length(x) # Create an index to get rid of the first NA value in x
cor(y[index],x[index])
plot(y[index],x[index],ylab='Global Land Temperature Anomalies series', xlab='The first lag of Anomalies series',
     main = "Scatter plot of the series with first lag")

# looking at the second lag

x = zlag(zlag(temperature_TS))
index = 3:length(x)
cor(y[index],x[index]) 

plot(y[index],x[index],ylab='Global Land Temperature Anomalies series', xlab='The first lag of Anomalies series',
     main = "Scatter plot of the series with second lag")
par(mfrow=c(1,1))

#Displying the ACF
acf(temperature_TS, lag.max = 60,main = "ACF of Global Land Temperature Anomalies series")

#--------------------------------------------------------------

#3.2 Model Specification
  #Non-Stationary Models

par(mfrow=c(1,2))
acf(temperature_TS, main ="ACF plot of Global Land Temperature Anomalies series.")
pacf(temperature_TS, main ="PACF plot of Global Land Temperature Anomalies series.")
par(mfrow=c(1,1))

  #checking for normality
qqnorm(temperature_TS, ylab="Anomalies", xlab="Normal Scores")
qqline(temperature_TS, col = 2)
shapiro.test(temperature_TS)

  #Running a Box-Cox Transformation
#BC = BoxCox.ar(temperature_TS)
# We get an error message as there are negative values
temperature_TS2 <- temperature_TS + abs(min(temperature_TS)) + 0.01 #To remove negative values
BC = BoxCox.ar(temperature_TS2)
BC$ci
lambda <- BC$lambda[which(max(BC$loglike) == BC$loglike)]
lambda
BC.temperature_TS = (temperature_TS2^lambda-1)/lambda

plot(BC.temperature_TS,type='o',ylab='Global Land Temperature Anomalies', main = " Time series plot of BC transformed Global Land Temperature Anomalies series")

qqnorm(BC.temperature_TS,ylab="Anomalies", xlab="Normal Scores")
qqline(BC.temperature_TS, col = 2)
shapiro.test(BC.temperature_TS)

adf.test(BC.temperature_TS) #therefore non-stationary

  #Performing differencing
#continuing with the raw data
diff.temperature_TS = diff(temperature_TS2)
plot(diff.temperature_TS,type='o',ylab='First difference of Anomalies', main ="Time series plot of the first difference of 
     the Global Land Temperature Anomalies series.")

  # applying the tests to the differenced series.
adf.test(diff.temperature_TS)
kpss.test(diff.temperature_TS)
pp.test(diff.temperature_TS)


par(mfrow=c(1,2))
acf(diff.temperature_TS, main ="ACF plot of the first difference of the 
    Global Land Temperature Anomalies series.", lag.max = 60)
pacf(diff.temperature_TS, main ="PACF plot of the first difference of 
     Global Land Temperature Anomalies series.", lag.max = 60)
par(mfrow=c(1,1))

  #identifying possible models
eacf(diff.temperature_TS)

res = armasubsets(y=diff.temperature_TS,nar=5,nma=5,y.name='p',ar.method='ols')
plot(res)

#The final set of possible models are :

#  {ARIMA(1,1,1) , ARIMA(1,1,2), ARIMA(0,1,2) , ARIMA(0,1,3), 
#    ARIMA(1,1,3), ARIMA(1,1,0) , ARIMA(2,1,0), ARIMA(2,1,1)}


#---------------------------------------------------------

#3.3 Model Fitting

#ARIMA(0,1,2)
model_012_css = Arima(temperature_TS2,order=c(0,1,2),method='CSS')
lmtest::coeftest(model_012_css)

model_012_ml = Arima(temperature_TS2,order=c(0,1,2),method='ML')
coeftest(model_012_ml)

#ARIMA(0,1,3)
model_013_css = Arima(temperature_TS2,order=c(0,1,3),method='CSS')
lmtest::coeftest(model_013_css)

model_013_ml = Arima(temperature_TS2,order=c(0,1,3),method='ML')
coeftest(model_013_ml)

#ARIMA(1,1,0) 
model_110_css = Arima(temperature_TS2,order=c(1,1,0),method='CSS')
lmtest::coeftest(model_110_css)

model_110_ml = Arima(temperature_TS2,order=c(1,1,0),method='ML')
coeftest(model_110_ml)

#ARIMA(1,1,1) 
model_111_css = Arima(temperature_TS2,order=c(1,1,1),method='CSS')
lmtest::coeftest(model_111_css)

model_111_ml = Arima(temperature_TS2,order=c(1,1,1),method='ML')
coeftest(model_111_ml)

#ARIMA(1,1,2)
model_112_css = Arima(temperature_TS2,order=c(1,1,2),method='CSS')
lmtest::coeftest(model_112_css)

model_112_ml = Arima(temperature_TS2,order=c(1,1,2),method='ML')
coeftest(model_112_ml)

#ARIMA(1,1,3)
model_113_css = Arima(temperature_TS2,order=c(1,1,3),method='CSS')
lmtest::coeftest(model_113_css)

model_113_ml = Arima(temperature_TS2,order=c(1,1,3),method='ML')
coeftest(model_113_ml)

#ARIMA(2,1,0)
model_210_css = Arima(temperature_TS2,order=c(2,1,0),method='CSS')
lmtest::coeftest(model_210_css)

model_210_ml = Arima(temperature_TS2,order=c(2,1,0),method='ML')
coeftest(model_210_ml)

#ARIMA(2,1,1)
model_211_css = Arima(temperature_TS2,order=c(2,1,1),method='CSS')
lmtest::coeftest(model_211_css)

model_211_ml = Arima(temperature_TS2,order=c(2,1,1),method='ML')
coeftest(model_211_ml)

# AIC and BIC values
sort.score(AIC(model_012_ml,model_013_ml,model_110_ml,model_111_ml,model_112_ml,model_113_ml,model_210_ml,model_211_ml), score = "aic")
sort.score(BIC(model_012_ml,model_013_ml,model_110_ml,model_111_ml,model_112_ml,model_113_ml,model_210_ml,model_211_ml), score = "bic" )

# Error Measures
Smodel_012_css <- accuracy(model_012_css)[1:7]
Smodel_013_css <- accuracy(model_013_css)[1:7]
Smodel_110_css <- accuracy(model_110_css)[1:7]
Smodel_111_css <- accuracy(model_111_css)[1:7]
Smodel_112_css <- accuracy(model_112_css)[1:7]
Smodel_113_css <- accuracy(model_113_css)[1:7]
Smodel_210_css <- accuracy(model_210_css)[1:7]
Smodel_211_css <- accuracy(model_211_css)[1:7]
df.Smodels <- data.frame(
  rbind(Smodel_012_css,Smodel_013_css,Smodel_110_css,Smodel_111_css,Smodel_112_css,
        Smodel_113_css,Smodel_210_css, Smodel_211_css)
)
colnames(df.Smodels) <- c("ME", "RMSE", "MAE", "MPE", "MAPE", 
                          "MASE", "ACF1")
rownames(df.Smodels) <- c("ARIMA(0,1,2)", "ARIMA(0,1,3)", "ARIMA(1,1,0)", 
                          "ARIMA(1,1,1)", "ARIMA(1,1,2)", "ARIMA(1,1,3)", "ARIMA(2,1,0)", "ARIMA(2,1,1)")
round(df.Smodels,  digits = 3)

#Best Model ARIMA(2,1,0)

#ARIMA(3,1,0) and ARIMA(2,1,1) are over parametrised models for ARIMA(2,1,0)

# ARIMA(3,1,0)
model_310_css = Arima(temperature_TS2,order=c(3,1,0),method='CSS')
coeftest(model_310_css)

model_310_ml = Arima(temperature_TS2,order=c(3,1,0),method='ML')
coeftest(model_310_ml)

# ARIMA(2,1,1)
model_211_css = Arima(temperature_TS2,order=c(2,1,1),method='CSS')
coeftest(model_211_css)

model_211_ml = Arima(temperature_TS2,order=c(2,1,1),method='ML')
coeftest(model_211_ml)

#Best Model ARIMA(2,1,0)
