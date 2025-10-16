data dxiti71; 
input number x1-x7; 
cards; 
1 0.05798 5.5150 347.10 21.910 8586 1742 61.69  
2 0.08441 3.9700 347.20 19.710 7947 2000 2440 
3 0.07217 1.1530 54.85 3.052 3860 1445 9497 
4 0.15010 1.7020 307.50 15.030 12290 1461 6380 
5 5.74400 2.8540 229.60 9.657 8099 1266 12520 
6 0.21300 0.7058 240.30 13.910 8980 2820 4135
;
run;
 
proc cluster data=dxiti71 method=ave std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 n=2 out=tr71n horizontal graphics; title'使用类平均法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run; 
proc cluster data=dxiti71 method=med std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用中间距离法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run; 
proc cluster data=dxiti71 method=WARD std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用离差平方和法的谱系聚类图'; run; 
proc sort data=tr71n;
by cluster; proc print; run; 
proc cluster data=dxiti71 method=fle std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用可变类平均法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run; 
proc cluster data=dxiti71 method=cen std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用重心法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run; 
proc cluster data=dxiti71 method=den std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用密度估计法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run; 
proc cluster data=dxiti71 method=two std pseudo ccc outtree=tr71; var x1-x7; id number; 
proc tree data=tr71 horizontal graphics; title '使用两阶段密度估计法的谱系聚类图'; run; 
proc sort data=tr71n; by cluster; proc print; run;