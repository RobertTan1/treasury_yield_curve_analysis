library(quantmod)
library(tidyverse)
library(magrittr)
library(rvest)
library(lubridate)

# From http://bradleyboehmke.github.io/2015/12/scraping-html-tables.html

# Get newer SP500 data ----------------------------------------------------------

# Import sp500 data from getSymbols
# This is made to increase efficiency so we don't have to redownload everything every time
sp_500_til_dec_31_2022 <- read_rds("sp500_data_1962_2022_full.rds")

sp500  <- new.env()

getSymbols(
  "^GSPC",
  env = sp500,
  src = "yahoo",
  from = as.Date("2023-01-01"),
  to = as.Date(Sys.Date() + 1)
)

sp500 <- sp500$GSPC

sp500 %<>% fortify.zoo %>% as_tibble %>% select(Index, GSPC.Close) %>% 
  rename("date" = "Index", "close" = "GSPC.Close")

sp500 <- sp_500_til_dec_31_2022 %>% bind_rows(sp500)


# load historical yields --------------------------------------------------

treasury_maturity <- read_rds('treasury_history_til_2022.RDS')

# Get overnight interest rates

overnight_rate <-
  read_csv(
    paste0('https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1319&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=FEDFUNDS&scale=left&cosd=1954-07-01&coed=',Sys.Date(),'&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=', Sys.Date(), '&revision_date=', Sys.Date(), '&nd=1954-07-01')
  )

names(overnight_rate) <- c('month_year', 'overnight_rate')

# Get treasury maturity data ----------------------------------------------
yields_ytd <- html_nodes(
  read_html(
    "https://home.treasury.gov/resource-center/data-chart-center/interest-rates/TextView?type=daily_treasury_yield_curve&field_tdr_date_value=2023"
  ),
  "table"
) %>%
  # html_nodes("table") %>%
  .[[1]] %>%
  html_table(fill = TRUE) %>%
  select(1, 11:23) %>%
  select(-`2 Mo`, -`4 Mo`)

names(yields_ytd) <-
  c("date",
    "one_month",
    "three_month",
    "six_month",
    "one_year",
    "two_year",
    "three_year",
    "five_year",
    "seven_year",
    "ten_year",
    "twenty_year",
    "thirty_year")

yields_ytd$date %<>% mdy()

treasury_maturity %<>%
  bind_rows(yields_ytd)
