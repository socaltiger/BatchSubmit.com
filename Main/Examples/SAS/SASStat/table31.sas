data binomial;
  input center treat y n @@ ; * y successes out of n trials;
  if treat = 1 then treat = .5; else treat = -.5;
cards;
1 1 11 36 1 0 10 37 2 1 16 20 2 0 22 32
3 1 14 19 3 0 7 19 4 1 2 16 4 0 1 17
5 1 6 17 5 0 0 12 6 1 1 11 6 0 0 10
7 1 1 5 7 0 1 9 8 1 4 6 8 0 6 7
;
run;

proc genmod data=binomial; * fixed effects, no interaction model;
  class center;
  model y/n = treat center / dist=bin link=logit noint;
run;

proc nlmixed data=binomial qpoints=15; * random effects, no interaction;
  parms alpha=-1 beta=1 sig=1; * initial values for parameter estimates;
  pi = exp(a + beta*treat)/(1+exp(a + beta*treat)); * logistic formula for prob;
  model y ~ binomial(n, pi);
  random a ~ normal(alpha, sig*sig) subject=center;
  predict a + beta*treat out=OUT1;
run;

proc nlmixed data=binomial qpoints=15; * random effects, interaction;
  parms alpha=-1 beta=1 sig_a=1 sig_b=1; * initial values;
  pi = exp(a + b*treat)/(1+exp(a + b*treat));
  model y ~ binomial(n, pi);
  random a b ~ normal([alpha,beta], [sig_a*sig_a,0,sig_b*sig_b]) subject=center;
run;