library("TSA") # calling the Time Series Package
library("readr")
library("dplyr")
#x11()

#Section 3.1 Descriptive Analysis

#Data Preprocessing
stock <- read_csv("~/OneDrive - RMIT University/Time Series Analysis/Assignment 1/assignment1Data2024.csv")
class(stock)
colnames(stock)[1:2]<- c("DayNo","returns") # converting the column name

summary(stock) # creating Summary Statistics for the raw data

#Converting to a TS object
Stock_TS <- ts(as.vector(stock$returns),start = c(1,1),end =c(1,179), frequency = 1) 
class(Stock_TS)
summary(Stock_TS)

#creating a TS plot
par(mfrow=c(1,2))
plot(Stock_TS,type='o',ylab='Return on portfolio(in AUD100)', 
     main = " Time series plot of Return on investment portfolio")
# Adding weekdays label to check seasonality
stock <- rbind(stock, list('180', "0")) # creating an additional row to add label as 179 is not divisible by 5
stock<- stock %>% mutate(days = rep(c("M","T","W","Th","F"),times =36))
stock<- stock[-c(180),]# deleting the new row created earlier
plot(Stock_TS,type='l',ylab='Return on portfolio(in AUD100)', 
     main = " Time series plot of Return on investment portfolio with labels")
points(y = Stock_TS, x = time(Stock_TS),
       pch = stock$days) #checking seasonality based on days label

#Lag - checking the impact of previous day's returns on the next day's return
y = Stock_TS
x = zlag(Stock_TS) # generate the first lag of the returns time series
head(y)
head(x)
index = 2:length(x) # Create an index to get rid of the first NA value in x
cor(y[index],x[index])
plot(y[index],x[index],ylab='returns series', xlab='The first lag of returns series',
     main = "Scatter plot of the series with first lag")

# looking at the second lag
x = zlag(zlag(Stock_TS))
index = 3:length(x)
cor(y[index],x[index]) 

plot(y[index],x[index],ylab='returns series', xlab='The second lag of returns series'
     ,main = "Scatter plot of the series with second lag")

#Displying the ACF
acf(Stock_TS, lag.max = 60,main = "ACF of solar return series")
#--------------------------------------------------------------------
#Section 3.2 Model building Strategy

# 3.2.1 Linear trend Model
t <- time(Stock_TS) # Get a continuous time points in TS
model1<- lm(Stock_TS ~ t) # 
summary(model1)

  #Fitting the Model
fitted.model1 <- fitted(model1) #alternate method
plot(Stock_TS,ylab='returns series',xlab='Days',type='o',
     main = "Time series plot of Return on investment portfolio")
abline(model1) # add the fitted linear trend line

  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model1),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from linear model")
#plotting a histogram
hist(rstudent(model1),xlab='Standardized Residuals', main = "Histogram of standardised residuals from linear model")
# QQ plot
y = rstudent(model1)
qqnorm(y, main = "QQ plot of standardised residuals for the linear model")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model1), main = "ACF of standardized residuals for the linear model")
par(mfrow=c(1,1))



#3.2.2 Model 2 - quadratic model
t = time(Stock_TS)
t2 = t^2 # Create t^2
model2 = lm(Stock_TS ~ t + t2)
summary(model2)

  #Fitting the model
fitted.model2 <- fitted(model2)
plot(ts(fitted.model2), ylim = c(min(c(fitted(model2), as.vector(Stock_TS))), max(c(fitted(model2),as.vector(Stock_TS)))),
     ylab='y' , main = "Fitted quadratic curve to return series", type="l",lty=2,col="red")
lines(as.vector(Stock_TS),type="o")

  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model2),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from quadratic model.")
#plotting a histogram
hist(rstudent(model2),xlab='Standardized Residuals', main = "Histogram of standardised residuals for the quadratic model")
# plotting QQ plot
y = rstudent(model2)
qqnorm(y, main = "QQ plot of standardised residuals for the quadratic model
fitted to the return series.")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model2)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model2), main = "ACF of standardized residuals the quadratic model
fitted to the return series.")
par(mfrow=c(1,1))

#3.2.3 Model 3 - Seasonal model
Weekday. <- factor(stock$days,levels = c( "M","T","W","Th","F"))
model3=lm(Stock_TS ~ Weekday.-1) # -1 removes the intercept term
summary(model3)

  #Fitting the Model
plot(ts(fitted(model3)), ylab='returns series', main = "Fitted seasonal model to returns series.",
     ylim = c(-50,250), col = "red" )
lines(as.vector(Stock_TS),type="o")

  #Residual Analysis
#Model 3- seasonal model
par(mfrow=c(2,2))
plot(y=rstudent(model3),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from seasonal model")
points(y=rstudent(model3),x=as.vector(time(Stock_TS)),
       pch=as.vector(stock$days))
#plotting a histogram
hist(rstudent(model3),xlab='Standardized Residuals', main = "Histogram of standardised residuals for the seasonal model")
#plotting qq plot
y = rstudent(model3)
qqnorm(y, main = "QQ plot of standardised residuals for the seasonal model
fitted to the returns series.")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model3)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model3), main = "ACF of standardized residuals the seasonal model
fitted to the return series.")
par(mfrow=c(1,1))


#3.2.4 Model 4 - Cosine model
#creating a new TS object as harmonic model requires a frequency of more than 1
Stock_TS_5 <- ts(as.vector(stock$returns),start = c(1,1),end =c(1,179), frequency = 5) 
har. <- harmonic(Stock_TS_5, 1) # calculate cos(2*pi*t) and sin(2*pi*t)
data <- data.frame(Stock_TS_5,har.)
model4 <- lm(Stock_TS_5 ~ cos.2.pi.t. + sin.2.pi.t. , data = data)
summary(model4)
  #Fitting the model
par(mfrow=c(1,1))
plot(ts(fitted(model4)), ylab='returns series', main = "Fitted cosine wave to returns series.",
     ylim = c(-50,250), col = "green" )
lines(as.vector(Stock_TS_5),type="o")
  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model4),x=as.vector(time(Stock_TS_5)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Time series plot of standardised residuals for the cosine wave")
#Plotting histogram
hist(rstudent(model4),xlab='Standardized Residuals', main = "Histogram of standardised residuals for the cosine wave")
#QQ plot
y = rstudent(model4)
qqnorm(y, main = "QQ plot of standardised residuals for the cosine wave")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model4)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model4), main = "ACF of standardized residuals for the cosine model")
par(mfrow=c(1,1))

# #3.2.5 Model 5 Cubic model
t = time(Stock_TS)
t2 = t^2 # Create t^2
t3 = t^3
model5 = lm(Stock_TS ~ t + t2+t3)
summary(model5)

  #Fitting the model
fitted.model5 <- fitted(model5)
plot(ts(fitted.model5), ylim = c(min(c(fitted(model5), as.vector(Stock_TS))), max(c(fitted(model5),as.vector(Stock_TS)))),
     ylab='y' , main = "Fitted cubic curve to return series", type="l",lty=2,col="red")
lines(as.vector(Stock_TS),type="o")

  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model5),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from cubic model.")
#plotting a histogram
hist(rstudent(model5),xlab='Standardized Residuals', main = "Histogram of standardised residuals for the cubic model")
# plotting QQ plot
y = rstudent(model5)
qqnorm(y, main = "QQ plot of standardised residuals for the quadratic model
fitted to the return series.")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model5)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model5), main = "ACF of standardized residuals the cubic model
fitted to the return series.")

#3.2.6 Model 6 :seasonal plus quartic time trend model
t = time(Stock_TS)
t2 = t^2 # Create t^2
t3 = t^3
t4 = t^4 # takes into account the curve
model6 = lm(Stock_TS~ Weekday. + t + t2+t3+t4 -1)
summary(model6)

  #Fitting the model
fitted.model6 <- fitted(model6)
plot(ts(fitted(model6)),ylim = c(min(c(fitted(model6), as.vector(Stock_TS))), max(c(fitted(model6),as.vector(Stock_TS)))),
     ylab='y' , main = "Fitted seasonal plus quadratic curve to return series", type="l",lty=2,col="red")
lines(as.vector(Stock_TS),type="o")

  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model6),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from linear model")
#plotting a histogram
hist(rstudent(model6),xlab='Standardized Residuals', main = "Histogram of standardised residuals from linear model")
# QQ plot
y = rstudent(model6)
qqnorm(y, main = "QQ plot of standardised residuals for the linear model")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model6)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model6), main = "ACF of standardized residuals for the linear model")
par(mfrow=c(1,1))

# #3.2.7 model 7 Quartic Model
t = time(Stock_TS)
t2 = t^2 # Create t^2
t3 = t^3
t4 = t^4
model7 = lm(Stock_TS ~ t + t2+t3+t4)
summary(model7)

  #Fitting the model
fitted.model7 <- fitted(model7)
plot(ts(fitted.model7), ylim = c(min(c(fitted(model7), as.vector(Stock_TS))), max(c(fitted(model7),as.vector(Stock_TS)))),
     ylab='y' , main = "Fitted Quartic curve to return series", type="l",lty=2,col="red")
lines(as.vector(Stock_TS),type="o")

  #Residual Analysis
par(mfrow=c(2,2))
plot(y=rstudent(model7),x=as.vector(time(Stock_TS)), xlab='Time',
     ylab='Standardized Residuals',type='l', main = "Standardised residuals from Quartic model.")
#plotting a histogram
hist(rstudent(model7),xlab='Standardized Residuals', main = "Histogram of standardised residuals for the Quartic model")
# plotting QQ plot
y = rstudent(model7)
qqnorm(y, main = "QQ plot of standardised residuals for the Quartic model")
qqline(y, col = 2, lwd = 1, lty = 2)
#Shapiro Wilk normality test
y = rstudent(model7)
shapiro.test(y)
#ACF plot for the residuals
acf(rstudent(model7), main = "ACF of standardized residuals the Quartic model
fitted to the return series.")
par(mfrow=c(1,1))
#-------------------------------------------

#3.3	Forecasting with Regression Model

  #Forecasting using Quartic Model
h <- 5 # 5 steps ahead forecasts
lastTimePoint <- t[length(t)]
aheadTimes <- data.frame(t = seq(lastTimePoint+(1), lastTimePoint+h*(1), 1),
                         t2 =  seq(lastTimePoint+(1), lastTimePoint+h*(1), 1)^2,
                         t3 =  seq(lastTimePoint+(1), lastTimePoint+h*(1), 1)^3,
                         t4 = seq(lastTimePoint+(1), lastTimePoint+h*(1), 1)^4
) 
frcModel7 <- predict(model7, newdata = aheadTimes, interval = "prediction")
frcModel7
plot(Stock_TS, xlim= c(t[1],aheadTimes$t[nrow(aheadTimes)]), ylim = c(-150,300), ylab = "return series",
     main = "Forecasts from the Quartic model fitted to the return series.")
lines(ts(fitted.model7,start = t[1],frequency = 1))
lines(ts(as.vector(frcModel7[,3]), start = aheadTimes$t[1],frequency = 1), col="blue", type="l")
lines(ts(as.vector(frcModel7[,1]), start = aheadTimes$t[1],frequency = 1), col="red", type="l")
lines(ts(as.vector(frcModel7[,2]), start = aheadTimes$t[1],frequency = 1), col="blue", type="l")
legend("topleft", lty=1, pch=1, col=c("black","blue","red"), 
       c("Data","5% forecast limits", "Forecasts"))


