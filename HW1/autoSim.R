seed <- 203
reps <- 50
nVals <- seq(100, 500, by=100)
distTypes <- c("gaussian", "t1", "t5")

for (d in 1:3) {
  for (n in nVals) {
    oFile <- paste("n", n, "dist", distTypes[d], ".txt", sep = "")
    arg = paste("n=", n, " dist=", shQuote(shQuote(distTypes[d])),
                " seed=", seed, " reps=", reps, sep = "")
    sysCall = paste("nohup Rscript runSim.R ", arg, " > ", oFile, sep = "")
    system(sysCall, wait = FALSE)
    print(paste("sysCall=", sysCall, sep = ""))
  }
}