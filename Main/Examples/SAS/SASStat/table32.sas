data ordinal;
  do center = 1 to 8;
    do trt = 1 to 0 by -1;
      do resp = 3 to 1 by -1;
        input count @@;
        output;
      end;
    end;
  end;
datalines;
13 7 6 1 1 10 2 5 10 2 2 1
11 23 7 2 8 2 7 11 8 0 3 2
15 3 5 1 1 5 13 5 5 4 0 1
7 4 13 1 1 11 15 9 2 3 2 2
run;

proc nlmixed data=ordinal qpoints=15;
** To maintain the threshold ordering define thresholds such that **;
** threshold 1 = 0 and threshold 2 = i2, where i2 > 0. **;
** Use starting value of 0 for sig_cb. **;
  bounds i2>0; parms sig_cb=0;
  eta1 = c - b*trt;
  eta2 = i2 - c - b*trt;
  if (resp=1) then z = 1/(1+exp(-eta1));
  else if (resp=2) then z = 1/(1+exp(-eta2)) - 1/(1+exp(-eta1));
  else z = 1 - 1/(1+exp(-eta2));

  if (z > 1e-8) then ll = count*log(z); ** Check for small values of z **;
  else ll=-1e100;

  model resp ~ general(ll); ** Define general log-likelihood. **;
  random c b ~ normal([gamma,beta],[sig_c*sig_c, sig_cb, sig_b*sig_b])
  subject = center out = out1; ** OUT1 contains predicted center- **;
** specific cumulative log odds ratios **;
run;