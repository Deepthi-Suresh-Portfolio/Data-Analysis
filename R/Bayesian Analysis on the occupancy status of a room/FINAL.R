graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!
source("DBDA2E-utilities.R") 
library(ggplot2)
library(ggpubr)
library(ks)
library(rjags)
library(runjags)
library(benchmarkme)
setwd("~/OneDrive - RMIT University/Bayesian Statistics/Assignemnt 3")

#===============PRELIMINARY FUNCTIONS FOR POSTERIOR INFERENCES====================

smryMCMC = function(  codaSamples , compVal = NULL,  saveName=NULL) {
  summaryInfo = NULL
  mcmcMat = as.matrix(codaSamples,chains=TRUE)
  paramName = colnames(mcmcMat)
  for ( pName in paramName ) {
    if (pName %in% colnames(compVal)){
      if (!is.na(compVal[pName])) {
        summaryInfo = rbind( summaryInfo , summarizePost( paramSampleVec = mcmcMat[,pName] , 
                                                          compVal = as.numeric(compVal[pName]) ))
      }
      else {
        summaryInfo = rbind( summaryInfo , summarizePost( paramSampleVec = mcmcMat[,pName] ) )
      }
    } else {
      summaryInfo = rbind( summaryInfo , summarizePost( paramSampleVec = mcmcMat[,pName] ) )
    }
  }
  rownames(summaryInfo) = paramName
  
  # summaryInfo = rbind( summaryInfo , 
  #                      "tau" = summarizePost( mcmcMat[,"tau"] ) )
  if ( !is.null(saveName) ) {
    write.csv( summaryInfo , file=paste(saveName,"SummaryInfo.csv",sep="") )
  }
  return( summaryInfo )
}

#===============================================================================

plotMCMC = function( codaSamples , data , xName="x" , yName="y", preds = FALSE ,
                     showCurve=FALSE ,  pairsPlot=FALSE , compVal = NULL, 
                     saveName=NULL , saveType="jpg" ) {
  # showCurve is TRUE or FALSE and indicates whether the posterior should
  #   be displayed as a histogram (by default) or by an approximate curve.
  # pairsPlot is TRUE or FALSE and indicates whether scatterplots of pairs
  #   of parameters should be displayed.
  #-----------------------------------------------------------------------------
  y = data[,yName]
  x = as.matrix(data[,xName])
  mcmcMat = as.matrix(codaSamples,chains=TRUE)
  chainLength = NROW( mcmcMat )
  zbeta0 = mcmcMat[,"zbeta0"]
  zbeta  = mcmcMat[,grep("^zbeta$|^zbeta\\[",colnames(mcmcMat))]
  if ( ncol(x)==1 ) { zbeta = matrix( zbeta , ncol=1 ) }
  beta0 = mcmcMat[,"beta0"]
  beta  = mcmcMat[,grep("^beta$|^beta\\[",colnames(mcmcMat))]
  if ( ncol(x)==1 ) { beta = matrix( beta , ncol=1 ) }
  if (preds){
    pred = mcmcMat[,grep("^pred$|^pred\\[",colnames(mcmcMat))]
  } # Added by Demirhan
  
  #-----------------------------------------------------------------------------
  # Compute R^2 for credible parameters:
  YcorX = cor( y , x ) # correlation of y with each x predictor
  Rsq = zbeta %*% matrix( YcorX , ncol=1 )
  #-----------------------------------------------------------------------------
  if ( pairsPlot ) {
    # Plot the parameters pairwise, to see correlations:
    openGraph()
    nPtToPlot = 1000
    plotIdx = floor(seq(1,chainLength,by=chainLength/nPtToPlot))
    panel.cor = function(x, y, digits=2, prefix="", cex.cor, ...) {
      usr = par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r = (cor(x, y))
      txt = format(c(r, 0.123456789), digits=digits)[1]
      txt = paste(prefix, txt, sep="")
      if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
      text(0.5, 0.5, txt, cex=1.25 ) # was cex=cex.cor*r
    }
    pairs( cbind( beta0 , beta , tau )[plotIdx,] ,
           labels=c( "beta[0]" , 
                     paste0("beta[",1:ncol(beta),"]\n",xName) , 
                     expression(tau) ) , 
           lower.panel=panel.cor , col="skyblue" )
    if ( !is.null(saveName) ) {
      saveGraph( file=paste(saveName,"PostPairs",sep=""), type=saveType)
    }
  }
  #-----------------------------------------------------------------------------
  # Marginal histograms:
  
  decideOpenGraph = function( panelCount , saveName , finished=FALSE , 
                              nRow=2 , nCol=3 ) {
    # If finishing a set:
    if ( finished==TRUE ) {
      if ( !is.null(saveName) ) {
        saveGraph( file=paste0(saveName,ceiling((panelCount-1)/(nRow*nCol))), 
                   type=saveType)
      }
      panelCount = 1 # re-set panelCount
      return(panelCount)
    } else {
      # If this is first panel of a graph:
      if ( ( panelCount %% (nRow*nCol) ) == 1 ) {
        # If previous graph was open, save previous one:
        if ( panelCount>1 & !is.null(saveName) ) {
          saveGraph( file=paste0(saveName,(panelCount%/%(nRow*nCol))), 
                     type=saveType)
        }
        # Open new graph
        openGraph(width=nCol*7.0/3,height=nRow*2.0)
        layout( matrix( 1:(nRow*nCol) , nrow=nRow, byrow=TRUE ) )
        par( mar=c(4,4,2.5,0.5) , mgp=c(2.5,0.7,0) )
      }
      # Increment and return panel count:
      panelCount = panelCount+1
      return(panelCount)
    }
  }
  
  # Original scale:
  panelCount = 1
  panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( beta0 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(beta[0]) , main="Intercept", compVal = as.numeric(compVal["beta0"] ))
  for ( bIdx in 1:ncol(beta) ) {
    panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
    if (!is.na(compVal[paste0("beta[",bIdx,"]")])){
      histInfo = plotPost( beta[,bIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                           xlab=bquote(beta[.(bIdx)]) , main=xName[bIdx],
                           compVal = as.numeric(compVal[paste0("beta[",bIdx,"]")]))
    } else{
      histInfo = plotPost( beta[,bIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                           xlab=bquote(beta[.(bIdx)]) , main=xName[bIdx])
    }
  }
  panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( Rsq , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(R^2) , main=paste("Prop Var Accntd") , finished=TRUE )
  
  panelCount = 1
  if ( pred){
    
    for ( pIdx in 1:ncol(pred) ) {
      panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
      histInfo = plotPost( pred[,pIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                           xlab=bquote(pred[.(pIdx)]) , main=paste0("Prediction ",pIdx) ) 
    }
  }# Added by Demirhan
  # Standardized scale:
  panelCount = 1
  panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMargZ") )
  histInfo = plotPost( zbeta0 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(z*beta[0]) , main="Intercept" )
  for ( bIdx in 1:ncol(beta) ) {
    panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMargZ") )
    histInfo = plotPost( zbeta[,bIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                         xlab=bquote(z*beta[.(bIdx)]) , main=xName[bIdx] )
  }
  panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMargZ") )
  histInfo = plotPost( Rsq , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(R^2) , main=paste("Prop Var Accntd") )
  panelCount = decideOpenGraph( panelCount , finished=TRUE , saveName=paste0(saveName,"PostMargZ") )
  
  #-----------------------------------------------------------------------------
}

#===============PRELIMINARY FUNCTIONS FOR POSTERIOR INFERENCES====================

#Subset of 500 observations have been considered as the training data
myData <- read.table("datatraining copy.txt", sep = ",")
colnames(myData)
myData$Occupancy <- as.numeric(as.factor(myData$Occupancy)) - 1 # converting to a factor variable and back to numerical since it is a categorical variable
myData <- myData[ -c(1) ] # Dropping the date column
head(myData) 

# Prepare the data
y = myData[,"Occupancy"]
x = as.matrix(myData[,1:5])

#-------------------------------------------------------------------------------
## Descriptive Analysis ##
#-------------------------------------------------------------------------------

# Histogram
hist(myData$Occupancy, xlab = "Occupancy", main = "Histogram of Occupancy") 


# Scatter plots
p1 <- ggplot(myData, aes(x=Temperature, y=Occupancy)) +
  geom_point() #Temperature

p2 <- ggplot(myData, aes(x=Humidity, y=Occupancy)) +
  geom_point() #Humidity

p3 <- ggplot(myData, aes(x=Light, y=Occupancy)) +
  geom_point() #Light

p4 <- ggplot(myData, aes(x=CO2, y=Occupancy)) +
  geom_point() #CO2

p5 <- ggplot(myData, aes(x=HumidityRatio, y=Occupancy)) +
  geom_point() #HumidityRatio


figure <- ggarrange(p1, p2, p3, p4, p5, nrow = 3, ncol = 2)
figure

summary(myData)

PredData= read.table("datatest2 copy 2.txt", sep = ",") #Only 21 observations considerd for prediction in testing data
xPred = as.matrix(PredData[,2:6]) 

# Specify the data in a list, for later shipment to JAGS:
dataList <- list(
  x = x ,
  y = y ,
  xPred = xPred ,
  Ntotal = length(y),
  Nx = ncol(x), 
  Npred = nrow(xPred)
)

# First run without initials!
initsList <- list(
  beta0 = 0,
  beta1 = 0,
  beta2 = 0,
  beta3 = 0,
  beta4 = 0,
  beta5 = 0
)

modelString = "
data {
  for ( j in 1:Nx ) {
    xm[j]  <- mean(x[,j])
    xsd[j] <-   sd(x[,j])
    for ( i in 1:Ntotal ) {
      zx[i,j] <- ( x[i,j] - xm[j] ) / xsd[j]
    }
  }
}

model {
  # Non-informative run with standardisation
  for ( i in 1:Ntotal ) {
    # In JAGS, ilogit is logistic:
    y[i] ~ dbern( mu[i] )
      mu[i] <- ( guess*(1/2) + (1.0-guess)*ilogit(zbeta0+sum(zbeta[1:Nx]*zx[i,1:Nx])) )
  }
  # Priors vague on standardized scale:
  zbeta0 ~ dnorm( 0 , 1/2^2 )
  # non-informative run
  for ( j in 1:Nx ) {
    zbeta[j] ~ dnorm( 0 , 1/2^2 )
  }
  #Transform to original scale:
  beta[1:Nx] <- zbeta[1:Nx] / xsd[1:Nx]
  beta0 <- zbeta0 - sum( zbeta[1:Nx] * xm[1:Nx] / xsd[1:Nx] )

  guess ~ dbeta(1,9)

  # Compute predictions at every step of the MCMC
  for ( k in 1:Npred){
    pred[k] <- ilogit(beta0 + sum(beta[1:Nx] * xPred[k,1:Nx]))
  }
}
" # close quote for modelString
# Write out modelString to a text file
writeLines( modelString , con="TEMPmodel.txt" )

# Alternatively you can use a for loop if you have many parameters
parameters = c( "zbeta0" , "beta0")
for ( i in 1:5){
  parameters = c(parameters, paste0("zbeta[",i,"]"), paste0("beta[",i,"]")) 
}

for ( i in 1:nrow(xPred)){
  parameters = c(parameters, paste0("pred[",i,"]")) 
}

adaptSteps = 3500  # Number of steps to "tune" the samplers
burnInSteps = 20000
nChains = 2 
thinSteps = 15
numSavedSteps = 6000
nIter = ceiling( ( numSavedSteps * thinSteps ) / nChains )

# startTime = proc.time()
# runJagsOut <- run.jags( method="parallel" ,
#                         model="TEMPmodel.txt" ,
#                         monitor=parameters  ,
#                         data=dataList ,
#                         # inits=initsList ,
#                         n.chains=nChains ,
#                         adapt=adaptSteps ,
#                         burnin=burnInSteps ,
#                         sample=numSavedSteps ,
#                         thin=thinSteps , summarise=FALSE , plots=FALSE )
# stopTime = proc.time()
duration = stopTime - startTime
show(duration)

#save.image(file='RobustL_Run2-21testdata_500_2chains_3.5 adapt_6k_saved_20kburnin_15Thin.RData') #Save the run 
load(file='RobustL_Run2-21testdata_500_2chains_3.5 adapt_6k_saved_20kburnin_15Thin.RData')

get_cpu() # To assess efficiency.

codaSamples = as.mcmc.list( runJagsOut )

diagMCMC( codaSamples , parName="beta0" )
for ( i in 1:5){
  diagMCMC( codaSamples , parName=paste0("beta[",i,"]") )
}
diagMCMC( codaSamples , parName="zbeta0" )
for ( i in 1:5){
  diagMCMC( codaSamples , parName=paste0("zbeta[",i,"]") )
}
for ( i in 1:nrow(xPred)){
  diagMCMC( codaSamples , parName=paste0("pred[",i,"]") )
}

graphics.off()

compVal <- data.frame("beta0" = 0, "beta[1]" = 0, "beta[2]" = 0, "beta[3]" = 0, "beta[4]" =  0, "beta[5]" =  0, check.names=FALSE)

summaryInfo <- smryMCMC( codaSamples = codaSamples , compVal = compVal)
print(summaryInfo)
write.csv(summaryInfo,file = "SummaryInfo.csv")

colnames(myData)

plotMCMC( codaSamples = codaSamples , data = myData, xName=c("Temperature","Humidity","Light","CO2","HumidityRatio") , 
          yName="Occupancy", compVal = compVal, preds = TRUE)

# ============ Predictive check ============

BayesTheta = summaryInfo[14:34,3] # Take the Bayesian estimates for the test set
# Classify based on the threshold of 0.5
BayesClass = BayesTheta
BayesClass[which(BayesTheta < 0.5)] = 0
BayesClass[which(BayesTheta > 0.5)] = 1
# Actual  occupancy
ActualClass = as.numeric(as.factor(PredData$Occupancy)) - 1

# Confusion matrix
classRes <- data.frame(response = ActualClass, predicted = BayesClass)
conf = xtabs(~ predicted + response, data = classRes)
conf

accuracy = sum(diag(conf))/sum(conf)
accuracy
precision = conf[1,1]/(conf[1,1]+conf[1,2])
precision
recall = conf[1,1]/(conf[1,1]+conf[2,1])
recall
f1 = 2 * precision * recall / (precision + recall)
f1



