filename resp 'resp2.txt';

proc http 
   method="GET" 
   url="http://googlle.com" 
   out=resp;
run;