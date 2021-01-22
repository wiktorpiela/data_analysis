#rating
source("uploading and data clearing.R") #uruchomienie calego pliku data clearing
glimpse(play)

play %>% 
  filter(Rating < 19, Reviews > 200) %>% 
  skim(Rating)

# whether paid applications are rated better than free ones ---------------
play %>% 
  filter(Rating < 19, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  ggplot(aes(Rating, fill = Type))+
  geom_density(alpha = 0.7)

play %>% 
  filter(Rating < 19, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  ggplot(aes(Type, Rating))+
  geom_boxplot(coef = 5)

#data labels
play %>% 
  filter(Rating < 19, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  group_by(Type) %>% 
  summarise(median_rating = median(Rating),
            count = n()) %>% 
  mutate(prop = count / sum(count) * 100)
            

#checking by time range
play %>% 
  filter(Rating < 19, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  ggplot(aes(`Last Updated`, Rating, col = Type))+
  geom_smooth(se = FALSE)+
  labs(x = "Time", title = "Paid apps higher rated all the time")+
  theme(axis.ticks.x = element_blank())

#Paid vs Free differences in rating by year - data frame (table) - less precisely
play %>%  
  filter(Rating < 4.5, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  mutate(year = year(`Last Updated`)) %>% 
  group_by(year, Type) %>% 
  summarise(median_rating = median(Rating)) %>% 
  filter(year > 2011) %>% 
  pivot_wider(names_from = Type, values_from = median_rating) %>% 
  mutate(difference = Paid - Free,
         test = ifelse(difference > 0, "Paid better", 
                       ifelse(difference == 0, "The same", "Free better")))
  
#popularity and rating
play %>% 
  filter(Rating < 4.5, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  ggplot(aes(Rating, Reviews, col = Type))+
  geom_smooth(se = FALSE)+
  scale_y_log10()



# Type, Category and Rating in one comparison -----------------------------
#which categories of Paid apps have better rating than the same but frees
#i create the roper table for that
rating_table <- play %>% 
  filter(Rating < 4.5, Reviews > 200, Type %in% c("Paid", "Free")) %>% 
  group_by(Category, Type) %>% 
  summarise(Rating = median(Rating),
            count_views= sum(Reviews),
            count = n()) %>% 
  mutate(prop = count / sum(count) * 100) %>% 
  filter(prop != 100)

rating_table %>%   
  select(Category, Type, prop) %>% 
  pivot_wider(names_from = Type, values_from = prop) %>% 
  mutate(difference = Free - Paid) %>% 
  arrange(difference)  #MEDICAL PERSONALIZATION


rating_table %>% 
  filter(Category %in% c("MEDICAL", "PERSONALIZATION")) %>% 
  ggplot(aes(Category, Rating, fill = Type))+
  geom_col(position = "dodge2")

#data frame
rating_table %>% 
  select(Category, Type, Rating) %>% 
  pivot_wider(names_from = Type, values_from = Rating) %>% 
  mutate(difference = Paid - Free,
         test = ifelse(difference > 0, "Paid better",
                       ifelse(difference == 0, "the same rating", "Free better"))) %>% 
  arrange(desc(difference))
  
  
  
  