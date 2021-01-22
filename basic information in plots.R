library("tidyverse")
library("lubridate")
library("ggplot2")
library("skimr")
library("descr")
library("scales")
library("viridis")
library("ggthemr")
source("uploading and data clearing.R") #uruchomienie calego pliku data clearing
glimpse(play)
ggthemr("fresh")


# Paid vs Free - share in dataset -----------------------------------------
play %>% 
  filter(Type %in% c("Paid", "Free")) %>% 
  ggplot(aes("", fill = Type))+
  geom_bar(position = "fill")+
  coord_polar(theta = "y")+
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.15))+
  labs(title = "Share of both type of applications in the set",
       x = "Applications", y = "Share in percent")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks  = element_blank())

#data labels for above pie plot
play %>% 
  filter(Type %in% c("Paid", "Free")) %>%
  count(Type) %>% 
  mutate(share = n / sum(n) * 100)

#on time range 
play %>% 
  filter(Type %in% c("Paid", "Free")) %>% 
  mutate(year = year(`Last Updated`)) %>% 
  group_by(year) %>% 
  count(Type) %>% 
  ggplot(aes(year, n, col = Type))+
  geom_smooth(se = FALSE)+
  scale_y_log10()+
  labs(y = "Real amount of apps aggregated by year (logarythmic scale)")

#proportionately
play %>% 
  filter(Type %in% c("Paid", "Free")) %>% 
  mutate(year = year(`Last Updated`)) %>% 
  group_by(year) %>% 
  count(Type) %>% 
  mutate(prop = n / sum(n) * 100) %>% 
  ggplot(aes(year, prop, col = Type))+
  geom_smooth(se = FALSE)+
  labs(y = "Apps proportion")+
  geom_hline(yintercept = 50, col = "red", size = 0.7)+
  annotate(geom = "label", x = 2013, y = 55, label = "Reference")
  
  
# relationship between week day and release date of update ----------------
play %>% 
  filter(!is.na(`Last Updated`)) %>% 
  mutate(weekday = weekdays(`Last Updated`),
         weekday = as.factor(weekday)) %>% 
  ggplot(aes(fct_infreq(weekday))) +
  geom_bar()+
  geom_hline(yintercept = 1981, col = "red")+
  geom_hline(yintercept = 656, col = "red")+
  annotate(geom = "label", x = "piątek", y = 2010,
           label = "Maximum - Thursday 1981 releases")+
  annotate(geom = "label", x = "wtorek", y = 700,
           label = "Minimum - Sunday 656 releases")+
  labs(title = "The least amount of updates were released during the weekend",
       x = "Weekdays", y = "Absolute amount of updates")
#counting
play %>% 
  filter(!is.na(`Last Updated`)) %>% 
  mutate(weekday = weekdays(`Last Updated`)) %>%
  count(weekday)


# probability weekday occurrs -------------------------------------------------------------
col_week <- c("#e1d6b7","#afb5da","#b4cfab","#dcc9e2","#add9cd","#e3b1ac","#98d4e4")
play %>% 
  mutate(weekday = weekdays(`Last Updated`),
         weekday = as.factor(weekday)) %>% 
  filter(!is.na(weekday)) %>% 
  ggplot(aes("", fill = fct_infreq(weekday)))+
  geom_bar(position = "fill")+
  scale_fill_manual(values = col_week)+
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.1))+
  theme(axis.title = element_blank(),
        axis.ticks.x = element_blank())+
  labs(fill = "Weekday")

#data labels 
play %>% 
  mutate(weekday = weekdays(`Last Updated`)) %>% 
  filter(!is.na(weekday)) %>% 
  count(weekday, sort = TRUE) %>% 
  mutate(prop = n / sum(n) *100) 

#probability - Thursday vs Sunday
play %>% 
  mutate(weekday = weekdays(`Last Updated`)) %>% 
  filter(weekday %in% c("czwartek", "niedziela")) %>% 
  count(weekday, sort = TRUE) %>% 
  mutate(prop = n / sum(n) *100) %>% 
  ggplot(aes("Weekday", prop, fill = weekday))+
  geom_col()+
  annotate(geom = "label", x = "Weekday", y = 10, label = "24.9%")+
  annotate(geom = "label", x = "Weekday", y = 75, label = "75.1%")+
  theme(axis.title.x = element_blank(),
        axis.ticks.x = element_blank())
           

 
