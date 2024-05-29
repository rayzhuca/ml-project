# both are on CRAN
library(qeML)
library(freqparcoord) # also have cdparcoord
library(fairml)
# compas data available, e.g., in fairml package

cmps <- compas[,c(1,2,4,5,7:10)]

# goal, compare the vendor's product with our own analysis, noting in
# which region one predicts higher than the other

# run gradient boosting, getting our own fit
xgbout <- qeXGBoost(cmps, 'two_year_recid', holdout=NULL)
xgbfit <- predict(xgbout,cmps[,-7])$probs[,2]
# get the vendor's fit
northpointePreds <- compas$decile_score / 10
# differences
dffs <- northpointePreds - xgbfit

cmps$dffs = dffs

print(head(cmps))

# library(graphics)
library(plotly)
fig <- plot_ly(
  x = cmps$age, 
  y = cmps$priors_count, 
  z = cmps$dffs, 
  type = "contour" 
)
print(fig)

# code under, overpredict, codes 1, 0, -1
tmp <- rep(0,length(dffs))
tmp[dffs > 0.1] <- 1 
tmp[dffs < -0.1] <- -1
c1 <- cmps[,1:5]

c1$tmp <- tmp
c1a <- unique(c1)

print(head(cmps))
print(head(dffs))
print(head(c1a))



print(freqparcoord(c1a,25,1:5,grpvar=6,method="maxdens"))