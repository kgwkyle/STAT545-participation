library("tidyverse")
library("gapminder")

gapminder
write_csv(gapminder, './gapminder.csv')
view(gapminder)

#calculate mean life Exp per continent
gapminder_sum <- gapminder %>%
  group_by(continent) %>%
  summarize(ave_lifeExp = mean(lifeExp))

View(gapminder_sum)