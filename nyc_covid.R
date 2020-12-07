
library(tidyverse)
library(data.table)
library(lubridate)


nyc_by_day <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/data-by-day.csv")

nyc_by_day$date <- as.Date(nyc_by_day$date_of_interest, format = "%m/%d/%Y")

nyc_by_day$hospitalization_date <- nyc_by_day$date + 7
nyc_by_day$hospitalization_est35 <- round(nyc_by_day$CASE_COUNT_7DAY_AVG * .035, digits = 0)
nyc_by_day$hospitalization_est7 <- round(nyc_by_day$CASE_COUNT_7DAY_AVG * .08, digits = 0)
nyc_by_day <- full_join(nyc_by_day %>% select(-c("hospitalization_est35", "hospitalization_est7")), 
          nyc_by_day %>% select(c("hospitalization_date", "hospitalization_est35", "hospitalization_est7")),
          by = c("date" = "hospitalization_date")) %>% select(-c("hospitalization_date"))

nyc_by_day$death_date <- nyc_by_day$date + 28
nyc_by_day$death_est <- round(nyc_by_day$CASE_COUNT_7DAY_AVG * .017)
nyc_by_day <- full_join(nyc_by_day %>% select(-c("death_est")), 
                        nyc_by_day %>% select(c("death_date", "death_est")),
                        by = c("date" = "death_date")) %>% select(-c("death_date"))

nyc_by_day$month <- month(nyc_by_day$date)

nyc_by_day %>% filter(month >= 6) %>%
  ggplot(aes(x = date)) +
  geom_density(aes(y = DEATH_COUNT_7DAY_AVG), stat = "identity", 
               fill="#69b3a2", alpha=.6, color = "#69b3a2") + 
  geom_line(aes(y = death_est), 
            stat = "identity", size=.75, color = "black", linetype="dashed") + 
  theme_bw() +
  labs(title = "NYC: COVID Deaths", 
       subtitle = "Deaths Compared to 1.7% of Cases Diagnosed 28 Days Prior. June 2020 to Present") + 
  ylab("Deaths (7 Day Average) ") + 
  xlab("Date") +
  ggsave("nyc_mortality_prediction.png", path = "output")

nyc_by_day %>% 
  ggplot(aes(x = date)) +
  geom_density(aes(y = DEATH_COUNT_7DAY_AVG), stat = "identity", 
               fill="#69b3a2", alpha=.6, color = "#69b3a2") + 
  geom_line(aes(y = death_est), 
            stat = "identity", size=.75, color = "black", linetype="dashed") + 
  theme_bw() +
  labs(title = "NYC: COVID Deaths", 
       subtitle = "Deaths Compared to 1.7% of Cases Diagnosed 28 Days Prior. March 2020 to Present") + 
  ylab("Deaths (7 Day Average)") + 
  xlab("Date") +
  ggsave("nyc_mortality_prediction_all.png", path = "output")

nyc_by_day %>% filter(month >= 6) %>%
  ggplot(aes(x = date)) +
  geom_density(aes(y = HOSP_COUNT_7DAY_AVG), stat = "identity", 
               fill="#f68060", alpha=.6, color = "#f68060") + 
  geom_line(aes(y = hospitalization_est35), 
            stat = "identity", size=.75, color = "black", linetype="dashed") + 
  geom_line(aes(y = hospitalization_est7), 
            stat = "identity", size=.75, color = "black", linetype="dashed") +
  theme_bw() +
  labs(title = "NYC: COVID Hospitalizations", 
       subtitle = "Hospitalizations Compared to 3.5% & 8% of Cases Diagnosed 7 Days Prior. June 2020 to Present") + 
  ylab("Hospitalizations (7 Day Average)") + 
  xlab("Date") +
  ggsave("nyc_hospitalization_prediction.png", path = "output")
  




