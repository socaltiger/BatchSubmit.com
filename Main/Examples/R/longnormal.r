# Get a random log-normal distribution
r <- rlnorm(1000)

jpeg("C:\\Apache\\htdocs\\casper2\\Main\\Examples\\R\\longnormal.jpg")

# Get the distribution without plotting it using tighter breaks
h <- hist(r, plot=F, breaks=c(seq(0,max(r)+1, .1)))

# Plot the distribution using log scale on both axes, and use
# blue points
plot(h$counts, log="xy", pch=20, col="blue",
	main="Log-normal distribution",
	xlab="Value", ylab="Frequency")

dev.off()

quit()