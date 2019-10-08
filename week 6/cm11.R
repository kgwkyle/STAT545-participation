library("tidyverse")
library("gapminder")
library("here")
library("readxl")

gapminder
write_csv(gapminder, './gapminder.csv')
view(gapminder)

#calculate mean life Exp per continent
gapminder_sum <- gapminder %>%
  group_by(continent) %>%
  summarize(ave_lifeExp = mean(lifeExp))

View(gapminder_sum)
write_csv(gapminder_sum, './gapminder_sum.csv')
write_csv(gapminder_sum, here::here("gapminder_sum.csv"))

gapminder_sum %>%
  ggplot(aes(x = continent,
             y = ave_lifeExp)) +
  geom_point() +
  theme_bw()

#New dataset - GreatestGivers

data_url <- "http://gattonweb.uky.edu/sheather/book/docs/datasets/GreatestGivers.xls"
  
download.file(url = data_url,
              destfile = here::here("week 6", basename(data_url)))

# MISSING STEPS HERE ??
# XLS file possibly does not work on all PC's; file corrupted on Windows; following two lines won't work

philanthropists <- read_excel(here::here("week 6", "GreatestGivers.xls"), trim_ws = TRUE)

view(philantthropists)

# TODO for Firas: Find a way to remove leading white-space from Column 4

# New dataset - Firas-MRI

mri_file = here("week 6", "Firas-MRI.xlsx")

mri <- read_excel(mri_file, range = "A1:L12")
view(mri)

mri <- mri[,-10]

mri <- mri %>%
  pivot_longer(cols = "Slice 1":"Slice 8",
               names_to = "slice_no",
               values_to = "value")

view(mri)