data kerryobama;
  input case occasion response count;
  datalines;
1 0 1 175
1 1 1 175
2 0 1 16
2 1 0 16
3 0 0 54
3 1 1 54
4 0 0 188
4 1 0 188
;
run;

proc nlmixed data=kerryobama qpoints=1000;
  eta = alpha + beta*occasion + u;
  p = exp(eta)/(1 + exp(eta));
  model response ~ binary(p);
  random u ~ normal(0, sigma*sigma) subject = case;
  replicate count;
run;