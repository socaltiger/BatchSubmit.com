proc template;
   define style styles.colorramp;
   parent=styles.default;

   /* Define a lighter and darker shade of blue for the starting and ending colors. */
   style twocolorramp / startcolor=cxF3F7FE endcolor=cx6497EB;

   /* When there are fewer than 3 response levels, GraphData1 and GraphData2 
      are used for the colors */
   style graphdata1 from graphdata1 / color=cxF3F7FE;
   style graphdata2 from graphdata2 / color=cx6497EB;
   end;
run;

/* Reference the style using the STYLE= option in the ODS destination statement */
ods listing style=styles.colorramp;

title 'Map with colors defined from a color ramp';

filename sasgraph 'gmap.png';
goptions gsfname=sasgraph dev=png xpixels=500;

proc gmap data=maps.us map=maps.us;
   id state;
   choro state;
run;

quit; 