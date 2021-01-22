library("tidyverse")
library("lubridate")
library("ggplot2")
library("skimr")
library("descr")
library("scales")
library("viridis")
library("ggthemr")
library("mosaic")


# data uploading from csv files -------------------------------------------
play <- read_csv("data/googleplaystore.csv")

glimpse(play)
skim(play)

#data clearing - removal of dollar sign from column Price is needed and later converting
#into double, using data type for column 'Last Updated'
count(play, Price) %>%  #counting to control
  mutate(count = sum(n)) 

play <- play %>% 
  mutate(Price = as.numeric(str_remove(Price, "[$]"))) %>%  #also str_replace_all()
  replace_na(list(Price = 0)) %>% #Everynone -> NA -> 0
  mutate(`Last Updated` = mdy(`Last Updated`))

#data clearing - size
count(play, actual_size) %>% 
  mutate(count = sum(n)) %>% 
  print(n = Inf)

play <- play %>% 
  mutate(kb = ifelse(str_detect(Size, "k"), Size, 0),
         Mb = ifelse(str_detect(Size, "M"), Size, 0)) %>% 
  mutate(kb = as.numeric(str_remove(kb, "k")),
         Mb = as.numeric(str_remove(Mb, "M"))) %>% 
  mutate(kb = kb / 1024,
         actual_size = kb + Mb) #Varies with device -> 0
  
#data clearing - content rating, data labels changing and renaming variable
count(play, Group) %>% 
  mutate(count = sum(n))

play <- play %>% 
  rename("Group" = `Content Rating`) %>% 
  mutate(Group = fct_collapse(Group,
                              Adults = c("Adults only 18+", "Mature 17+"),
                              Teen = c("Teen", "Everyone 10+"),
                              Everyone = c("Everyone","Unrated")))
  
#data clearing - Istalls variable - plus sing and , character removal
count(play, Installs) %>% 
  mutate(count = sum(n)) %>% 
  print(n = Inf)

play <- play %>% 
  mutate(Installs = str_remove(Installs, "[+]"),
         Installs = as.numeric(str_remove(Installs, "[/,]")))

#organizing the columns
play <- play %>% 
  select(App, Category, Rating, Reviews, Installs, Type, Price,
         Group, `Last Updated`, actual_size) %>% 
  mutate(Category = as.factor(Category),
         Type = as.factor(Type),
         Group = as.factor(Group))
