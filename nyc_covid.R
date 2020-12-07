
library(tidyverse)
library(data.table)
library(lubridate)


nyc_by_day <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/data-by-day.csv")

nyc_by_day$date <- as.Date(nyc_by_day$date_of_interest, format = "%m/%d/%Y")

nyc_by_day$hospitalization_date <- nyc_by_day$date + 7
nyc_by_day$hospitalization_est <- round(nyc_by_day$CASE_COUNT_7DAY_AVG * .035, digits = 0)
nyc_by_day <- full_join(nyc_by_day %>% select(-c("hospitalization_est")), 
          nyc_by_day %>% select(c("hospitalization_date", "hospitalization_est")),
          by = c("date" = "hospitalization_date")) %>% select(-c("hospitalization_date"))

nyc_by_day$death_date <- nyc_by_day$date + 28
nyc_by_day$death_est <- round(nyc_by_day$CASE_COUNT_7DAY_AVG * .018)
nyc_by_day <- full_join(nyc_by_day %>% select(-c("death_est")), 
                        nyc_by_day %>% select(c("death_date", "death_est")),
                        by = c("date" = "death_date")) %>% select(-c("death_date"))

nyc_by_day$month <- month(nyc_by_day$date)



nyc_by_day %>% filter(month >= 6) %>%
  ggplot(aes(x = date)) +
  geom_bar(aes(y = HOSP_COUNT_7DAY_AVG), stat = "identity", fill="#f68060", alpha=.6) + 
  geom_line(aes(y = hospitalization_est), stat = "identity", size=1, color = "black", linetype=2) + 
  theme_bw() +
  theme(axis.text.y = element_blank())
  

nyc_by_day %>% filter(month >= 6) %>%
  ggplot(aes(x = date)) +
  geom_density(aes(y = DEATH_COUNT_7DAY_AVG), stat = "identity", 
               fill="#69b3a2", alpha=.6, color = "#69b3a2") + 
  geom_line(aes(y = death_est), 
            stat = "identity", size=.75, color = "black", linetype="dashed") + 
  theme_bw() +
  labs(title = "NYC: COVID Deaths", 
       subtitle = "Deaths Compared to 1.8% of Cases Diagnosed 28 Days Prior") + 
  ylab("Deaths (7 Day Average)") + 
  xlab("Date")


