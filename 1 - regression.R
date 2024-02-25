# Take linear regression of each day's rates since first nonmissing date -----
# Chart coefficient over time

truncated_treasury <-
  treasury_maturity %>% filter(!is.na(three_month))

truncated_treasury %<>% 
  gather(term, yield, -date) %>% 
  mutate(term = as.integer(factor(term, ordered = T, levels = c(
    # "one_month", 
    "three_month", "six_month", 
    "one_year", "two_year", "three_year", "five_year", "seven_year", 
    "ten_year", "twenty_year", "thirty_year"
  ))))

results = data.frame(date = unique(truncated_treasury$date), coef = NA)

dates = unique(truncated_treasury$date)

for (i in 1:length(dates)) {
  model <-
    lm(yield ~ term, data = truncated_treasury[truncated_treasury$date == dates[i], ])
  results$coef[i]  = model$coefficients[[2]]
}

t <- results %>% 
  inner_join(sp500, by = "date") %>% 
  # inner_join(overnight_rate, by='date') %>% 
  mutate(close = log(close)-6) %>% 
  gather(type, value, -date) %>% 
  mutate(type = recode(type, 'coef' = 'yield_curve_slope', 'close' = 'norm_sp500'),
         value = round(value, 3)) %>% 
  ggplot(aes(x = date, y = value, col = type)) +
  geom_line() +
  theme_minimal() +
  scale_color_discrete(name = 'Legend') +
  labs(
    title = "SP500 vs. Yield curve slope",
    subtitle = "1990 to Sep 10, 2019",
    y = 'Yield curve slope',
    x = ''
  )
# t
plotly::ggplotly(t)
