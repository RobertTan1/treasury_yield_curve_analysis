# Log version, double axis -------------------------------------------------------------
treasury_temp <-
  treasury_maturity %>%
  mutate(month_year = floor_date(date, "month")) %>% 
  inner_join(sp500, by = "date") %>%
  left_join(overnight_rate, by=c('month_year')) %>% 
  mutate(
    # year_5_minus_3_year = five_year - three_year,
    year_5_minus_1_year = five_year - one_year,
    # year_10_minus_3_mo = ten_year - three_month,
    # year_10_minus_2_year = ten_year - two_year,
    sp500_close = close
  ) %>%
  dplyr::select(date,
                # year_5_minus_3_year,
                year_5_minus_1_year,
                # year_10_minus_3_mo,
                overnight_rate,
                # year_10_minus_2_year,
                sp500_close)

g <- treasury_temp %>%
  filter(date > '1962-01-01') %>% 
  ggplot(aes(x = date)) +
  # geom_line(aes(y = year_5_minus_3_year), col = 'purple') +
  geom_line(aes(y = year_5_minus_1_year), col = 'purple') +
  # geom_line(aes(y = year_10_minus_3_mo), col = 'darkgreen') +
  # geom_line(aes(y = year_10_minus_2_year), col = 'darkblue') +
  geom_line(aes(y = sp500_close /500 ), col = 'darkred') +
  geom_line(aes(y=overnight_rate), col='black') +
  theme_minimal() +
  scale_y_continuous("Yield spread (5yr-3yr)",sec.axis = sec_axis( ~ . * 500, breaks = seq(0, 3500, 500), name = "SP500"))
  # ylab("Yield spread (5yr-3yr)")

g

plotly::ggplotly(g)
