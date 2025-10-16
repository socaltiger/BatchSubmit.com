filename mymail email 'pandagen@gmail.com' 
         subject='This is a Test';
         
data _null_;
  file mymail;
  put 'Frank,';
  put 'This is a Test.';
  put 'Please ignore.';
run;