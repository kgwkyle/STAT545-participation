---
title: "cm009 Exercises: tidy data"
date: "October 1, 2019"
output: 
  html_document:
    keep_md: true
    df_print: paged
    toc: yes
    theme: cerulean
editor_options: 
  chunk_output_type: inline
---


```r
library("tidyverse")
lotr  <- read_csv("https://raw.githubusercontent.com/jennybc/lotr-tidy/master/data/lotr_tidy.csv")
guest <- read_csv("https://raw.githubusercontent.com/STAT545-UBC/Classroom/master/data/wedding/attend.csv")
email <- read_csv("https://raw.githubusercontent.com/STAT545-UBC/Classroom/master/data/wedding/emails.csv")
```

<!---The following chunk allows errors when knitting--->



## Exercise 1: Univariate Pivoting

Consider the Lord of the Rings data:


```r
lotr
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Film"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Race"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Gender"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Words"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"The Fellowship Of The Ring","2":"Elf","3":"Female","4":"1229"},{"1":"The Fellowship Of The Ring","2":"Hobbit","3":"Female","4":"14"},{"1":"The Fellowship Of The Ring","2":"Man","3":"Female","4":"0"},{"1":"The Two Towers","2":"Elf","3":"Female","4":"331"},{"1":"The Two Towers","2":"Hobbit","3":"Female","4":"0"},{"1":"The Two Towers","2":"Man","3":"Female","4":"401"},{"1":"The Return Of The King","2":"Elf","3":"Female","4":"183"},{"1":"The Return Of The King","2":"Hobbit","3":"Female","4":"2"},{"1":"The Return Of The King","2":"Man","3":"Female","4":"268"},{"1":"The Fellowship Of The Ring","2":"Elf","3":"Male","4":"971"},{"1":"The Fellowship Of The Ring","2":"Hobbit","3":"Male","4":"3644"},{"1":"The Fellowship Of The Ring","2":"Man","3":"Male","4":"1995"},{"1":"The Two Towers","2":"Elf","3":"Male","4":"513"},{"1":"The Two Towers","2":"Hobbit","3":"Male","4":"2463"},{"1":"The Two Towers","2":"Man","3":"Male","4":"3589"},{"1":"The Return Of The King","2":"Elf","3":"Male","4":"510"},{"1":"The Return Of The King","2":"Hobbit","3":"Male","4":"2673"},{"1":"The Return Of The King","2":"Man","3":"Male","4":"2459"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

1. Would you say this data is in tidy format?

2. Widen the data so that we see the words spoken by each race, by putting race as its own column.


```r
(lotr_wide <- lotr %>% 
  pivot_wider(id_cols = c(-Race, -Words), 
              names_from = Race, 
              values_from = Words))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Film"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Gender"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Elf"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Hobbit"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["Man"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"The Fellowship Of The Ring","2":"Female","3":"1229","4":"14","5":"0"},{"1":"The Two Towers","2":"Female","3":"331","4":"0","5":"401"},{"1":"The Return Of The King","2":"Female","3":"183","4":"2","5":"268"},{"1":"The Fellowship Of The Ring","2":"Male","3":"971","4":"3644","5":"1995"},{"1":"The Two Towers","2":"Male","3":"513","4":"2463","5":"3589"},{"1":"The Return Of The King","2":"Male","3":"510","4":"2673","5":"2459"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

3. Re-lengthen the wide LOTR data from Question 2 above.


```r
lotr_wide %>% 
  pivot_longer(cols = c(-Film, -Gender), 
               names_to  = "Race", 
               values_to = "Words")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Film"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Gender"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Race"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Words"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"The Fellowship Of The Ring","2":"Female","3":"Elf","4":"1229"},{"1":"The Fellowship Of The Ring","2":"Female","3":"Hobbit","4":"14"},{"1":"The Fellowship Of The Ring","2":"Female","3":"Man","4":"0"},{"1":"The Two Towers","2":"Female","3":"Elf","4":"331"},{"1":"The Two Towers","2":"Female","3":"Hobbit","4":"0"},{"1":"The Two Towers","2":"Female","3":"Man","4":"401"},{"1":"The Return Of The King","2":"Female","3":"Elf","4":"183"},{"1":"The Return Of The King","2":"Female","3":"Hobbit","4":"2"},{"1":"The Return Of The King","2":"Female","3":"Man","4":"268"},{"1":"The Fellowship Of The Ring","2":"Male","3":"Elf","4":"971"},{"1":"The Fellowship Of The Ring","2":"Male","3":"Hobbit","4":"3644"},{"1":"The Fellowship Of The Ring","2":"Male","3":"Man","4":"1995"},{"1":"The Two Towers","2":"Male","3":"Elf","4":"513"},{"1":"The Two Towers","2":"Male","3":"Hobbit","4":"2463"},{"1":"The Two Towers","2":"Male","3":"Man","4":"3589"},{"1":"The Return Of The King","2":"Male","3":"Elf","4":"510"},{"1":"The Return Of The King","2":"Male","3":"Hobbit","4":"2673"},{"1":"The Return Of The King","2":"Male","3":"Man","4":"2459"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

## Exercise 2: Multivariate Pivoting

Congratulations, you're getting married! In addition to the wedding, you've decided to hold two other events: a day-of brunch and a day-before round of golf.  You've made a guestlist of attendance so far, along with food preference for the food events (wedding and brunch).


```r
guest %>% 
  DT::datatable(rownames = FALSE)
```

<!--html_preserve--><div id="htmlwidget-1b28ba91a546ee17f560" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-1b28ba91a546ee17f560">{"x":{"filter":"none","data":[[1,1,1,1,2,2,3,4,5,5,5,6,6,7,7,8,9,10,11,12,12,12,12,12,13,13,14,14,15,15],["Sommer Medrano","Phillip Medrano","Blanka Medrano","Emaan Medrano","Blair Park","Nigel Webb","Sinead English","Ayra Marks","Atlanta Connolly","Denzel Connolly","Chanelle Shah","Jolene Welsh","Hayley Booker","Amayah Sanford","Erika Foley","Ciaron Acosta","Diana Stuart","Cosmo Dunkley","Cai Mcdaniel","Daisy-May Caldwell","Martin Caldwell","Violet Caldwell","Nazifa Caldwell","Eric Caldwell","Rosanna Bird","Kurtis Frost","Huma Stokes","Samuel Rutledge","Eddison Collier","Stewart Nicholls"],["PENDING","vegetarian","chicken","PENDING","chicken",null,"PENDING","vegetarian","PENDING","fish","chicken",null,"vegetarian",null,"PENDING","PENDING","vegetarian","PENDING","fish","chicken","PENDING","PENDING","chicken","chicken","vegetarian","PENDING",null,"chicken","PENDING","chicken"],["PENDING","Menu C","Menu A","PENDING","Menu C",null,"PENDING","Menu B","PENDING","Menu B","Menu C",null,"Menu C","PENDING","PENDING","Menu A","Menu C","PENDING","Menu C","Menu B","PENDING","PENDING","PENDING","Menu B","Menu C","PENDING",null,"Menu C","PENDING","Menu B"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","CANCELLED","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>party<\/th>\n      <th>name<\/th>\n      <th>meal_wedding<\/th>\n      <th>meal_brunch<\/th>\n      <th>attendance_wedding<\/th>\n      <th>attendance_brunch<\/th>\n      <th>attendance_golf<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

1. Put "meal" and "attendance" as their own columns, with the events living in a new column.


```r
(guest_long <- guest %>% 
  pivot_longer(cols      = c(-party, -name), 
               names_to  = c(".value", "event"),
               names_sep = "_"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["party"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["event"],"name":[3],"type":["chr"],"align":["left"]},{"label":["meal"],"name":[4],"type":["chr"],"align":["left"]},{"label":["attendance"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"Sommer Medrano","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"1","2":"Sommer Medrano","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"1","2":"Sommer Medrano","3":"golf","4":"NA","5":"PENDING"},{"1":"1","2":"Phillip Medrano","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"1","2":"Phillip Medrano","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"1","2":"Phillip Medrano","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"brunch","4":"Menu A","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"1","2":"Emaan Medrano","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"1","2":"Emaan Medrano","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"1","2":"Emaan Medrano","3":"golf","4":"NA","5":"PENDING"},{"1":"2","2":"Blair Park","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"2","2":"Blair Park","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"2","2":"Blair Park","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"2","2":"Nigel Webb","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"2","2":"Nigel Webb","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"2","2":"Nigel Webb","3":"golf","4":"NA","5":"CANCELLED"},{"1":"3","2":"Sinead English","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"3","2":"Sinead English","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"3","2":"Sinead English","3":"golf","4":"NA","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"wedding","4":"vegetarian","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"brunch","4":"Menu B","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"golf","4":"NA","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"golf","4":"NA","5":"PENDING"},{"1":"5","2":"Denzel Connolly","3":"wedding","4":"fish","5":"CONFIRMED"},{"1":"5","2":"Denzel Connolly","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"5","2":"Denzel Connolly","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"6","2":"Jolene Welsh","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"6","2":"Jolene Welsh","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"6","2":"Jolene Welsh","3":"golf","4":"NA","5":"CANCELLED"},{"1":"6","2":"Hayley Booker","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"6","2":"Hayley Booker","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"6","2":"Hayley Booker","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"7","2":"Amayah Sanford","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"7","2":"Amayah Sanford","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"7","2":"Amayah Sanford","3":"golf","4":"NA","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"golf","4":"NA","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"brunch","4":"Menu A","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"golf","4":"NA","5":"PENDING"},{"1":"9","2":"Diana Stuart","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"9","2":"Diana Stuart","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"9","2":"Diana Stuart","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"10","2":"Cosmo Dunkley","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"10","2":"Cosmo Dunkley","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"10","2":"Cosmo Dunkley","3":"golf","4":"NA","5":"PENDING"},{"1":"11","2":"Cai Mcdaniel","3":"wedding","4":"fish","5":"CONFIRMED"},{"1":"11","2":"Cai Mcdaniel","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"11","2":"Cai Mcdaniel","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"12","2":"Daisy-May Caldwell","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"12","2":"Daisy-May Caldwell","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"12","2":"Daisy-May Caldwell","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"12","2":"Martin Caldwell","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"12","2":"Martin Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Martin Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"wedding","4":"chicken","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Eric Caldwell","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"12","2":"Eric Caldwell","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"12","2":"Eric Caldwell","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"13","2":"Kurtis Frost","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"13","2":"Kurtis Frost","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"13","2":"Kurtis Frost","3":"golf","4":"NA","5":"PENDING"},{"1":"14","2":"Huma Stokes","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"14","2":"Huma Stokes","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"14","2":"Huma Stokes","3":"golf","4":"NA","5":"CANCELLED"},{"1":"14","2":"Samuel Rutledge","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"14","2":"Samuel Rutledge","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"14","2":"Samuel Rutledge","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"15","2":"Eddison Collier","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"15","2":"Eddison Collier","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"15","2":"Eddison Collier","3":"golf","4":"NA","5":"PENDING"},{"1":"15","2":"Stewart Nicholls","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"15","2":"Stewart Nicholls","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"15","2":"Stewart Nicholls","3":"golf","4":"NA","5":"CONFIRMED"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

2. Use `tidyr::separate()` to split the name into two columns: "first" and "last". Then, re-unite them with `tidyr::unite()`.


```r
guest_long %>% 
  separate(name, into = c("first", "last")) %>%
  unite(col = "name", first, last , sep = " ")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["party"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["event"],"name":[3],"type":["chr"],"align":["left"]},{"label":["meal"],"name":[4],"type":["chr"],"align":["left"]},{"label":["attendance"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"Sommer Medrano","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"1","2":"Sommer Medrano","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"1","2":"Sommer Medrano","3":"golf","4":"NA","5":"PENDING"},{"1":"1","2":"Phillip Medrano","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"1","2":"Phillip Medrano","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"1","2":"Phillip Medrano","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"brunch","4":"Menu A","5":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"1","2":"Emaan Medrano","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"1","2":"Emaan Medrano","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"1","2":"Emaan Medrano","3":"golf","4":"NA","5":"PENDING"},{"1":"2","2":"Blair Park","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"2","2":"Blair Park","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"2","2":"Blair Park","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"2","2":"Nigel Webb","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"2","2":"Nigel Webb","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"2","2":"Nigel Webb","3":"golf","4":"NA","5":"CANCELLED"},{"1":"3","2":"Sinead English","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"3","2":"Sinead English","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"3","2":"Sinead English","3":"golf","4":"NA","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"wedding","4":"vegetarian","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"brunch","4":"Menu B","5":"PENDING"},{"1":"4","2":"Ayra Marks","3":"golf","4":"NA","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"golf","4":"NA","5":"PENDING"},{"1":"5","2":"Denzel Connolly","3":"wedding","4":"fish","5":"CONFIRMED"},{"1":"5","2":"Denzel Connolly","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"5","2":"Denzel Connolly","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"6","2":"Jolene Welsh","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"6","2":"Jolene Welsh","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"6","2":"Jolene Welsh","3":"golf","4":"NA","5":"CANCELLED"},{"1":"6","2":"Hayley Booker","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"6","2":"Hayley Booker","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"6","2":"Hayley Booker","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"7","2":"Amayah Sanford","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"7","2":"Amayah Sanford","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"7","2":"Amayah Sanford","3":"golf","4":"NA","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"7","2":"Erika Foley","3":"golf","4":"NA","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"brunch","4":"Menu A","5":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"golf","4":"NA","5":"PENDING"},{"1":"9","2":"Diana Stuart","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"9","2":"Diana Stuart","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"9","2":"Diana Stuart","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"10","2":"Cosmo Dunkley","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"10","2":"Cosmo Dunkley","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"10","2":"Cosmo Dunkley","3":"golf","4":"NA","5":"PENDING"},{"1":"11","2":"Cai Mcdaniel","3":"wedding","4":"fish","5":"CONFIRMED"},{"1":"11","2":"Cai Mcdaniel","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"11","2":"Cai Mcdaniel","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"12","2":"Daisy May","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"12","2":"Daisy May","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"12","2":"Daisy May","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"12","2":"Martin Caldwell","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"12","2":"Martin Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Martin Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"wedding","4":"chicken","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"golf","4":"NA","5":"PENDING"},{"1":"12","2":"Eric Caldwell","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"12","2":"Eric Caldwell","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"12","2":"Eric Caldwell","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"wedding","4":"vegetarian","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"13","2":"Kurtis Frost","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"13","2":"Kurtis Frost","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"13","2":"Kurtis Frost","3":"golf","4":"NA","5":"PENDING"},{"1":"14","2":"Huma Stokes","3":"wedding","4":"NA","5":"CANCELLED"},{"1":"14","2":"Huma Stokes","3":"brunch","4":"NA","5":"CANCELLED"},{"1":"14","2":"Huma Stokes","3":"golf","4":"NA","5":"CANCELLED"},{"1":"14","2":"Samuel Rutledge","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"14","2":"Samuel Rutledge","3":"brunch","4":"Menu C","5":"CONFIRMED"},{"1":"14","2":"Samuel Rutledge","3":"golf","4":"NA","5":"CONFIRMED"},{"1":"15","2":"Eddison Collier","3":"wedding","4":"PENDING","5":"PENDING"},{"1":"15","2":"Eddison Collier","3":"brunch","4":"PENDING","5":"PENDING"},{"1":"15","2":"Eddison Collier","3":"golf","4":"NA","5":"PENDING"},{"1":"15","2":"Stewart Nicholls","3":"wedding","4":"chicken","5":"CONFIRMED"},{"1":"15","2":"Stewart Nicholls","3":"brunch","4":"Menu B","5":"CONFIRMED"},{"1":"15","2":"Stewart Nicholls","3":"golf","4":"NA","5":"CONFIRMED"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

3. Which parties still have a "PENDING" status for all members and all events?


```r
guest_long %>% 
  group_by(party) %>% 
  summarize(all_pending = all(attendance == "PENDING"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["party"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["all_pending"],"name":[2],"type":["lgl"],"align":["right"]}],"data":[{"1":"1","2":"FALSE"},{"1":"2","2":"FALSE"},{"1":"3","2":"TRUE"},{"1":"4","2":"TRUE"},{"1":"5","2":"FALSE"},{"1":"6","2":"FALSE"},{"1":"7","2":"FALSE"},{"1":"8","2":"TRUE"},{"1":"9","2":"FALSE"},{"1":"10","2":"TRUE"},{"1":"11","2":"FALSE"},{"1":"12","2":"FALSE"},{"1":"13","2":"FALSE"},{"1":"14","2":"FALSE"},{"1":"15","2":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

4. Which parties still have a "PENDING" status for all members for the wedding?


```r
guest %>% 
  group_by(party) %>% 
  summarize(pending_wedding = all(attendance_wedding == "PENDING"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["party"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["pending_wedding"],"name":[2],"type":["lgl"],"align":["right"]}],"data":[{"1":"1","2":"FALSE"},{"1":"2","2":"FALSE"},{"1":"3","2":"TRUE"},{"1":"4","2":"TRUE"},{"1":"5","2":"FALSE"},{"1":"6","2":"FALSE"},{"1":"7","2":"FALSE"},{"1":"8","2":"TRUE"},{"1":"9","2":"FALSE"},{"1":"10","2":"TRUE"},{"1":"11","2":"FALSE"},{"1":"12","2":"FALSE"},{"1":"13","2":"FALSE"},{"1":"14","2":"FALSE"},{"1":"15","2":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


5. Put the data back to the way it was.


```r
guest_long %>% 
  pivot_wider(id_cols     = c(party, name), 
              names_from  = event, 
              names_sep   = "_", 
              values_from = c(meal, attendance))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["party"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["meal_wedding"],"name":[3],"type":["chr"],"align":["left"]},{"label":["meal_brunch"],"name":[4],"type":["chr"],"align":["left"]},{"label":["meal_golf"],"name":[5],"type":["chr"],"align":["left"]},{"label":["attendance_wedding"],"name":[6],"type":["chr"],"align":["left"]},{"label":["attendance_brunch"],"name":[7],"type":["chr"],"align":["left"]},{"label":["attendance_golf"],"name":[8],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"Sommer Medrano","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"1","2":"Phillip Medrano","3":"vegetarian","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"1","2":"Blanka Medrano","3":"chicken","4":"Menu A","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"1","2":"Emaan Medrano","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"2","2":"Blair Park","3":"chicken","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"2","2":"Nigel Webb","3":"NA","4":"NA","5":"NA","6":"CANCELLED","7":"CANCELLED","8":"CANCELLED"},{"1":"3","2":"Sinead English","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"4","2":"Ayra Marks","3":"vegetarian","4":"Menu B","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"5","2":"Atlanta Connolly","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"5","2":"Denzel Connolly","3":"fish","4":"Menu B","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"5","2":"Chanelle Shah","3":"chicken","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"6","2":"Jolene Welsh","3":"NA","4":"NA","5":"NA","6":"CANCELLED","7":"CANCELLED","8":"CANCELLED"},{"1":"6","2":"Hayley Booker","3":"vegetarian","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"7","2":"Amayah Sanford","3":"NA","4":"PENDING","5":"NA","6":"CANCELLED","7":"PENDING","8":"PENDING"},{"1":"7","2":"Erika Foley","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"8","2":"Ciaron Acosta","3":"PENDING","4":"Menu A","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"9","2":"Diana Stuart","3":"vegetarian","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"10","2":"Cosmo Dunkley","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"11","2":"Cai Mcdaniel","3":"fish","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"12","2":"Daisy-May Caldwell","3":"chicken","4":"Menu B","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"12","2":"Martin Caldwell","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"12","2":"Violet Caldwell","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"12","2":"Nazifa Caldwell","3":"chicken","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"12","2":"Eric Caldwell","3":"chicken","4":"Menu B","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"13","2":"Rosanna Bird","3":"vegetarian","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"13","2":"Kurtis Frost","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"14","2":"Huma Stokes","3":"NA","4":"NA","5":"NA","6":"CANCELLED","7":"CANCELLED","8":"CANCELLED"},{"1":"14","2":"Samuel Rutledge","3":"chicken","4":"Menu C","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"},{"1":"15","2":"Eddison Collier","3":"PENDING","4":"PENDING","5":"NA","6":"PENDING","7":"PENDING","8":"PENDING"},{"1":"15","2":"Stewart Nicholls","3":"chicken","4":"Menu B","5":"NA","6":"CONFIRMED","7":"CONFIRMED","8":"CONFIRMED"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
# use dplyr to eliminate meal_golf column
```

6. You also have a list of emails for each party, in this worksheet under the variable `email`. Change this so that each person gets their own row. Use `tidyr::separate_rows()`


```r
email %>% 
  separate_rows(guest, sep = ", ")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["guest"],"name":[1],"type":["chr"],"align":["left"]},{"label":["email"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"Sommer Medrano","2":"sommm@gmail.com"},{"1":"Phillip Medrano","2":"sommm@gmail.com"},{"1":"Blanka Medrano","2":"sommm@gmail.com"},{"1":"Emaan Medrano","2":"sommm@gmail.com"},{"1":"Blair Park","2":"bpark@gmail.com"},{"1":"Nigel Webb","2":"bpark@gmail.com"},{"1":"Sinead English","2":"singlish@hotmail.ca"},{"1":"Ayra Marks","2":"marksa42@gmail.com"},{"1":"Jolene Welsh","2":"jw1987@hotmail.com"},{"1":"Hayley Booker","2":"jw1987@hotmail.com"},{"1":"Amayah Sanford","2":"erikaaaaaa@gmail.com"},{"1":"Erika Foley","2":"erikaaaaaa@gmail.com"},{"1":"Ciaron Acosta","2":"shining_ciaron@gmail.com"},{"1":"Diana Stuart","2":"doodledianastu@gmail.com"},{"1":"Daisy-May Caldwell","2":"caldwellfamily5212@gmail.com"},{"1":"Martin Caldwell","2":"caldwellfamily5212@gmail.com"},{"1":"Violet Caldwell","2":"caldwellfamily5212@gmail.com"},{"1":"Nazifa Caldwell","2":"caldwellfamily5212@gmail.com"},{"1":"Eric Caldwell","2":"caldwellfamily5212@gmail.com"},{"1":"Rosanna Bird","2":"rosy1987b@gmail.com"},{"1":"Kurtis Frost","2":"rosy1987b@gmail.com"},{"1":"Huma Stokes","2":"humastokes@gmail.com"},{"1":"Samuel Rutledge","2":"humastokes@gmail.com"},{"1":"Eddison Collier","2":"eddison.collier@gmail.com"},{"1":"Stewart Nicholls","2":"eddison.collier@gmail.com"},{"1":"Turner Jones","2":"tjjones12@hotmail.ca"},{"1":"Albert Marshall","2":"themarshallfamily1234@gmail.com"},{"1":"Vivian Marshall","2":"themarshallfamily1234@gmail.com"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## Exercise 3: Making tibbles

1. Create a tibble that has the following columns:

- A `label` column with `"Sample A"` in its entries.
- 100 random observations drawn from the N(0,1) distribution in the column `x`
- `y` calculated as the `x` values + N(0,1) error. 


```r
n <- 100
tibble(label = "Sample A",
             x = rnorm(n),
             y = x + rnorm(n))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["label"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["y"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"Sample A","2":"-1.233669517","3":"0.16828938"},{"1":"Sample A","2":"0.604017848","3":"0.75945265"},{"1":"Sample A","2":"0.374659652","3":"0.06506016"},{"1":"Sample A","2":"1.497775451","3":"0.55557238"},{"1":"Sample A","2":"1.727409912","3":"2.52877310"},{"1":"Sample A","2":"1.676371164","3":"1.53829398"},{"1":"Sample A","2":"0.241411068","3":"-0.52842589"},{"1":"Sample A","2":"-1.178258006","3":"-0.30693789"},{"1":"Sample A","2":"-0.238617322","3":"0.76982789"},{"1":"Sample A","2":"-0.300915362","3":"1.38345308"},{"1":"Sample A","2":"-0.446680840","3":"-1.37519720"},{"1":"Sample A","2":"0.310012672","3":"-0.96101886"},{"1":"Sample A","2":"0.370962789","3":"-0.39983599"},{"1":"Sample A","2":"1.562476449","3":"-0.65015132"},{"1":"Sample A","2":"-1.154136208","3":"-1.40970267"},{"1":"Sample A","2":"1.392022454","3":"2.34320628"},{"1":"Sample A","2":"0.536603331","3":"0.81106009"},{"1":"Sample A","2":"-1.419929402","3":"-1.31898387"},{"1":"Sample A","2":"-1.092137273","3":"-0.62949752"},{"1":"Sample A","2":"1.848085317","3":"2.22138786"},{"1":"Sample A","2":"0.486617294","3":"-0.11451450"},{"1":"Sample A","2":"-1.111844113","3":"-1.43573098"},{"1":"Sample A","2":"-2.184290869","3":"-2.13054302"},{"1":"Sample A","2":"-0.801973002","3":"-2.98991259"},{"1":"Sample A","2":"0.820441476","3":"0.52138556"},{"1":"Sample A","2":"0.577113767","3":"-0.19642232"},{"1":"Sample A","2":"0.522657900","3":"1.14149937"},{"1":"Sample A","2":"-1.732106607","3":"-1.31764981"},{"1":"Sample A","2":"-0.043240224","3":"-0.55504820"},{"1":"Sample A","2":"-0.199215105","3":"0.20528096"},{"1":"Sample A","2":"-0.316111504","3":"-1.27435735"},{"1":"Sample A","2":"-0.733071245","3":"-2.60426696"},{"1":"Sample A","2":"-0.241846219","3":"-1.05013575"},{"1":"Sample A","2":"0.282115228","3":"0.15472372"},{"1":"Sample A","2":"0.433819338","3":"0.17162919"},{"1":"Sample A","2":"1.036737438","3":"-0.96492447"},{"1":"Sample A","2":"-0.001265109","3":"1.18282555"},{"1":"Sample A","2":"-0.343383211","3":"1.38416578"},{"1":"Sample A","2":"0.019928738","3":"0.41497119"},{"1":"Sample A","2":"-0.441446415","3":"-1.42352865"},{"1":"Sample A","2":"0.760075671","3":"-0.26355022"},{"1":"Sample A","2":"-0.082687161","3":"-0.76279471"},{"1":"Sample A","2":"-0.530483414","3":"0.48766633"},{"1":"Sample A","2":"-0.589024477","3":"-0.51896555"},{"1":"Sample A","2":"-1.565890330","3":"-0.64327720"},{"1":"Sample A","2":"-0.528119956","3":"-0.15422591"},{"1":"Sample A","2":"-1.630293816","3":"-0.77365488"},{"1":"Sample A","2":"0.026542971","3":"0.12090870"},{"1":"Sample A","2":"-1.674171257","3":"-2.07756654"},{"1":"Sample A","2":"0.613026560","3":"1.86709598"},{"1":"Sample A","2":"-0.336980065","3":"1.18893032"},{"1":"Sample A","2":"0.655435142","3":"1.25856963"},{"1":"Sample A","2":"-0.814626128","3":"-0.31703167"},{"1":"Sample A","2":"0.813287170","3":"0.84220175"},{"1":"Sample A","2":"-0.812739570","3":"-3.35477906"},{"1":"Sample A","2":"-0.045755100","3":"0.09859228"},{"1":"Sample A","2":"-2.220879047","3":"-2.71790208"},{"1":"Sample A","2":"1.002259800","3":"2.22171516"},{"1":"Sample A","2":"0.817467386","3":"1.83374143"},{"1":"Sample A","2":"1.138044835","3":"1.84864945"},{"1":"Sample A","2":"-1.092034152","3":"-1.33256367"},{"1":"Sample A","2":"1.172482089","3":"-0.48071130"},{"1":"Sample A","2":"-0.481397891","3":"1.15304659"},{"1":"Sample A","2":"-1.558303615","3":"-1.25309713"},{"1":"Sample A","2":"-0.452229206","3":"1.15305438"},{"1":"Sample A","2":"-0.475113157","3":"-0.10181554"},{"1":"Sample A","2":"0.662502665","3":"0.49706832"},{"1":"Sample A","2":"-0.350285596","3":"-0.69298935"},{"1":"Sample A","2":"-0.079977987","3":"0.37853796"},{"1":"Sample A","2":"0.981847866","3":"1.00984410"},{"1":"Sample A","2":"-0.016455070","3":"-2.20514658"},{"1":"Sample A","2":"-0.856116921","3":"-1.27721530"},{"1":"Sample A","2":"-0.171945389","3":"-1.60414309"},{"1":"Sample A","2":"-2.231719721","3":"-0.77234981"},{"1":"Sample A","2":"0.984516419","3":"0.60815866"},{"1":"Sample A","2":"-0.657600841","3":"0.53087880"},{"1":"Sample A","2":"0.574508307","3":"0.63089992"},{"1":"Sample A","2":"0.864212247","3":"0.65679934"},{"1":"Sample A","2":"-0.811051829","3":"0.43467426"},{"1":"Sample A","2":"-0.170706114","3":"1.23637151"},{"1":"Sample A","2":"-0.670985862","3":"-2.35761327"},{"1":"Sample A","2":"-1.071289276","3":"-1.18525090"},{"1":"Sample A","2":"0.120224977","3":"-1.51198132"},{"1":"Sample A","2":"2.222441624","3":"2.47159409"},{"1":"Sample A","2":"0.549189356","3":"0.68028678"},{"1":"Sample A","2":"1.124167104","3":"1.56202006"},{"1":"Sample A","2":"-0.539571607","3":"-0.46204813"},{"1":"Sample A","2":"0.482587888","3":"0.50996582"},{"1":"Sample A","2":"-0.274864694","3":"-1.65470383"},{"1":"Sample A","2":"0.670635369","3":"0.82760035"},{"1":"Sample A","2":"-0.463940515","3":"-2.34675820"},{"1":"Sample A","2":"-1.750768644","3":"0.23111712"},{"1":"Sample A","2":"0.118349766","3":"-1.93938139"},{"1":"Sample A","2":"-1.059758068","3":"-1.28877303"},{"1":"Sample A","2":"-0.995012693","3":"0.72294863"},{"1":"Sample A","2":"-0.007966097","3":"-0.35187651"},{"1":"Sample A","2":"-0.020481019","3":"0.37102424"},{"1":"Sample A","2":"1.318876537","3":"1.98105291"},{"1":"Sample A","2":"-1.534426249","3":"-1.72995811"},{"1":"Sample A","2":"-1.651843848","3":"-3.60582815"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


2. Generate a Gaussian sample of size 100 for each combination of the following means (`mu`) and standard deviations (`sd`).


```r
n <- 100
mu <- c(-5, 0, 5)
sd <- c(1, 3, 10)
FILL_THIS_IN(mu = mu, sd = sd) %>% 
  group_by_all() %>% 
  mutate(z = list(rnorm(n, mu, sd))) %>% 
  FILL_THIS_IN
```

```
## Error in FILL_THIS_IN(mu = mu, sd = sd): could not find function "FILL_THIS_IN"
```

3. Fix the `experiment` tibble below (originally defined in the documentation of the `tidyr::expand()` function) so that all three repeats are displayed for each person, and the measurements are kept. The code is given, but needs one adjustment. What is it?


```r
experiment <- tibble(
  name = rep(c("Alex", "Robert", "Sam"), c(3, 2, 1)),
  trt  = rep(c("a", "b", "a"), c(3, 2, 1)),
  rep = c(1, 2, 3, 1, 2, 1),
  measurement_1 = runif(6),
  measurement_2 = runif(6)
)
experiment %>% complete(nesting(name, trt), rep)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trt"],"name":[2],"type":["chr"],"align":["left"]},{"label":["rep"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["measurement_1"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["measurement_2"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"Alex","2":"a","3":"1","4":"0.97855183","5":"0.5153254"},{"1":"Alex","2":"a","3":"2","4":"0.45943925","5":"0.4315155"},{"1":"Alex","2":"a","3":"3","4":"0.72282299","5":"0.2284227"},{"1":"Robert","2":"b","3":"1","4":"0.61875411","5":"0.6278902"},{"1":"Robert","2":"b","3":"2","4":"0.94150406","5":"0.9378052"},{"1":"Robert","2":"b","3":"3","4":"NA","5":"NA"},{"1":"Sam","2":"a","3":"1","4":"0.01163619","5":"0.9065764"},{"1":"Sam","2":"a","3":"2","4":"NA","5":"NA"},{"1":"Sam","2":"a","3":"3","4":"NA","5":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


