graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!
library(ggplot2)
library(ggpubr)
library(ks)
library(rjags)
library(runjags)
#setwd("~/Documents/MATH2269_Bayesian/2024/presentations/Module 6")

#------------------------------------------------------------------------------- 
# Load the relevant model into R's working memory:
source("DBDA2E-utilities.R") 

#===============PRELIMINARY FUNCTIONS FOR POSTERIOR INFERENCES====================

smryMCMC_HD = function(  codaSamples , compVal = NULL,  saveName=NULL) {
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

plotMCMC_HD = function( codaSamples , data , xName="x" , yName="y" ,
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
  zVar = mcmcMat[,"zVar"]
  beta0 = mcmcMat[,"beta0"]
  beta  = mcmcMat[,grep("^beta$|^beta\\[",colnames(mcmcMat))]
  if ( ncol(x)==1 ) { beta = matrix( beta , ncol=1 ) }
  tau = mcmcMat[,"tau"]
  pred1 = mcmcMat[,"pred[1]"] # Added by Demirhan
  pred2 = mcmcMat[,"pred[2]"] # Added by Demirhan
  pred3 = mcmcMat[,"pred[3]"] # Added by Demirhan
  pred4 = mcmcMat[,"pred[4]"] # Added by Demirhan
  pred5 = mcmcMat[,"pred[5]"] # Added by Demirhan
  #-----------------------------------------------------------------------------
  # Compute R^2 for credible parameters:
  YcorX = cor( y , x ) # correlation of y with each x predictor
  Rsq = beta %*% matrix( YcorX , ncol=1 )
  Rsq = Rsq[which((Rsq[,1]>=0)&(Rsq[,1]<=1)) ,1] # HD: modified 
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
  if (!is.na(compVal["beta0"])){
    panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
    histInfo = plotPost( beta0 , cex.lab = 1.75 , showCurve=showCurve ,
                         xlab=bquote(beta[0]) , main="Intercept", compVal = as.numeric(compVal["beta0"] ))
  } else {  
    histInfo = plotPost( beta0 , cex.lab = 1.75 , showCurve=showCurve ,
                         xlab=bquote(beta[0]) , main="Intercept")
  }
  for ( bIdx in 1:ncol(beta) ) {
    panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
    if (!is.na(compVal[paste0("beta[",bIdx,"]")])) {
      histInfo = plotPost( beta[,bIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                           xlab=bquote(beta[.(bIdx)]) , main=xName[bIdx],
                           compVal = as.numeric(compVal[paste0("beta[",bIdx,"]")]))
    } else{
      histInfo = plotPost( beta[,bIdx] , cex.lab = 1.75 , showCurve=showCurve ,
                           xlab=bquote(beta[.(bIdx)]) , main=xName[bIdx])
    }
  }
  panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( tau , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(tau) , main=paste("Scale") )
  # panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMarg") )
  # histInfo = plotPost( Rsq , cex.lab = 1.75 , showCurve=showCurve ,
  #                      xlab=bquote(R^2) , main=paste("Prop Var Accntd") )
  panelCount = decideOpenGraph( panelCount ,  saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( pred1 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab="pred1" , main="Prediction 1" ) # Added by Demirhan
  panelCount = decideOpenGraph( panelCount ,  saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( pred2 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab="pred2" , main="Prediction 2" ) # Added by Demirhan
  panelCount = decideOpenGraph( panelCount ,  saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( pred3 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab="pred3" , main="Prediction 3" ) # Added by Demirhan  
  panelCount = decideOpenGraph( panelCount ,  saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( pred4 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab="pred4" , main="Prediction 4" ) # Added by Demirhan  
  panelCount = decideOpenGraph( panelCount ,  saveName=paste0(saveName,"PostMarg") )
  histInfo = plotPost( pred5 , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab="pred5" , main="Prediction 5" ) # Added by Demirhan  
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
  histInfo = plotPost( zVar , cex.lab = 1.75 , showCurve=showCurve ,
                       xlab=bquote(z*tau) , main=paste("Scale") )
  # panelCount = decideOpenGraph( panelCount , saveName=paste0(saveName,"PostMargZ") )
  # histInfo = plotPost( Rsq , cex.lab = 1.75 , showCurve=showCurve ,
  #                      xlab=bquote(R^2) , main=paste("Prop Var Accntd") )
  panelCount = decideOpenGraph( panelCount , finished=TRUE , saveName=paste0(saveName,"PostMargZ") )
  
  #-----------------------------------------------------------------------------
}

#===============PRELIMINARY FUNCTIONS FOR POSTERIOR INFERENCES====================


myData <- read.csv("Assignment2PropertyPrices.csv")
yName = "SalePrice" ; xName = c("Area",	"Bedrooms",	"Bathrooms", 	"CarParks",  	"PropertyType")

# converting the PropertyType as a factor since it is a categorical variable
myData$PropertyType <- as.factor(myData$PropertyType)
head(myData)

#-------------------------------------------------------------------------------
## Descriptive Analysis ##
#-------------------------------------------------------------------------------

# Histogram
par(mfrow = c(1, 2))
hist(myData$SalePrice, xlab = "Sale Price", main = "Histogram of Sale Price") 
# Kernel density estimation
plot(kde(myData$SalePrice), xlab = "Sale Price", main = "Density Plot of Sale Price") # density plot
par(mfrow = c(1, 1))

# Scatter plots
p1 <- ggplot(myData, aes(x=Area, y=SalePrice, color=PropertyType)) +
  geom_point() #Area

p2 <- ggplot(myData, aes(x=Bedrooms, y=SalePrice, color=PropertyType)) +
  geom_point() #Bedrooms

p3 <- ggplot(myData, aes(x=Bathrooms, y=SalePrice, color=PropertyType)) +
  geom_point() #Bathrooms

p4 <- ggplot(myData, aes(x=CarParks, y=SalePrice,color=PropertyType)) +
  geom_point() #CarParks

p5 <- ggplot(myData, aes(x=PropertyType, y=SalePrice,color=PropertyType)) +
  geom_point() #PropertyType


figure <- ggarrange(p1, p2, p3, p4, p5, nrow = 4, ncol = 2)
figure

summary(myData)

#------------------------------------------------------------------------------- 
# Drawing the Jags model Diagram:
#-------------------------------------------------------------------------------

# Reads in the functions plot_dist, plot_dist_svg, plot_dist_png and a
# list of predefined distributions called dists.

# source("plot_dist.R")
# plot_dist(dists$gamma, labels = c(params = "A, B"))
# plot_dist(dists$gamma, labels = expression(list(alpha, beta)))
# plot_dist(dists$gamma, labels = expression(list(mu[i]^2/sigma^2, mu[i]/sigma^2)))
# par(mfrow = c(1, 6))
# plot_dist(dists$normal, labels = c(mean = expression(M[0]), right_sd = expression(S[0])))
# plot_dist(dists$normal, labels = c(mean = expression(M[1]), right_sd = expression(S[1])))
# plot_dist(dists$normal, labels = c(mean = expression(M[2]), right_sd = expression(S[2])))
# plot_dist(dists$normal, labels = c(mean = expression(M[3]), right_sd = expression(S[3])))
# plot_dist(dists$normal, labels = c(mean = expression(M[4]), right_sd = expression(S[4])))
# plot_dist(dists$normal, labels = c(mean = expression(M[5]), right_sd = expression(S[5])))
# par(mfrow = c(1, 1))

#-------------------------------------------------------------------------------

#------------------------------------------------------------------------------- 
# Creating the Jags Data and Model Block:
#-------------------------------------------------------------------------------

# THE DATA.
myData$PropertyType <- as.numeric(as.character(myData$PropertyType))
y = myData[,yName]
x = as.matrix(myData[,c("Area","Bedrooms","Bathrooms","CarParks","PropertyType")])

# Some more descriptives
cat("\nCORRELATION MATRIX OF PREDICTORS:\n ")
show( round(cor(x),3) )
cat("\n")

#Setting up the prediction Matrix
xPred = array(NA, dim = c(5,5))
xPred[1,] = c(600, 2, 2, 1,1)
xPred[2,] = c(800, 3, 1, 2,0)
xPred[3,] = c(1500, 2, 1, 1,0)
xPred[4,] = c(2500, 5, 4, 4,0)
xPred[5,] = c(250, 3, 2, 1,1)

# Specify the data in a list, for later shipment to JAGS:
dataList <- list(
  x = x ,
  y = y ,
  xPred = xPred ,
  Nx = dim(x)[2] ,
  Ntotal = dim(x)[1]
)

#Setting the initials
initsList <- list(
  zbeta0 = 2000,
  zbeta = c(100, 1, 1, 0.5,1),
  Var = 12000000
)


# Running the model with scaling

# THE MODEL.
modelString = "
# Standardize the data:
data {
  ysd <- sd(y)
  for ( i in 1:Ntotal ) {
    zy[i] <- y[i] / ysd 
  }
  for ( j in 1:Nx ) {
    xsd[j] <-   sd(x[,j])
    for ( i in 1:Ntotal ) {
      zx[i,j] <- x[i,j] / xsd[j]
    }
  }
}


# Specify the model for scaled data:
model {
  for ( i in 1:Ntotal ) {
    zy[i] ~ dgamma( (mu[i]^2)/zVar , mu[i]/zVar ) 
    mu[i] <- zbeta0 + sum( zbeta[1:Nx] * zx[i,1:Nx] ) 
  }
  # Priors on standardized scale:
  zbeta0 ~ dnorm( 0 , 1/(2)^2 )  # 1/ variance for normal distribution - NON informative prior for intercept
  zbeta[1] ~ dnorm( 0.00009/xsd[1] , 1/(0.1/xsd[1]^2) ) # Area- very strong expert knowledge
  zbeta[2] ~ dnorm( 1/xsd[2] , 1/(4/xsd[2]^2) ) # Bedroom - weak expert knowledge
  zbeta[3] ~ dnorm( 0 , 1/50 ) # Bathrooms, no expert knowledge
  zbeta[4] ~ dnorm( (1.2)/xsd[4] , 1/(1/xsd[4]^2) ) # carparks - strong expert knowledge
  zbeta[5] ~ dnorm( (-1.5)/xsd[5] , 1/(0.1/xsd[5]^2) ) # property type - very strong expert knowledge #######CHECK THIS
  
  zVar ~ dgamma( 0.01 , 0.01 )
  # Transform to original scale:
  beta[1:Nx] <- ( zbeta[1:Nx] / xsd[1:Nx] ) * ysd
  beta0 <- zbeta0*ysd
  tau <- zVar * (ysd)^2

  # Compute predictions at every step of the MCMC
  for ( i in 1:5){
    pred[i] <- beta0 + beta[1] * xPred[i,1] + beta[2] * xPred[i,2] + beta[3] * xPred[i,3] + beta[4] * xPred[i,4]+ beta[5] * xPred[i,5]
  }
 
}
" # close quote for modelString
# Write out modelString to a text file
writeLines( modelString , con="TEMPmodel.txt" )

parameters = c( "zbeta0" ,  "zbeta" , "beta0" ,  "beta" ,  "tau", "zVar") # Here beta is a vector!

#------------------------------------------------------------------------------- 
# Running the JAGS Model:
#-------------------------------------------------------------------------------

#Run 1
adaptSteps = 1500  # Number of steps to "tune" the samplers
burnInSteps = 10000
nChains = 2 
thinSteps = 7 # First run for 3
numSavedSteps = 4000
nIter = ceiling( ( numSavedSteps * thinSteps ) / nChains )


# Parallel run
startTime = proc.time()
runJagsOut <- run.jags( method="parallel" ,
                        model="TEMPmodel.txt" ,
                        monitor=c( "zbeta0" ,  "zbeta" , "beta0" ,  "beta" ,  "tau", "zVar", "pred")  ,
                        data=dataList ,
                        inits=initsList ,
                        n.chains=nChains ,
                        adapt=adaptSteps ,
                        burnin=burnInSteps ,
                        sample=numSavedSteps ,
                        thin=thinSteps , summarise=FALSE , plots=FALSE )
codaSamples = as.mcmc.list( runJagsOut )
stopTime = proc.time()
elapsedTime = stopTime - startTime
show(elapsedTime)

save.image(file='10KBurnin_4000SavedIter_7Thin_TEST5.RData') #Save the run 
#load('10KBurnin_4000SavedIter_7Thin_TEST5.RData') # load the run

#nrow(codaSamples[[1]])

#------------------------------------------------------------------------------- 
# Diagnostic Checking - Run 1
#-------------------------------------------------------------------------------

diagMCMC( codaSamples , parName="beta0" )
diagMCMC( codaSamples , parName="beta[1]" )
diagMCMC( codaSamples , parName="beta[2]" )
diagMCMC( codaSamples , parName="beta[3]" )
diagMCMC( codaSamples , parName="beta[4]" )
diagMCMC( codaSamples , parName="beta[5]" )
diagMCMC( codaSamples , parName="tau" )
diagMCMC( codaSamples , parName="pred[1]" )
diagMCMC( codaSamples , parName="pred[2]" )
diagMCMC( codaSamples , parName="pred[3]" )
diagMCMC( codaSamples , parName="pred[4]" )
diagMCMC( codaSamples , parName="pred[5]" )
diagMCMC( codaSamples , parName="zbeta0" )
diagMCMC( codaSamples , parName="zbeta[1]" )
diagMCMC( codaSamples , parName="zbeta[2]" )
diagMCMC( codaSamples , parName="zbeta[3]" )
diagMCMC( codaSamples , parName="zbeta[4]" )
diagMCMC( codaSamples , parName="zbeta[5]" )
graphics.off()

#Run 2 - Do further thinning from the codaSamples

furtherThin <- 9
thiningSequence <- seq(1,nrow(codaSamples[[1]]), furtherThin)
newCodaSamples <- mcmc.list()
for ( i in 1:nChains){
  newCodaSamples[[i]] <- as.mcmc(codaSamples[[i]][thiningSequence,])
}

summary(codaSamples)

summary(newCodaSamples)

#------------------------------------------------------------------------------- 
# Diagnostic Checking - Run 2
#-------------------------------------------------------------------------------
diagMCMC( newCodaSamples , parName="beta0" )
diagMCMC( newCodaSamples , parName="beta[1]" )
diagMCMC( newCodaSamples , parName="beta[2]" )
diagMCMC( newCodaSamples , parName="beta[3]" )
diagMCMC( newCodaSamples , parName="beta[4]" )
diagMCMC( newCodaSamples , parName="beta[5]" )
diagMCMC( newCodaSamples , parName="tau" )
diagMCMC( newCodaSamples , parName="pred[1]" )
diagMCMC( newCodaSamples , parName="pred[2]" )
diagMCMC( newCodaSamples , parName="pred[3]" )
diagMCMC( newCodaSamples , parName="pred[4]" )
diagMCMC( newCodaSamples , parName="pred[5]" )
diagMCMC( newCodaSamples , parName="zbeta0" )
diagMCMC( newCodaSamples , parName="zbeta[1]" )
diagMCMC( newCodaSamples , parName="zbeta[2]" )
diagMCMC( newCodaSamples , parName="zbeta[3]" )
diagMCMC( newCodaSamples , parName="zbeta[4]" )
diagMCMC( newCodaSamples , parName="zbeta[5]" )
graphics.off()

#------------------------------------------------------------------------------- 
# Posteriors
#-------------------------------------------------------------------------------

compVal <- data.frame("beta0" = NA, "beta[1]" = NA, "beta[2]" = NA, "beta[3]" = NA, "beta[4]" =  NA,"beta[5]" =  NA, "tau" = NA , check.names=FALSE)
#summaryInfo <- smryMCMC_HD( codaSamples = codaSamples , compVal = compVal )
summaryInfo <- smryMCMC_HD( codaSamples = newCodaSamples , compVal = compVal )
print(summaryInfo)

# plotMCMC_HD( codaSamples = codaSamples , data = myData, xName=xName ,
#            yName=yName, compVal = compVal)
plotMCMC_HD( codaSamples = newCodaSamples , data = myData, xName=xName , 
             yName=yName, compVal = compVal)

#------------------------------------------------------------------------------- 
# ============ Predictive check ============
#-------------------------------------------------------------------------------
summaryInfo[8:13,3]
summaryInfo[14,3]
coefficients <- summaryInfo[8:13,3] # Get the model coefficients out
Variance <- summaryInfo[14,3] # Get the variance out
# Since we imposed the regression model on the mean of the gamma likelihood,
# we use the model (X*beta) to generate the mean of gamma population for each 
# observed x vector. 
meanGamma <- as.matrix(cbind(rep(1,nrow(x)),  x)) %*% as.vector(coefficients)
# Generate random data from the posterior distribution. Here I take the 
# reparameterisation back to alpha and beta.
randomData <- rgamma(n= 231,shape=meanGamma^2/Variance, rate = meanGamma/Variance)

# Display the density plot of observed data and posterior distribution:
predicted <- data.frame(elapsed = randomData)
observed <- data.frame(elapsed = y)
predicted$type <- "Predicted"
observed$type <- "Observed"
dataPred <- rbind(predicted, observed)

ggplot(dataPred, aes(elapsed, fill = type)) + geom_density(alpha = 0.2)+xlim(-2,30)

