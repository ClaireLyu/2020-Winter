## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

#set seed for random number generation
set.seed(seed)

mseSampAvg = 0
msePrimeAvg = 0

for (r in 1:reps) {
  if (dist == "gaussian"){
    # simulate data
    x = rnorm(n)
  } else if(dist == "t1"){
    x = rt(n, df = 1)
  } else if(dist == "t5"){
    x = rt(n, df = 5)
  } else {
    stop("Unrecognized distribution")
  }
  # try two methods
  mseSampAvg = mseSampAvg + mean(x)^2
  msePrimeAvg = msePrimeAvg + estMeanPrimes(x)^2
}

print(mseSampAvg / reps)
print(msePrimeAvg / reps)
