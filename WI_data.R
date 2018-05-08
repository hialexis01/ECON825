# loading libraries
library(forecast)
library(stats)
library(stargazer)

# Wisconsin Data
WI09 <- c(16, 23, 26, 36, 115, 464, 647, 286, 148, 82, 60, 45)
WI10 <- c(39, 30, 38, 72, 233, 821, 699, 239, 131, 133, 44, 32)
WI11 <- c(39, 21, 38, 67, 152, 589, 832, 346, 156, 88, 63, 34)
WI12 <- c(41, 33, 57, 93, 200, 453, 341, 108, 83, 38, 25, 15)
WI13 <- c(20, 11, 14, 13, 109, 398, 594, 284, 167, 71, 28, 17)
WI14 <- c(16, 9, 15, 27, 85, 254, 320, 115, 78, 45, 11, 9)
WI15 <- c(13, 8, 11, 33, 144, 376, 373, 142, 77, 74, 28, 22)
WI16 <- c(9, 14, 28, 57, 127, 433, 438, 146, 80, 91, 47, 21)

# Year and Month
Year <- rep(x = c(2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016),
            each = 12)
Month <- rep(x = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
             times = 8)

# master set
master <- data.frame(cbind(Year,
                           Month,
                           c(WI09, WI10, WI11, WI12, WI13, WI14, WI15, WI16)))

# time series lyme data
lyme <- ts(master$V3,
           start = c(2009, 1),
           frequency = 12)
#Lyme window
lyme.a<-window(lyme, start = c(2009,1), end = c(2014,12 ))

#### Trends ####

#Quadratic
lyme.qt <- tslm(lyme.a~trend+I(trend*trend))
print(summary(lyme.qt))

lyme.f2<- forecast(lyme.qt, h = 24, level = 95)
lyme.prd2<-lyme.qt$fit

plot(lyme.f2)
lines(lyme.prd2)
lines(lyme)

AIC(lyme.qt)

#log-linear
loglyme <- log(lyme)
loglyme.a<-window(loglyme, start = c(2009,1), end = c(2014,12))

lyme.log <- tslm(loglyme.a~trend)
print(summary(lyme.log))

lyme.f3 <-forecast(lyme.log, h = 24,level = 95)

lyme.prd3 <- lyme.log$fit
plot(lyme.f3)
lines(loglyme)
lines(lyme.prd3)


#### Seasonality ####

# linear regression
lyme.lm <- tslm(formula = lyme.a  ~ season)
summary(lyme.lm)

# fitted values
lyme.prd <- lyme.lm$fit

# forecast
lyme.f <- forecast(lyme.lm, h=24, level = 95)

# plotting data
plot(lyme.f,col = "blue", lwd = 2)
lines(lyme, lwd = 2)
lines(lyme.prd, col = "red", lwd = 2)


# AIC and BIC scores

data.frame(AIC = c(AIC(lyme.lm),AIC(lyme.qt), AIC(lyme.log)), 
           BIC = c(BIC(lyme.lm), BIC(lyme.qt), BIC(lyme.log)), row.names = 
             c("Linear", "Quadratic", "Log"))
#ACF and PACF
Acf(lyme)
Pacf(lyme)

View(master)