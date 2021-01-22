source("uploading and data clearing.R") 

glimpse(play)

# which categories are the most numerous ----------------------------------
play %>% 
  filter(Type %in% c("Paid", "Free"), Reviews > 200) %>% 
  group_by(Type) %>% 
  count(Category, sort = TRUE) %>% 
  group_by(Type) %>% 
  mutate(prop = n / sum(n) * 100) %>% 
  ungroup() %>% 
  top_n(4, prop)

#plots for both Type
play %>% 
  filter(Type %in% c("Free", "Paid"), Reviews > 200) %>% 
  mutate(Category = fct_other(Category, keep = c("FAMILY", "GAME"))) %>% 
  ggplot(aes("", fill = fct_infreq(Category)))+
  geom_bar(position = "fill")+
  coord_polar(theta = "y")+
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.15))+
  labs(fill = "Category",
  title = "Share the most numerous categories aming free apps vs paid apps set")+
  theme(axis.ticks = element_blank())+
  facet_wrap(vars(Type))+
  theme(axis.title = element_blank())
 
# time range tencency - an example the most popular -----------------------
pop_categories <- play %>% filter(Type %in% c("Paid", "Free")) %>% 
  group_by(Type) %>% 
  count(Category, sort = TRUE) %>% 
  mutate(prop = n / sum(n)* 100) %>% 
  group_by(Type) %>% 
  top_n(3, prop)

play %>% 
  filter(Category %in% pop_categories$Category, Reviews > 200) %>% 
  mutate(year = year(`Last Updated`),
         month = month(`Last Updated`),
         period = myd(paste(month, year), truncated = 1)) %>% 
  group_by(year, Type) %>% 
  count(Category) %>% 
  ggplot(aes(year, n, col = Category))+
  geom_smooth(se = FALSE)+
  scale_y_log10()+
  labs(title = "Yearly growth of apps of the most popular Categories",
       y = "Amount of apps by year") +
  facet_wrap(vars(Type), scales = "free")



           
