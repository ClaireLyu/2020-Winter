library(tidyverse)
library(lubridate)
library(sf)
confirmed <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
recovered <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv")
death <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv")

confirmed_long <- confirmed %>%
  pivot_longer(-(`Province/State`:Long), 
               names_to = "Date", 
               values_to = "confirmed") %>%
  mutate(Date = (mdy(Date))) # convert string to date-time

recovered_long <- recovered %>%
  pivot_longer(-(`Province/State`:Long), 
               names_to = "Date", 
               values_to = "recovered") %>%
  mutate(Date = mdy(Date))

death_long <- death %>%
  pivot_longer(-(`Province/State`:Long), 
               names_to = "Date", 
               values_to = "death") %>%
  mutate(Date = mdy(Date))

ncov_tbl <- confirmed_long %>%
  left_join(recovered_long) %>%
  left_join(death_long) %>%
  pivot_longer(confirmed:death, 
               names_to = "Case", 
               values_to = "Count")
chn_map <- st_read("./bou2_4p.shp", as_tibble = TRUE) %>%
  mutate(NAME = iconv(NAME, from = "GBK"),
         BOU2_4M_ = as.integer(BOU2_4M_),
         BOU2_4M_ID = as.integer(BOU2_4M_ID)) %>%
  mutate(NAME = str_replace_na(NAME, replacement = "澳门特别行政区")) 

#Draw the China map
chn_map %>%
  ggplot() + 
  geom_sf(mapping = aes(geometry = geometry), color = "black", fill = "white") + 
  #geom_sf_label(mapping = aes(label = NAME)) + 
  theme_bw()

#
ncov_tbl %>%
  filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
  distinct(`Province/State`, `Country/Region`) 

translate <- function(x) {
  sapply(x, function(chn_name) {
    if (str_detect(chn_name, "澳门")) {
      eng_name <- "Macau"
    } else if (str_detect(chn_name, "台湾")) {
      eng_name <- "Taiwan"
    } else if (str_detect(chn_name, "上海")) {
      eng_name <- "Shanghai"
    } else if (str_detect(chn_name, "云南")) {
      eng_name <- "Yunnan"
    } else if (str_detect(chn_name, "内蒙古")) {
      eng_name <- "Inner Mongolia"
    } else if (str_detect(chn_name, "北京")) {
      eng_name <- "Beijing"
    } else if (str_detect(chn_name, "台湾")) {
      eng_name <- "Taiwan"
    } else if (str_detect(chn_name, "吉林")) {
      eng_name <- "Jilin"
    } else if (str_detect(chn_name, "四川")) {
      eng_name <- "Sichuan"
    } else if (str_detect(chn_name, "天津")) {
      eng_name <- "Tianjin"
    } else if (str_detect(chn_name, "宁夏")) {
      eng_name <- "Ningxia"
    } else if (str_detect(chn_name, "安徽")) {
      eng_name <- "Anhui"
    } else if (str_detect(chn_name, "山东")) {
      eng_name <- "Shandong"
    } else if (str_detect(chn_name, "山西")) {
      eng_name <- "Shanxi"
    } else if (str_detect(chn_name, "广东")) {
      eng_name <- "Guangdong"
    } else if (str_detect(chn_name, "广西")) {
      eng_name <- "Guangxi"
    } else if (str_detect(chn_name, "新疆")) {
      eng_name <- "Xinjiang"
    } else if (str_detect(chn_name, "江苏")) {
      eng_name <- "Jiangsu"
    } else if (str_detect(chn_name, "江西")) {
      eng_name <- "Jiangxi"
    } else if (str_detect(chn_name, "河北")) {
      eng_name <- "Hebei"
    } else if (str_detect(chn_name, "河南")) {
      eng_name <- "Henan"
    } else if (str_detect(chn_name, "浙江")) {
      eng_name <- "Zhejiang"
    } else if (str_detect(chn_name, "海南")) {
      eng_name <- "Hainan"
    } else if (str_detect(chn_name, "湖北")) {
      eng_name <- "Hubei"
    } else if (str_detect(chn_name, "湖南")) {
      eng_name <- "Hunan"
    } else if (str_detect(chn_name, "甘肃")) {
      eng_name <- "Gansu"
    } else if (str_detect(chn_name, "福建")) {
      eng_name <- "Fujian"
    } else if (str_detect(chn_name, "西藏")) {
      eng_name <- "Tibet"
    } else if (str_detect(chn_name, "贵州")) {
      eng_name <- "Guizhou"
    } else if (str_detect(chn_name, "辽宁")) {
      eng_name <- "Liaoning"
    } else if (str_detect(chn_name, "重庆")) {
      eng_name <- "Chongqing"
    } else if (str_detect(chn_name, "陕西")) {
      eng_name <- "Shanxi"
    } else if (str_detect(chn_name, "青海")) {
      eng_name <- "Qinghai"
    } else if (str_detect(chn_name, "香港")) {
      eng_name <- "Hong Kong"
    } else if (str_detect(chn_name, "黑龙江")) {
      eng_name <- "Heilongjiang"
    } else {
      eng_name <- chn_name # don't translate if no correspondence
    }
    return(eng_name)
  })
}

chn_prov <- chn_map %>% 
  count(NAME) %>%
  mutate(NAME_ENG = translate(NAME))

library(wesanderson)

plotdate <- "2020-02-14"
case <- "confirmed"

ncov_tbl %>%
  filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
  filter(Date == plotdate, Case == case) %>%
  group_by(`Province/State`) %>%  
  top_n(1, Date) %>% # take the latest count on that date
  right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
  ggplot() +
  geom_sf(mapping = aes(fill = Count, geometry = geometry)) +
  # scale_fill_gradient(low = "white",
  #                     high = "red",
  #                     trans = "log10",
  #                     limits = c(1, 50000),
  #                     breaks = c(1, 10, 100, 1000, 10000),
  #                     name = "") +
  scale_fill_gradientn(colors = wes_palette("Zissou1", 100, type = "continuous"),
                       trans = "log10") + # can we find a better palette?
  # #scale_fill_brewer(palette = "Dark2") + 
  theme_bw() +
  labs(title = str_c(case, " cases"), subtitle = plotdate)


