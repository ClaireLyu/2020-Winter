nVals <- seq(100, 500, by=100)
distTypes <- c("gaussian", "t1", "t5")

distData <- c(c(), c(), c())
for(d in 1:3){
  for (n in nVals) {
    fileName <- paste("n", n, "dist", distTypes[d], ".txt", sep = "")
    files <- read.delim(fileName, header = F)
    distData[d] <- rbind(distData[d], files)
  }
}
options(warn = -1)

MSEData <- data.frame(
  n = rep(nVals, each = 2), 
  method = rep(c("PrimeAvg","SampAvg"), 5),
  gaussian = distData[[1]], 
  t5 = distData[[3]],
  t1 = distData[[2]],
  stringsAsFactors = FALSE
)

# Print the data frame.			
print(MSEData, row.names = FALSE)
