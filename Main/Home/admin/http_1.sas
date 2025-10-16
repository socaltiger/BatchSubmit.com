filename resp 'resp.txt';

proc http 
   method="GET" 
   url="http://httpbin.org/get" 
   out=resp;
run;