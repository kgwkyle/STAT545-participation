---
title: "cm010 Exercises: Tibble Joins"
date: "October 3, 2019"
output: 
  html_document:
    keep_md: true
    df_print: paged
    toc: yes
    theme: cerulean
---

## Requirements

You will need Joey's `singer` R package for this exercise. And to install that, you'll need to install `devtools`. Running this code in your console should do the trick:

```
install.packages("devtools")
devtools::install_github("JoeyBernhardt/singer")
```

Load required packages:



<!---The following chunk allows errors when knitting--->



## Exercise 1: `singer`

The package `singer` comes with two smallish data frames about songs. Let's take a look at them (after minor modifications by renaming and shuffling):


```r
(time <- as_tibble(songs) %>% 
   rename(song = title))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"Corduroy","2":"Pearl Jam","3":"1994"},{"1":"Grievance","2":"Pearl Jam","3":"2000"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994"},{"1":"Present Tense","2":"Pearl Jam","3":"1996"},{"1":"MFC","2":"Pearl Jam","3":"1998"},{"1":"Lukin","2":"Pearl Jam","3":"1996"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992"},{"1":"Martin_ Doom! It's Seven O'Clock","2":"The Boo Radleys","3":"1995"},{"1":"Leaves And Sand","2":"The Boo Radleys","3":"1993"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998"},{"1":"Comb Your Hair","2":"The Boo Radleys","3":"1998"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993"},{"1":"Mine Again","2":"Mariah Carey","3":"2005"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005"},{"1":"Babydoll","2":"Mariah Carey","3":"1997"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005"},{"1":"Vision Of Love","2":"Mariah Carey","3":"1990"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


```r
(album <- as_tibble(locations) %>% 
   select(title, everything()) %>% 
   rename(album = release,
          song  = title))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["city"],"name":[3],"type":["chr"],"align":["left"]},{"label":["album"],"name":[4],"type":["chr"],"align":["left"]}],"data":[{"1":"Grievance","2":"Pearl Jam","3":"Seattle, WA","4":"Binaural"},{"1":"Stupidmop","2":"Pearl Jam","3":"Seattle, WA","4":"Vitalogy"},{"1":"Present Tense","2":"Pearl Jam","3":"Seattle, WA","4":"No Code"},{"1":"MFC","2":"Pearl Jam","3":"Seattle, WA","4":"Live On Two Legs"},{"1":"Lukin","2":"Pearl Jam","3":"Seattle, WA","4":"Seattle Washington November 5 2000"},{"1":"Stuck On Amber","2":"The Boo Radleys","3":"Liverpool, England","4":"Wake Up!"},{"1":"It's Lulu","2":"The Boo Radleys","3":"Liverpool, England","4":"Best Of"},{"1":"Sparrow","2":"The Boo Radleys","3":"Liverpool, England","4":"Everything's Alright Forever"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"Liverpool, England","4":"Kingsize"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"Liverpool, England","4":"Giant Steps"},{"1":"My One and Only Love","2":"Carly Simon","3":"New York, NY","4":"Moonlight Serenade"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"New York, NY","4":"No Secrets"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"New York, NY","4":"Clouds In My Coffee 1965-1995"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"New York, NY","4":"Into White"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


1. We really care about the songs in `time`. But, which of those songs do we know its corresponding album?


```r
time %>% 
  semi_join(album, by = c("song", "artist_name"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"Grievance","2":"Pearl Jam","3":"2000"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994"},{"1":"Present Tense","2":"Pearl Jam","3":"1996"},{"1":"MFC","2":"Pearl Jam","3":"1998"},{"1":"Lukin","2":"Pearl Jam","3":"1996"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
time %>% 
  inner_join(album, by = c("song", "artist_name"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]},{"label":["city"],"name":[4],"type":["chr"],"align":["left"]},{"label":["album"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"Grievance","2":"Pearl Jam","3":"2000","4":"Seattle, WA","5":"Binaural"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994","4":"Seattle, WA","5":"Vitalogy"},{"1":"Present Tense","2":"Pearl Jam","3":"1996","4":"Seattle, WA","5":"No Code"},{"1":"MFC","2":"Pearl Jam","3":"1998","4":"Seattle, WA","5":"Live On Two Legs"},{"1":"Lukin","2":"Pearl Jam","3":"1996","4":"Seattle, WA","5":"Seattle Washington November 5 2000"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995","4":"Liverpool, England","5":"Best Of"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992","4":"Liverpool, England","5":"Everything's Alright Forever"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998","4":"Liverpool, England","5":"Kingsize"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993","4":"Liverpool, England","5":"Giant Steps"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005","4":"New York, NY","5":"Moonlight Serenade"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972","4":"New York, NY","5":"No Secrets"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994","4":"New York, NY","5":"Clouds In My Coffee 1965-1995"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007","4":"New York, NY","5":"Into White"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

2. Go ahead and add the corresponding albums to the `time` tibble, being sure to preserve rows even if album info is not readily available.


```r
time %>% 
  left_join(album, by = c("song", "artist_name")) %>%
  select(-city)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]},{"label":["album"],"name":[4],"type":["chr"],"align":["left"]}],"data":[{"1":"Corduroy","2":"Pearl Jam","3":"1994","4":"NA"},{"1":"Grievance","2":"Pearl Jam","3":"2000","4":"Binaural"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994","4":"Vitalogy"},{"1":"Present Tense","2":"Pearl Jam","3":"1996","4":"No Code"},{"1":"MFC","2":"Pearl Jam","3":"1998","4":"Live On Two Legs"},{"1":"Lukin","2":"Pearl Jam","3":"1996","4":"Seattle Washington November 5 2000"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995","4":"Best Of"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992","4":"Everything's Alright Forever"},{"1":"Martin_ Doom! It's Seven O'Clock","2":"The Boo Radleys","3":"1995","4":"NA"},{"1":"Leaves And Sand","2":"The Boo Radleys","3":"1993","4":"NA"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998","4":"Kingsize"},{"1":"Comb Your Hair","2":"The Boo Radleys","3":"1998","4":"NA"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993","4":"Giant Steps"},{"1":"Mine Again","2":"Mariah Carey","3":"2005","4":"NA"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005","4":"NA"},{"1":"Babydoll","2":"Mariah Carey","3":"1997","4":"NA"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005","4":"NA"},{"1":"Vision Of Love","2":"Mariah Carey","3":"1990","4":"NA"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005","4":"Moonlight Serenade"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972","4":"No Secrets"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994","4":"Clouds In My Coffee 1965-1995"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007","4":"Into White"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

3. Which songs do we have "year", but not album info?


```r
time %>% 
  semi_join(album, by = "song")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"Grievance","2":"Pearl Jam","3":"2000"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994"},{"1":"Present Tense","2":"Pearl Jam","3":"1996"},{"1":"MFC","2":"Pearl Jam","3":"1998"},{"1":"Lukin","2":"Pearl Jam","3":"1996"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

4. Which artists are in `time`, but not in `album`?


```r
time %>% 
  anti_join(album, by = "artist_name")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"Mine Again","2":"Mariah Carey","3":"2005"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005"},{"1":"Babydoll","2":"Mariah Carey","3":"1997"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005"},{"1":"Vision Of Love","2":"Mariah Carey","3":"1990"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


5. You've come across these two tibbles, and just wish all the info was available in one tibble. What would you do?


```r
time %>% 
  full_join(album, by = c("song", "artist_name"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["song"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["year"],"name":[3],"type":["int"],"align":["right"]},{"label":["city"],"name":[4],"type":["chr"],"align":["left"]},{"label":["album"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"Corduroy","2":"Pearl Jam","3":"1994","4":"NA","5":"NA"},{"1":"Grievance","2":"Pearl Jam","3":"2000","4":"Seattle, WA","5":"Binaural"},{"1":"Stupidmop","2":"Pearl Jam","3":"1994","4":"Seattle, WA","5":"Vitalogy"},{"1":"Present Tense","2":"Pearl Jam","3":"1996","4":"Seattle, WA","5":"No Code"},{"1":"MFC","2":"Pearl Jam","3":"1998","4":"Seattle, WA","5":"Live On Two Legs"},{"1":"Lukin","2":"Pearl Jam","3":"1996","4":"Seattle, WA","5":"Seattle Washington November 5 2000"},{"1":"It's Lulu","2":"The Boo Radleys","3":"1995","4":"Liverpool, England","5":"Best Of"},{"1":"Sparrow","2":"The Boo Radleys","3":"1992","4":"Liverpool, England","5":"Everything's Alright Forever"},{"1":"Martin_ Doom! It's Seven O'Clock","2":"The Boo Radleys","3":"1995","4":"NA","5":"NA"},{"1":"Leaves And Sand","2":"The Boo Radleys","3":"1993","4":"NA","5":"NA"},{"1":"High as Monkeys","2":"The Boo Radleys","3":"1998","4":"Liverpool, England","5":"Kingsize"},{"1":"Comb Your Hair","2":"The Boo Radleys","3":"1998","4":"NA","5":"NA"},{"1":"Butterfly McQueen","2":"The Boo Radleys","3":"1993","4":"Liverpool, England","5":"Giant Steps"},{"1":"Mine Again","2":"Mariah Carey","3":"2005","4":"NA","5":"NA"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005","4":"NA","5":"NA"},{"1":"Babydoll","2":"Mariah Carey","3":"1997","4":"NA","5":"NA"},{"1":"Don't Forget About Us","2":"Mariah Carey","3":"2005","4":"NA","5":"NA"},{"1":"Vision Of Love","2":"Mariah Carey","3":"1990","4":"NA","5":"NA"},{"1":"My One and Only Love","2":"Carly Simon","3":"2005","4":"New York, NY","5":"Moonlight Serenade"},{"1":"It Was So Easy  (LP Version)","2":"Carly Simon","3":"1972","4":"New York, NY","5":"No Secrets"},{"1":"I've Got A Crush On You","2":"Carly Simon","3":"1994","4":"New York, NY","5":"Clouds In My Coffee 1965-1995"},{"1":"Manha De Carnaval (Theme from \"Black Orpheus\")","2":"Carly Simon","3":"2007","4":"New York, NY","5":"Into White"},{"1":"Stuck On Amber","2":"The Boo Radleys","3":"NA","4":"Liverpool, England","5":"Wake Up!"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## Exercise 2: LOTR

Load in the three Lord of the Rings tibbles that we saw last time:


```r
fell <- read_csv("https://raw.githubusercontent.com/jennybc/lotr-tidy/master/data/The_Fellowship_Of_The_Ring.csv")
```

```
## Parsed with column specification:
## cols(
##   Film = col_character(),
##   Race = col_character(),
##   Female = col_double(),
##   Male = col_double()
## )
```

```r
ttow <- read_csv("https://raw.githubusercontent.com/jennybc/lotr-tidy/master/data/The_Two_Towers.csv")
```

```
## Parsed with column specification:
## cols(
##   Film = col_character(),
##   Race = col_character(),
##   Female = col_double(),
##   Male = col_double()
## )
```

```r
retk <- read_csv("https://raw.githubusercontent.com/jennybc/lotr-tidy/master/data/The_Return_Of_The_King.csv")
```

```
## Parsed with column specification:
## cols(
##   Film = col_character(),
##   Race = col_character(),
##   Female = col_double(),
##   Male = col_double()
## )
```

1. Combine these into a single tibble.


```r
bind_rows(fell, ttow, retk)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Film"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Race"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Female"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Male"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"The Fellowship Of The Ring","2":"Elf","3":"1229","4":"971"},{"1":"The Fellowship Of The Ring","2":"Hobbit","3":"14","4":"3644"},{"1":"The Fellowship Of The Ring","2":"Man","3":"0","4":"1995"},{"1":"The Two Towers","2":"Elf","3":"331","4":"513"},{"1":"The Two Towers","2":"Hobbit","3":"0","4":"2463"},{"1":"The Two Towers","2":"Man","3":"401","4":"3589"},{"1":"The Return Of The King","2":"Elf","3":"183","4":"510"},{"1":"The Return Of The King","2":"Hobbit","3":"2","4":"2673"},{"1":"The Return Of The King","2":"Man","3":"268","4":"2459"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

2. Which races are present in "The Fellowship of the Ring" (`fell`), but not in any of the other ones?


```r
fell %>% 
  anti_join(ttow, by = "Race") %>% 
  anti_join(retk, by = "Race")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Film"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Race"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Female"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Male"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>



## Exercise 3: Set Operations

Let's use three set functions: `intersect`, `union` and `setdiff`. We'll work with two toy tibbles named `y` and `z`, similar to Data Wrangling Cheatsheet


```r
(y <-  tibble(x1 = LETTERS[1:3], x2 = 1:3))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"A","2":"1"},{"1":"B","2":"2"},{"1":"C","2":"3"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


```r
(z <- tibble(x1 = c("B", "C", "D"), x2 = 2:4))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"B","2":"2"},{"1":"C","2":"3"},{"1":"D","2":"4"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

1. Rows that appear in both `y` and `z`


```r
intersect(y, z)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"B","2":"2"},{"1":"C","2":"3"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
inner_join(y, z)
```

```
## Joining, by = c("x1", "x2")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"B","2":"2"},{"1":"C","2":"3"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

2. You collected the data in `y` on Day 1, and `z` in Day 2. Make a data set to reflect that.


```r
bind_rows(
  mutate(y, day = "Day 1"),
  mutate(z, day = "Day 2")
)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]},{"label":["day"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"A","2":"1","3":"Day 1"},{"1":"B","2":"2","3":"Day 1"},{"1":"C","2":"3","3":"Day 1"},{"1":"B","2":"2","3":"Day 2"},{"1":"C","2":"3","3":"Day 2"},{"1":"D","2":"4","3":"Day 2"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

3. The rows contained in `z` are bad! Remove those rows from `y`.


```r
setdiff(y, z)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"A","2":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
anti_join(y, z)
```

```
## Joining, by = c("x1", "x2")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["x2"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"A","2":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
