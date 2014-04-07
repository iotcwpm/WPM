# Projecting_with_FLR.R - How to perform projections with FLR
# Projecting_with_FLR

# Copyright 2013 JRC FISHREG. Distributed under the GPL 2 or later
# Maintainer: JRC FISHREG
# $Id: $
# Created: 20/03/2013
# Modified:

#---------------------------------------------------------------
# Basics
#---------------------------------------------------------------

# Load the libraries
library(FLCore)
library(FLAssess)
library(FLash)

# As ever, load the ple4 data
data(ple4)

#---------------------------------------------------------------
# Introduction to projections
#---------------------------------------------------------------

# Making projections is like making a cake - just need the right ingredients and put them together in the right order
# It doesn't have to be difficult and with a small amount of effort it's possible to make something simple but tasty
# With more skill, you can make something more complicated and (maybe) tastier
# But there is a risk - the more complicated you make it, the higher the chance of making a terrible cake
# http://www.cakewrecks.com/

# There are three necessary ingredients when projecting in FLR
#     stock object - that you will forecast and about which you have made some assumptions about what will happen in the future
#     a stock-recruitment relationship
#     projection control - specify what targets and when to hit them

# In FLR, there is a method fwd()
# This takes these three ingredients as arguments
#     FLStock 
#     FLSR
#     fwdControl()

#---------------------------------------------------------------
# Ingredient 1 - the stock
#---------------------------------------------------------------

summary(ple4)
# Our ple4 stock goes up to 2008
# In this example we want to make a 3 year projection
# So we need to extend the stock by 3 years
# We could use window() or trim() but that makes all future data NA
# Instead we use the stf() function (short term forecast)
# This has several options that allow you to control the assumptions about the future
?stf
# These assumptions specify how many years you want to average over to set future values
# For example, wts.nyears is the number of years over which to calculate the *.wt, *.spwn, mat and m slots
# By default this is 3 years
# We'll keep it simple and use the default

# Keep things simple so do a 3 year forecast
ple4_stf <- stf(ple4, nyears = 3)
# Now the stock goes up to 2011
summary(ple4_stf)
# You can see the future (2009:2011) weights are the mean of the last 3 years (2006:2008)
stock.wt(ple4_stf)
# The future harvest rates have also been set as the mean of the last 3 years
fbar(ple4_stf)
# But the abundance has not been forecast (yet...)
ssb(ple4_stf)

#---------------------------------------------------------------
# Ingredient 2 - the stock-recruitment relationship
#---------------------------------------------------------------

# Simple - we just set a Beverton-Holt
ple4_sr <- fmle(as.FLSR(ple4, model="bevholt"))
plot(ple4_sr)

#---------------------------------------------------------------
# Recipe 1 - Flapjack
#---------------------------------------------------------------

# Simple recipe - no baking necessary
# Healthy and delicious

# Remember that all we can 'manage' in the fishery is the level of fishing mortality
# Here we do this directly by setting F in future years
# Set F in the future years to be the same as the mean of the last 5 years
f_future <- mean(fbar(ple4)[,as.character(2004:2008)])

# Now we introduce the control object: fwdControl()
# This takes 1 argument - a data.frame that sets:
#   The year the F target is to be hit (!)
#   The quantity (or type) of the target
#   The value of the target
#   Some other things that we will ignore for now
# Make the data.frame
ctrl_target <- data.frame(year = 2009:2011,
			  quantity = "f",
			  val = c(f_future, f_future, f_future))

# Set the control object - year, quantity and value for the moment
ctrl_f <- fwdControl(ctrl_target)

# Quick tour of the control object
ctrl_f
# We see that we have what looks like our ctrl_target, but now it has two more columns (min and max)
# Also there is another table underneath - ignore this for now

# Importante!
# Remember that we can only really control F
# The year in the fwdControl object is the year that F will be set to hit your target 
# This is true for all target types - this will become clear later

# What else do we have?
slotNames(ctrl_f)
# Ignore the block, effort and effArray slots, we won't use them today
# After all, we're only making flapjack
# The trgtArray we will eventually come to - but ignore it for now
# What is this target slot?
ctrl_f@target
# What are all these columns - panic!



# Run fwd() with our three ingredients
ple4_fwd_f <- fwd(ple4_stf, ctrl = ctrl_f, sr = ple4_sr)
# What just happened?
fbar(ple4_fwd_f)
f_future
ssb(ple4_fwd_f)
plot(window(ple4_fwd_f, start = 1991, end = 2011))

#---------------------------------------------------------------
# Recipe 2 - Welsh cake
#---------------------------------------------------------------
# Another recipe which does not require baking
# These cakes should be eaten hot, straight from the griddle
# A cold Welsh cake is a friend to no-one

# Here we set catch as the target
# We can use to explore the consequences of different TAC strategies
catch(ple4_stf)
# Plan is to reduce the catch by 10% each year
future_catch <- c(catch(ple4)[,"2008"]) * 0.9^(1:3)
ctrl_catch <- fwdControl(
	data.frame(
		year=2009:2011,
		quantity = "catch",
		val=future_catch))
ctrl_catch
ple4_fwd_catch <- fwd(ple4_stf, ctrl_catch, sr = ple4_sr)
catch(ple4_fwd_catch)
plot(window(ple4_fwd_catch, start = 1991, end = 2011))

# Importante
# What fwd() really does is to find the value of F that will result in hitting the target

#---------------------------------------------------------------
# Recipe 3 - Muffin (blueberry)
#---------------------------------------------------------------

# Slightly more complicated
# Here we set SSB as the target

ssb(ple4_stf)
# We want the future SSB to be high (we could have used FLBRP to come up with a suitable value, e.g. Bmsy but here we just pick a value)
future_ssb <- 300000
ctrl_ssb <- fwdControl(data.frame(year=2009:2011, quantity = "ssb", val=future_ssb))
ctrl_ssb
ple4_fwd_ssb <- fwd(ple4_stf, ctrl_ssb, sr = ple4_sr)
# Error - what happened - Cake Failure! www.cakewrecks.com
 
# Remember - 
# the target year in the control object is the year that F is set
# SSB in year Y depends on F in Y-1
# In the above control object what we actually did was to find the F in 2011 that will hit a target SSB. But this target SSB will not happen until 2012. 
# But our stock doesn't go to 2012 - so we get an error
# So to hit the SSB target in 2009:2011, we need to set target year as 2008:2010 

# Try again but change the target year
ctrl_ssb <- fwdControl(data.frame(year=2008:2010, quantity = "ssb", val=future_ssb))
ctrl_ssb
ple4_fwd_ssb <- fwd(ple4_stf, ctrl_ssb, sr = ple4_sr)
ssb(ple4_fwd_ssb)
# But this has required a large decrease in F and Catch in 2008
fbar(ple4_fwd_ssb)
catch(ple4_fwd_ssb)
# We've hit our SSB target straight away
plot(window(ple4_fwd_ssb, start = 1991, end = 2011))

# Importante!
# Remember that the F in the final year was already set by the stf()
# This means that F in 2011 is just left over from stf() and has nothing to do with our projection
# And because our target is SSB in 2011, catch is not calculated for 2011
# This is why catch is 0 in 2011
# You can ignore catcb and F in 2011 
# Or just plot until 2010
plot(window(ple4_fwd_ssb, start = 1991, end = 2010))

#---------------------------------------------------------------
# Recipe 4 - Cupcake
#---------------------------------------------------------------
# A bit like a small muffin, but with icing (a good thing)

# The examples above have dealt with ABSOLUTE target values
# We now introduce the idea of RELATIVE values
# This allows us to set the target value RELATIVE to the value in another year

# Here we set catches relative to the catch value in another year

ctrl_rel_catch <- fwdControl(
	data.frame(year = 2009:2011,
		   quantity = "catch",
		   val = 0.9,
		   rel.year = 2008:2010))
# Note the introduction of the rel.year column
# This means that we want the value in 2009 to be 0.9 * value in 2008 etc
ctrl_rel_catch
# An extra column has appeared!
# Put it into fwd()
ple4_fwd_rel_catch <- fwd(ple4_stf, ctrl_rel_catch, sr = ple4_sr)
catch(ple4_fwd_rel_catch)
plot(window(ple4_fwd_rel_catch, start = 1991, end = 2011))

# This is the same result as Recipe 3, but in Recipe 3 we had to set the absolute catch values in advance

#---------------------------------------------------------------
# Recipe 5 - Clootie Dumpling
#---------------------------------------------------------------
# A Scotish classic - something to fuel you for the highlands
# http://en.wikipedia.org/wiki/Clootie 

# In this Recipe we introduce 2 new things:
# Multiple targets
# Targets with BOUNDS

# We saw in Recipe 3 (SSB target) that we can hit our high SSB target but this causes a decline in catch in 2008
# Fishers will not like this
# So we can set a MINIMUM value to the catch. 
# This means that fwd() will try to find the F that will result in our target SSB, but will be constrained by catch having a minimum value.

# We'll set our minimum catch to be the mean catch of the last 3 years
min_catch <- mean(catch(ple4_stf)[,as.character(2006:2008)])
# And keep our target SSB as before
future_ssb <- 300000

# Remember: Setting SSB requires shifting back the target year

# Molto importante!
# Be careful with order of data.frame
# Go year by year, set the target, then set the bounds
ctrl_ssb_min_catch <- fwdControl(
	data.frame(year = c(2008,2008,2009,2009,2010,2010),
		quantity = c("ssb","catch","ssb","catch","ssb","catch"),
		val = c(future_ssb,NA,future_ssb,NA,future_ssb,NA),
		min = c(NA,min_catch,NA,min_catch,NA,min_catch)))
ctrl_ssb_min_catch

ple4_fwd_ssb_min_catch <- fwd(ple4_stf, ctrl_ssb_min_catch, sr = ple4_sr)
ssb(ple4_fwd_ssb_min_catch)
catch(ple4_fwd_ssb_min_catch) 
# Again, ignore Catch and F in the final year of the plot
# The projection only goes up to the start of 2011
plot(window(ple4_fwd_ssb_min_catch, start = 1991, end = 2011))
				       
#---------------------------------------------------------------
# Recipe 6 - Panettone
#---------------------------------------------------------------

# Here we use a combination of RELATIVE targets and BOUNDS

# This kind of approach can be used to model a recovery plan
# For example, we want F reduced by 30% each year until F = f0.1 
# Instead of a 3 year projection, now we are going up to 2014

yrs <- 2009:2014
# Set a value for f0.1 - should have used FLBRP but...
f0.1 <- 0.09
ple4_stf_long <-stf(ple4, length(yrs))

# This requires careful setting up of the control object
ctrl <- fwdControl(
	data.frame(year =rep(yrs, each=2), 
		rel.year=rep(c(0,NA),length(yrs))+rep(yrs-1,each=2), 
		val =rep(c(.70, NA), length(yrs)), 
		min =rep(c(NA, f0.1), length(yrs)),
		quantity="f"))
# Just by looking at the control object, can you guess what will happen?
ctrl
recovery<-fwd(ple4_stf_long, ctrl=ctrl, sr=ple4_sr)
fbar(recovery)
# f is reduced by 30% from 2009
# until min f is hit in 2012
plot(window(recovery, start = 1991, end = 2014))


# So far we have looked at combinations of:
#     absolute target values,
#     relative target values,
#     bounds on targets, and
#     mixed target types.
# That is very impressive.
# But all of the projections have been deterministic.
# That is they all have only one iteration.
# Now, we are going start looking at projecting with multiple iterations
# This is important because it can help you understand the impact of
# uncertainty (e.g. in the stock-recruitment relationship)
# Prepare yourself! Because we are about to enter the 6th Dimension...

#---------------------------------------------------------------
# Mangiamo
#---------------------------------------------------------------

# fwd() is happy to work over iterations.
# It treats each iteration separately. 
# 'All' you need to do is set the arguments correctly 
# There are two main ways of introducing iterations into fwd():
	# 1. By passing in residuals to the stock-recruitment function (as another argument to fwd())
	# 2. Through the control object (by setting target values as multiple values)
# You can actually use both of these methods at the same time.
# As you can probably imagine, this can quickly become very complicated
# so we'll just do some simple examples

#---------------------------------------------------------------
# Preparation for projecting with iterations
#---------------------------------------------------------------

# We have to 'propagate' your stock so that it has multiple iterations.
# Choose the number of iterations 
niters <- 1000
# We'll use the three year projection as before
ple4_stf <- stf(ple4, nyears = 3)
ple4_stf_iters <- propagate(ple4_stf, niters)
# You can see that the 6th dimension, iterations, now has length 1000
summary(ple4_stf_iters)

#---------------------------------------------------------------
# Recipe 7 - Rum and ginger cake
#---------------------------------------------------------------

# Stochastic recruitment
# There are two arguments to fwd() that we haven't used yet:
# sr.residuals and sr.residuals.mult
# These are used for specifying the recruitment residuals (sr.residuals)
# and whether these residuals are multiplicative (sr.residuals.mult=TRUE)
# or additive (FALSE)
# We'll use multiplicative residuals
# To use them, you first have to set up an FLQuant of recruitment residuals
multi_rec_residuals <- FLQuant(NA, dimnames = list(year=2009:2011, iter=1:niters))

# We can access the residuals of the stock-recruitment relationship
residuals(ple4_sr)
# These residuals are on a log scale i.e.
# log_residuals = log(true_recruitment) - log(predicted_recruitment)
# You can check this (should be the same as residuals(ple4_sr):
log(rec(ple4_sr)) - log(predict(ple4_sr,ssb=ssb(ple4_sr)))
# or
log(rec(ple4_sr)  / predict(ple4_sr,ssb=ssb(ple4_sr)))

# We want to use these log residuals multiplicatively, i.e.
# 'true' recruitment in projection = recruitment predicted by FLSR * residuals
# This means that we need to transform our log residuals with exp()
exp(residuals(ple4_sr))
# We want to fill up our multi_rec_residuals FLQuant by randomly sampling from these log residuals
# We can do this with the sample() function
# We want to sample with replacement (i.e. if a residuals is chosen, it gets put back in the pool to be chosen again)

# Remember how to use sample?
sample_years <- sample(dimnames(residuals(ple4_sr))$year, niters * 3, replace = TRUE)
# Fill up the FLQuant we made earlier
multi_rec_residuals[] <- exp(residuals(ple4_sr)[,sample_years])
# What have we got?
multi_rec_residuals
# What do those brackets mean?
# It's a way of summarising the iterations - we have 100 iterations but don't want to see all of them - just a summary

# We now have the recruitment residiuals
# We still need a control object
# We'll use one we made earlier with decreasing catch  (remember...?)
ctrl_catch

ple4_fwd_catch_rec <- fwd(ple4_stf_iters, ctrl = ctrl_catch, sr = ple4_sr, sr.residuals = multi_rec_residuals, sr.residuals.mult = TRUE)
# What just happened?
rec(ple4_fwd_catch_rec)
fbar(ple4_fwd_catch_rec)
ssb(ple4_fwd_catch_rec)
plot(window(ple4_fwd_catch_rec, start = 1991, end = 2011))
# A projection with random recruitment!
# A cake full of win!


#---------------------------------------------------------------
# Recipe 8 - Wedding cake
#---------------------------------------------------------------
# A multi layer, ambitious cake
# Looks are more important than taste
# It also probably has marzipan in it, which is great if you like it

# In this example we introduce uncertainty by including uncertainty in our target values
# This might get messy, so make sure you are wearing an apron

# Again, this is a simple example with catch as the target
# Except now, catch will be stochastic

# A very simple example
# Future catch is mean of last three years
future_catch <- mean(catch(ple4)[,as.character(2006:2008)])
# Make the control object as before
ctrl_catch <- fwdControl(data.frame(year=2009:2011, quantity = "catch", val=future_catch))
ctrl_catch

# Remember that we looked at the control object in detail at the beginning?
slotNames(ctrl_catch)
# The iterations of the target value are set in the trgtArray slot
ctrl_catch@trgtArray
# What is this?
class(ctrl_catch@trgtArray)
dim(ctrl_catch@trgtArray)
# It's a 3D array (target no x value x iteration)
# And it's in here that we set the stochastic catch
# Each row of trgtArray corresponds to a row in the data.frame we passed in

# Here we set three targets, so the first dimension of trgtArray has length 3.
# The second dimension always has length 3
# The third dimension is where the iterations are stored.
# This is currently length 1. We have 1000 iterations and therefore we need to expand the array along the iter dimension so it can store the 1000 iterations we want
# Simplest way is just to make a new array with the right dimensions
# Note that we need to put in dimnames and the iter dimension must be named
new_trgtArray <- array(NA, dim=c(3,3,niters), dimnames = list(1:3, c("min","val","max"),iter=1:niters))
dim(new_trgtArray)
# Now we can fill it up with new data

# The question is, how do we generate random catch data?
# We can generate random catch data with mean of future_catch
# But what should the variance be?
# It could be based on history of compliance (i.e. difference between TAC and 'real' catch)
# Here we make it very simple, by using a fixed standard deviation
# We assume a lognormal distribution
future_catch_iters <- future_catch * rlnorm(3 * niters, meanlog = 0, sdlog=0.2)
# Fill up our target array
# Just fill up the 'val' column (you can also use min and max for stochastic bounds)
new_trgtArray[,"val",] <- future_catch_iters
# put this into the control object
ctrl_catch@trgtArray <- new_trgtArray
ctrl_catch
# And project
ple4_fwd_catch_iters <- fwd(ple4_stf_iters, ctrl_catch, sr = ple4_sr)
catch(ple4_fwd_catch_iters)
plot(window(ple4_fwd_catch_iters, start = 1991, end = 2011))
rec(ple4_fwd_catch_iters)
# What is going on with recruitment?
# Remember that here recruitment is not being driven by random residuals
# It is only be driven by SSB
# The SSB in year Y is a result of the Catch in year Y-1
# The recruitment in year Y is a result of the SSB in year Y-1
# So if Catch is stochastic in 2009, we don't see the impact on recruitment until 2011
# Seems unlikely so we can also put in recruitment residuals
# (We already made them for Recipe 7)
ple4_fwd_catch_iters <- fwd(ple4_stf_iters, ctrl_catch, sr = ple4_sr, sr.residuals = multi_rec_residuals, sr.residuals.mult = TRUE)
catch(ple4_fwd_catch_iters)
plot(window(ple4_fwd_catch_iters, start = 1991, end = 2011))
rec(ple4_fwd_catch_iters)

# A projection with stochastic catch and recruiment!

#---------------------------------------------------------------
# Recipe 9 - Just a massive cake
#---------------------------------------------------------------

proj_years <- 2009:2020
# Future SSB set at BMSY
# But restrict change in TAC +- 15% per annum
# Recruitment residuals
# And target SSB is subject to noise 
bmsy <- 300000
max_change_tac = 0.15

niters <- 1000
# We'll use the three year projection as before
ple4_stf <- stf(ple4, nyears = length(proj_years))
ple4_stf_iters <- propagate(ple4_stf, niters)

# Set up recruitment residuals as before
# (see above for details)
multi_rec_residuals <- FLQuant(NA, dimnames = list(year=proj_years, iter=1:niters))
sample_years <- sample(dimnames(residuals(ple4_sr))$year, niters * length(proj_years), replace = TRUE)
multi_rec_residuals[] <- exp(residuals(ple4_sr)[,sample_years])

# Control object
# Set one year at a time
# Need to set: year, quantity, val, min, max and rel.year
# Remember: SSB targets must have year-1
big_control <- fwdControl(data.frame(
	   year = rep(proj_years-1, each = 3),
	   quantity = c("ssb","catch","catch"),
	   val = c(bmsy,NA,NA),
	   max = c(NA,1+max_change_tac,NA),
	   min = c(NA,NA,1-max_change_tac),
	   rel.year =rep(c(NA,0,0),length(proj_years))+ rep(proj_years-2,each=3)))
# What have we done
head(big_control@target)
# Pick through it year by year

# Project this but without any stochasticity 
det_fwd <- fwd(ple4_stf_iters, ctrl=big_control, sr=ple4_sr)
plot(window(det_fwd,start=2000, end=2019))
# Explain this

# With stochastic residuals
res_fwd <- fwd(ple4_stf_iters, ctrl=big_control, sr=ple4_sr, sr.residuals = multi_rec_residuals, sr.residuals.mult = TRUE)
plot(window(res_fwd,start=2000, end=2019))

# Add stochasticity to the control object
dim(big_control@trgtArray)
big_control@trgtArray <- array(NA,dim=c(length(proj_years)*3,3,niters),dimnames=list(1:(length(proj_years)*3), c("min","val","max"),iter=1:niters))

# The TAC change is not stochastic
big_control@trgtArray[seq(from = 2, to = length(proj_years)*3,by=3),"max",] <- 1+max_change_tac
big_control@trgtArray[seq(from = 3, to = length(proj_years)*3,by=3),"min",] <- 1-max_change_tac
# Set the SSB to be stochastic
stoch_ssb <- bmsy * rlnorm(length(proj_years) * niters, meanlog = 0, sdlog=0.2)
big_control@trgtArray[seq(from = 1, to = length(proj_years)*3,by=3),"val",] <- stoch_ssb

# Check out 1 iter
big_control@trgtArray[,,1]

# Stuff it all in and go
res_fwd <- fwd(ple4_stf_iters, ctrl=big_control, sr=ple4_sr, sr.residuals = multi_rec_residuals, sr.residuals.mult = TRUE)
plot(window(res_fwd,start=2000, end=2019))

