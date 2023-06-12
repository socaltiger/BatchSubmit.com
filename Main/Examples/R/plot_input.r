x <- rnorm(10,sd=5,mean=20)
y <- 2.5*x - 1.0 + rnorm(10,sd=9,mean=0)
cor(x,y)

jpeg("C:\\Apache\\htdocs\\casper2\\Main\\Examples\\R\\plot_input.jpg")
plot(x,y,xlab="Independent",ylab="Dependent",main="Random Stuff")
dev.off()

quit()