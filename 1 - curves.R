# Yield curve
historical_curves <- treasury_maturity %>% filter(
  (date == as.Date('2008-08-01')) |
  (date == as.Date('2008-10-15')) |
  (date == as.Date('2002-03-14')) |
  (date == as.Date('1992-04-24')) |
  (date == max(treasury_maturity$date) - 364*5) |
  (date == max(treasury_maturity$date) - 365) |
  (date == max(treasury_maturity$date) - 180) |
  (date == max(treasury_maturity$date) - 90) |
  (date == max(treasury_maturity$date) - 60) |
  (date == max(treasury_maturity$date) - 30) |
  # (year(date) > 2006 & year(date) < 2020 & month(date) == 1 & day(date) == 5)
  
  date == max(treasury_maturity$date) 

  # date == as.Date('2006-11-30') |
  #   date == max(treasury_maturity$date) |
  #   date == as.Date('2000-11-24') | 
  #   date == as.Date('1980-03-26')
)

historical_curves <- treasury_maturity %>% filter(
  (date == as.Date('2008-08-01')) |
    (date == as.Date('2008-10-15')) |
    (date == as.Date('2002-03-14')) |
    (date == as.Date('1992-04-24'))
)


historical_curves %>%
  gather(maturity, yield,-date) %>%
  mutate(maturity = factor(maturity, ordered = T, levels = c(
    "one_month", "two_month", "three_month", "six_month", 
    "one_year", "two_year", "three_year", "five_year", "seven_year", 
    "ten_year", "twenty_year", "thirty_year"
  ))) %>% 
  ggplot(aes(x = maturity, y = yield, col=as.factor(date), group=date)) +
  geom_line(size=2) +
  theme_minimal()

# yield curve over time visualization
library(gapminder)
p <- ggplot(gapminder, aes(gdpPercap, lifeExp, color = continent)) +
  geom_point(aes(size = pop, frame = year, ids = country)) +
  scale_x_log10()

plotly::ggplotly(p)

p <- historical_curves %>%
  gather(maturity, yield,-date) %>%
  mutate(maturity = factor(maturity, ordered = T, levels = c(
    "one_month", "two_month", "three_month", "six_month", 
    "one_year", "two_year", "three_year", "five_year", "seven_year", 
    "ten_year", "twenty_year", "thirty_year"
  ))) %>%
  plotly::plot_ly(
    x = ~maturity, 
    y = ~yield, 
    frame = ~date, 
    type = 'scatter'
  )

p

p <- treasury_maturity %>%
  gather(maturity, yield,-date) %>%
  mutate(maturity = factor(maturity, ordered = T, levels = c(
    "one_month", "two_month", "three_month", "six_month", 
    "one_year", "two_year", "three_year", "five_year", "seven_year", 
    "ten_year", "twenty_year", "thirty_year"
  )),
  date = as.integer(str_remove_all(as.character(date),"-"))) %>% 
  ggplot(aes(maturity, yield, group = date)) +
  geom_line(aes(frame = date, ids = yield)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=35))

plotly::ggplotly(p)