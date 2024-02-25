# load historical yields --------------------------------------------------
rm_temp <-
  read_tsv("yield curve long historicals/2020_data/yield_maturities_Daily.txt")

rm_temp[, 2:ncol(rm_temp)] <-
  sapply(rm_temp[, 2:ncol(rm_temp)], as.numeric)

names(rm_temp) <-
  c("date",
    "one_year",
    "ten_year",
    "one_month",
    "two_year",
    "twenty_year",
    "three_year",
    "thirty_year",
    "three_month",
    "five_year",
    "six_month",
    "seven_year"
  )

rm_temp %<>%
  select(
    "date",
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
    "thirty_year"
  )


# 2020
tbls_ls <-
  readRDS('2020_yields.rds')

tbls_ls %<>% as_tibble()

# -- do this every year. save the data, then import new year
tbls_ls %<>% bind_rows(readRDS('2021_yields.rds') %>% as_tibble())
tbls_ls %<>% bind_rows(readRDS('2022_yields.rds') %>% as_tibble())

tbls_ls$Date %<>% mdy()

tbls_ls %<>% select(-`52 WEEKS BANK DISCOUNT`, -`COUPON EQUIVALENT`, -`4 Mo`)

names(tbls_ls) <-
  c("date",
    "one_month",
    "two_month",
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

tbls_ls[2:ncol(tbls_ls)] <-
  sapply(tbls_ls[2:ncol(tbls_ls)], as.numeric)

# Remove because it disappeared from feds data sources
tbls_ls %<>% select(-two_month)

saveRDS(rm_temp %>% bind_rows(tbls_ls), 'treasury_history_til_2022.RDS')
