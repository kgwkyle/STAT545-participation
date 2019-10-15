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
# Preliminary

Load the following datasets that will be used for this class:


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

<!--html_preserve--><div id="htmlwidget-bc8a6262ddb1f49b7c68" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-bc8a6262ddb1f49b7c68">{"x":{"filter":"none","data":[[1,1,1,1,2,2,3,4,5,5,5,6,6,7,7,8,9,10,11,12,12,12,12,12,13,13,14,14,15,15],["Sommer Medrano","Phillip Medrano","Blanka Medrano","Emaan Medrano","Blair Park","Nigel Webb","Sinead English","Ayra Marks","Atlanta Connolly","Denzel Connolly","Chanelle Shah","Jolene Welsh","Hayley Booker","Amayah Sanford","Erika Foley","Ciaron Acosta","Diana Stuart","Cosmo Dunkley","Cai Mcdaniel","Daisy-May Caldwell","Martin Caldwell","Violet Caldwell","Nazifa Caldwell","Eric Caldwell","Rosanna Bird","Kurtis Frost","Huma Stokes","Samuel Rutledge","Eddison Collier","Stewart Nicholls"],["PENDING","vegetarian","chicken","PENDING","chicken",null,"PENDING","vegetarian","PENDING","fish","chicken",null,"vegetarian",null,"PENDING","PENDING","vegetarian","PENDING","fish","chicken","PENDING","PENDING","chicken","chicken","vegetarian","PENDING",null,"chicken","PENDING","chicken"],["PENDING","Menu C","Menu A","PENDING","Menu C",null,"PENDING","Menu B","PENDING","Menu B","Menu C",null,"Menu C","PENDING","PENDING","Menu A","Menu C","PENDING","Menu C","Menu B","PENDING","PENDING","PENDING","Menu B","Menu C","PENDING",null,"Menu C","PENDING","Menu B"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","CANCELLED","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"],["PENDING","CONFIRMED","CONFIRMED","PENDING","CONFIRMED","CANCELLED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","CANCELLED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","PENDING","CONFIRMED","CONFIRMED","PENDING","PENDING","PENDING","CONFIRMED","CONFIRMED","PENDING","CANCELLED","CONFIRMED","PENDING","CONFIRMED"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>party<\/th>\n      <th>name<\/th>\n      <th>meal_wedding<\/th>\n      <th>meal_brunch<\/th>\n      <th>attendance_wedding<\/th>\n      <th>attendance_brunch<\/th>\n      <th>attendance_golf<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

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
{"columns":[{"label":["label"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["y"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"Sample A","2":"0.62639366","3":"1.28322079"},{"1":"Sample A","2":"-0.29100033","3":"0.38792404"},{"1":"Sample A","2":"1.11283984","3":"1.52556109"},{"1":"Sample A","2":"1.69819605","3":"0.27774184"},{"1":"Sample A","2":"-0.03379241","3":"0.42290258"},{"1":"Sample A","2":"0.05756435","3":"0.21616442"},{"1":"Sample A","2":"1.43639544","3":"1.72785339"},{"1":"Sample A","2":"-1.21186174","3":"-0.37728624"},{"1":"Sample A","2":"-1.07685671","3":"-0.65373397"},{"1":"Sample A","2":"1.21449941","3":"2.82320081"},{"1":"Sample A","2":"1.81881190","3":"2.15746689"},{"1":"Sample A","2":"0.26215509","3":"1.13119375"},{"1":"Sample A","2":"0.68978238","3":"0.08487649"},{"1":"Sample A","2":"-1.23101951","3":"1.45001210"},{"1":"Sample A","2":"1.27492172","3":"1.47671529"},{"1":"Sample A","2":"-1.05834587","3":"-2.35518053"},{"1":"Sample A","2":"-0.29786176","3":"-2.49190166"},{"1":"Sample A","2":"1.30884120","3":"1.29225788"},{"1":"Sample A","2":"-1.05809882","3":"-0.53840731"},{"1":"Sample A","2":"0.10818697","3":"-0.03583072"},{"1":"Sample A","2":"0.19765751","3":"-1.69643668"},{"1":"Sample A","2":"-0.11298746","3":"0.46005306"},{"1":"Sample A","2":"-0.98945378","3":"-0.09298354"},{"1":"Sample A","2":"-1.10833490","3":"-0.88630484"},{"1":"Sample A","2":"-2.10363993","3":"-2.15016056"},{"1":"Sample A","2":"0.47687315","3":"2.16295861"},{"1":"Sample A","2":"-0.01376107","3":"-0.23631976"},{"1":"Sample A","2":"-0.12185967","3":"0.32092752"},{"1":"Sample A","2":"0.45568305","3":"0.09625456"},{"1":"Sample A","2":"-0.13432151","3":"0.04726902"},{"1":"Sample A","2":"-1.09427149","3":"-2.05792817"},{"1":"Sample A","2":"-0.41732791","3":"-0.74806214"},{"1":"Sample A","2":"0.18529461","3":"0.37655208"},{"1":"Sample A","2":"1.35554524","3":"1.93294918"},{"1":"Sample A","2":"-1.80508062","3":"-1.75374834"},{"1":"Sample A","2":"1.13067898","3":"1.91883536"},{"1":"Sample A","2":"0.65368532","3":"1.12063669"},{"1":"Sample A","2":"-0.60424281","3":"-0.70802509"},{"1":"Sample A","2":"-0.74829317","3":"-2.05206088"},{"1":"Sample A","2":"-0.31647310","3":"0.12471119"},{"1":"Sample A","2":"0.08984140","3":"1.45854589"},{"1":"Sample A","2":"-0.16361103","3":"-0.73286271"},{"1":"Sample A","2":"-0.36759103","3":"-0.38320842"},{"1":"Sample A","2":"0.30861445","3":"-0.04446486"},{"1":"Sample A","2":"-0.38038152","3":"0.91063305"},{"1":"Sample A","2":"0.62128128","3":"-0.19777132"},{"1":"Sample A","2":"0.11496402","3":"-0.73977179"},{"1":"Sample A","2":"-0.66280050","3":"-0.95742214"},{"1":"Sample A","2":"-1.18236827","3":"-2.19236729"},{"1":"Sample A","2":"1.01289802","3":"-0.59539007"},{"1":"Sample A","2":"1.18754879","3":"0.49876862"},{"1":"Sample A","2":"1.55065648","3":"0.52404241"},{"1":"Sample A","2":"0.50104215","3":"0.93868388"},{"1":"Sample A","2":"0.63881679","3":"-0.15364301"},{"1":"Sample A","2":"-0.15596469","3":"-3.08660399"},{"1":"Sample A","2":"0.45815333","3":"0.19616565"},{"1":"Sample A","2":"0.87670932","3":"-0.04943646"},{"1":"Sample A","2":"-1.56946697","3":"-1.26290252"},{"1":"Sample A","2":"-0.64430659","3":"-0.90034530"},{"1":"Sample A","2":"0.50448689","3":"0.72514679"},{"1":"Sample A","2":"-0.90307738","3":"-0.46573294"},{"1":"Sample A","2":"0.50921161","3":"0.35625452"},{"1":"Sample A","2":"2.01710331","3":"2.26412320"},{"1":"Sample A","2":"0.82952858","3":"0.47739310"},{"1":"Sample A","2":"-0.21225414","3":"1.47942385"},{"1":"Sample A","2":"1.34148590","3":"0.41781102"},{"1":"Sample A","2":"0.93283716","3":"1.10763173"},{"1":"Sample A","2":"-0.51478799","3":"-1.68328418"},{"1":"Sample A","2":"1.17541469","3":"2.57006931"},{"1":"Sample A","2":"0.35351328","3":"-0.52749702"},{"1":"Sample A","2":"0.14012434","3":"0.37075117"},{"1":"Sample A","2":"-0.19531325","3":"0.16029081"},{"1":"Sample A","2":"0.26063525","3":"0.07507974"},{"1":"Sample A","2":"-0.28189066","3":"1.06347566"},{"1":"Sample A","2":"-1.75561319","3":"-0.82298114"},{"1":"Sample A","2":"1.33544015","3":"1.50096910"},{"1":"Sample A","2":"1.54220934","3":"-0.79410101"},{"1":"Sample A","2":"-1.10712321","3":"-1.03087264"},{"1":"Sample A","2":"0.39526458","3":"0.71576371"},{"1":"Sample A","2":"0.79183898","3":"-0.01600737"},{"1":"Sample A","2":"0.74992674","3":"1.18232567"},{"1":"Sample A","2":"1.96354861","3":"4.31977588"},{"1":"Sample A","2":"1.18056882","3":"0.97002249"},{"1":"Sample A","2":"-0.03080225","3":"-0.04405375"},{"1":"Sample A","2":"-0.41739892","3":"-0.66931005"},{"1":"Sample A","2":"0.23295371","3":"1.18451950"},{"1":"Sample A","2":"0.93861787","3":"0.87733804"},{"1":"Sample A","2":"0.45646439","3":"-0.30994549"},{"1":"Sample A","2":"-1.65972635","3":"-1.92038401"},{"1":"Sample A","2":"-0.23949920","3":"-0.04130623"},{"1":"Sample A","2":"-2.17712601","3":"-1.96215197"},{"1":"Sample A","2":"-0.38267355","3":"0.54382831"},{"1":"Sample A","2":"-0.60427832","3":"-1.88304685"},{"1":"Sample A","2":"0.29740636","3":"0.71129379"},{"1":"Sample A","2":"-0.06461832","3":"0.48181236"},{"1":"Sample A","2":"-1.27694225","3":"-1.35099429"},{"1":"Sample A","2":"-0.89646755","3":"-0.70164416"},{"1":"Sample A","2":"-1.11708374","3":"0.82683552"},{"1":"Sample A","2":"1.76960650","3":"1.80994800"},{"1":"Sample A","2":"-0.98370725","3":"-0.65338755"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trt"],"name":[2],"type":["chr"],"align":["left"]},{"label":["rep"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["measurement_1"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["measurement_2"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"Alex","2":"a","3":"1","4":"0.732679365","5":"0.02257802"},{"1":"Alex","2":"a","3":"2","4":"0.338048018","5":"0.10387551"},{"1":"Alex","2":"a","3":"3","4":"0.005307734","5":"0.23604465"},{"1":"Robert","2":"b","3":"1","4":"0.708564006","5":"0.68858962"},{"1":"Robert","2":"b","3":"2","4":"0.598145620","5":"0.09863610"},{"1":"Robert","2":"b","3":"3","4":"NA","5":"NA"},{"1":"Sam","2":"a","3":"1","4":"0.512082863","5":"0.30581474"},{"1":"Sam","2":"a","3":"2","4":"NA","5":"NA"},{"1":"Sam","2":"a","3":"3","4":"NA","5":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


