# FLQuant.R - DESC
# FLQuant.R

# Copyright 2003-2013 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, JRC
# $Id: $
# Created:
# Modified:

# arrays

arr <- array()

is(arr)

array(dim=c(3,3,3))

array(dim=c(3,3,3),
	dimnames=list(up=c(1,2,3), down=c('a','b','c'), here=c('qui','ca','aqui')))

# life in 6D

# A 6D array in R
arr <- array(1:144, dim=c(3,3,2,2,2,2))

arr

# subseting requires specifying all dims
arr[1:2,,,,,]

# dims are dropped if length == 1
dim(arr[,,,,,2])

# equivalent 2D representation of data
dfa <- cbind(expand.grid(d1=1:3, d2=1:3, d3=1:2, d4=1:2, d5=1:2, d6=1:6),
	data=1:144)

# compare
head(dfa)

# vs.
arr[,,,1,1,1]


# STARTING with FLQuant

# Load the package
library(FLCore)

# Create an empty FLQuant, the 6D array used for storing (almost) all data in FLR
FLQuant()

# Let's look at a toy example
flq <- FLQuant(rnorm(40), dim=c(4,10), dimnames=list(age=1:4, year=1990:1999))


# Inspect them with SUMMARY methods

# This is a 6D array
dim(flq)

length(dim(flq))

# with dimension names a.k.a. dimnames
dimnames(flq)

# and names of dimnames ...
names(flq)

# with an 'units' attribute, still unset
units(flq)

# and an specific name for the first dimension
quant(flq)

# A summary look at its content and dims
summary(flq)

# or a full look at the object (useful for small objects only)
flq

# A default plot spreads across panels all dims of length > 1
plot(flq)


# Use the CREATORS to build FLQuant objects

# FLQuant() can accept different inputs

# (1) Nothing, i.e. missing
FLQuant()

# (2) A vector, which goes by default along the year dim
FLQuant(1:10)

# TIP: to create it with a vector along the first dim, use
FLQuant(as.matrix(1:10))

# (3) A matrix
FLQuant(matrix(1:4, nrow=4, ncol=4))

# (4) Or an array, from 2D to 6D
FLQuant(array(1:50, dim=c(2,5,5)))


# The object ATTRIBUTES can be set when constructing it

# dimnames
FLQuant(matrix(rnorm(16), nrow=4, ncol=4),
	dimnames=list(age=1:4, year=2000:2003))

# quant
FLQuant(matrix(rnorm(16), nrow=4, ncol=4),
	dimnames=list(year=2000:2003), quant='length')

# units
FLQuant(matrix(abs(rnorm(16)), nrow=4, ncol=4),
	dimnames=list(age=1:4, year=2000:2003), units="kg")

# They can also be modified and extracted
flq <- FLQuant(matrix(abs(rnorm(16)), nrow=4, ncol=4),
	dimnames=list(length=1:4, year=2000:2003), units="kg")

# dimnames<-
dimnames(flq) <- list(year=c('2001', '2002', '2003', '2004'))

dimnames(flq)

# NOTE: dimnames are always character ...
is.character(dimnames(flq)$year)

# but number can be used and are converted
dimnames(flq) <- list(year=2002:2005)

# quant<-
quant(flq) <- "age"

quant(flq)

# units<-
units(flq) <- "t"

units(flq)

# Ecco
flq


# FLQuant object can be SUBSET

# Using '[' to select

# a row
flq[1,]

# some columns
flq[, 2:4]

# or with negative indices
flq[-1,]

# Note that not all indices must be provided (unlike array)
flq[1,,,,,]

# vs.
flq[1,]

# Subsetting can be done by position, e.g. the first year
flq[,1]

# or name, e.g. 
flq[,"2002"]

# To select and expand along the year dimension only, window can be used
window(flq, start=2002, end=2004)

window(flq, start=2002, end=2010)


# trim
trim(flq, year=2003:2005, age=2:4)


# Array MATH still works as expected, with the usual R rules

# A fictional weight-at-age matrix
waa <- FLQuant(matrix(seq(2, 30, length=6), nrow=6, ncol=10),
	dimnames=list(age=1:6, year=2000:2009), units="kg")

# and the numbers-at-age matrix
naa <- FLQuant(apply(matrix(rlnorm(10, log(0.5), 0.2), ncol=10), 2,
	function(x) exp( -1 * cumsum(rep(x, 6)))),
	dimnames=list(age=1:6, year=2000:2009), units="1000")

# gives us the total biomass-at-age
bma <- naa * waa

# FLQuant(s) must be of the same dimensions
naa[1,] * waa

# Arithmetic operations by element work with vectors too

# get the actual numbers
naa * 1000

# Be careful with R's recycling rule, as this works (row first)
naa * c(1, 100)
naa * exp(c(1:6))

# but this issues a warning
naa * exp(c(1:7))


# TRANSFORM


# apply

# A most useful function for arrays
# e.g. to sum over the first dimension
apply(bma, 2:6, sum)

# or get the mean abundance at age for the last 3 years
apply(bma[,as.character(2007:2009)], c(1,3:6), mean)

# sweep


# ITERS

# FLQuant()

# Adding iters in dim, dimnames, or iter
flq <- FLQuant(rlnorm(100), dim=c(10,1,1,1,1,10), quant='age')

flq <- FLQuant(rlnorm(100), dimnames=list(age=1:10, iter=1:10))

flq <- FLQuant(rlnorm(100), dimnames=list(age=1:10), iter=10)

# propagate, to expand an existing object
bmi <- propagate(bma, iter=10)

# with NAs
bmi <- propagate(bma, iter=10, fill.iter=FALSE)

# or copies of the first iter
bmi <- propagate(bma, iter=10, fill.iter=TRUE)

# iter, iter<-
# to access or modify a subset of iters, as in [,,,,,*]
iter(flq, 1)

iter(flq, 1:2)

# iterMeans, iterVars
# shortcuts for apply(x, 1:5, mean/var)
iterMeans(flq)

iterVars(flq)

# quantile
quantile(flq, probs=0.05)


# %*% OPERATIONS
# Difference in dimensions taken care of
waa[1,] %*% naa

