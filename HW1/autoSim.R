# autoSim.R

nVals <- seq(100, 500, by=100)
dist = c("gaussian", "t1", "t5")
for(d in dist){
  for (n in nVals) {
    oFile <- paste("n", n, ".txt", sep="")
    arg = paste("n=", n, " dist=", shQuote(shQuote(dist)),
                " seed=", seed, " reps=", reps, sep="")
    sysCall = paste("nohup Rscript runSim.R ", arg, " > ", oFile, sep="")
    system(sysCall, wait = FALSE)
    print(paste("sysCall=", sysCall, sep=""))
  }
}
