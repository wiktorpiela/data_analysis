source("uploading and data clearing.R") #uruchomienie calego pliku data clearing
glimpse(play)

play %>% 
  filter(actual_size > 0) %>% 
  skim(actual_size)

# Was applications becoming more and more virtual memory demanding? -------
play %>% 
  filter(actual_size > 0) %>% 
  mutate(year = year(`Last Updated`),
         month = month(`Last Updated`),
         period = myd(paste(month, year), truncated = 1)) %>% 
  group_by(period) %>% 
  summarise(size = median(actual_size)) %>% 
  ggplot(aes(period, size))+
  geom_smooth(se = FALSE)+
  expand_limits(y = 0)

#table
growth <- play %>% 
  filter(actual_size > 1) %>% 
  mutate(year = year(`Last Updated`)) %>%
  group_by(year) %>% 
  summarise(size = median(actual_size))

difference <- diff(growth$size)
difference <- append(difference, 0, after = 0)

growth %>% 
  mutate(abs_growth_const = growth$size - growth$size[1],
         abs_growth_vrbl = difference,
         relative_growth_const = (growth$size - growth$size[1]) / growth$size[1] * 100)


#relative dynamic plot by year
growth %>% 
  mutate(abs_growth_const = growth$size - growth$size[1],
         abs_growth_vrbl = difference,
         relative_growth_const = (growth$size - growth$size[1]) / growth$size[1]) %>% 
  ggplot(aes(year, relative_growth_const))+
  geom_point()+
  geom_line()+
  scale_y_continuous(labels = percent)+
  labs(x = "Years",
       y = "Increase in percents - dynamic",
       title = "Dynamics of apps sizing growth (in Mb) by year, 2011 = 100")

#comparison - absolute growth variable vs asb growth cosntans vs relative growth
growth %>% 
  mutate(abs_growth_const = growth$size - growth$size[1],
         abs_growth_vrbl = difference,
         relative_growth_const = (growth$size - growth$size[1]) / growth$size[1] * 100) %>% 
  pivot_longer(cols = 3:5, names_to = "indicator", values_to = "value") %>% 
  ggplot(aes(year, value, col = indicator))+
  geom_smooth(se = FALSE)+
  facet_wrap(vars(indicator), scales = "free")


#sizing comparison Type
#density plot
play %>% 
  filter(Type %in% c("Paid", "Free"),
         Reviews > 200, actual_size > 1) %>% 
  ggplot(aes(actual_size, fill = Type))+
  geom_density(alpha = 0.7)
#boxplot
play %>% 
  filter(Type %in% c("Paid", "Free"),
         Reviews > 200, actual_size > 1) %>% 
  ggplot(aes(Type, actual_size))+
  geom_boxplot(coef = 4)
#data labels
play %>% 
  filter(Type %in% c("Paid", "Free"),
         Reviews > 200, actual_size > 1) %>% 
  group_by(Type) %>% 
  summarise(median_size = median(actual_size),
            max_size = max(actual_size))
#or favstats
play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  favstats(actual_size ~ Type, data = .) %>% 
  filter(Type %in% c("Paid", "Free"))

#tagret groups comparison
#density
play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  ggplot(aes(actual_size, fill = Group))+
  geom_density(alpha = 0.6)

#boxplot
play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  ggplot(aes(Group, actual_size))+
  geom_boxplot(coef = 3)

play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  favstats(actual_size ~ Group, data = .)
  
#popular Categories sizing comparison
play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  count(Category, sort = TRUE) %>% 
  mutate(prop = n / sum(n) * 100) %>% #FAMILY GAME TOOLS
  top_n(3, prop) %>% 
  


#density
play %>% 
  filter(Reviews > 200, actual_size > 1, 
         Category %in% c("FAMILY", "GAME", "TOOLS")) %>%
  ggplot(aes(actual_size, fill = Category))+
  geom_density(alpha = 0.6)

#boxplot
play %>% 
  filter(Reviews > 200, actual_size > 1, 
         Category %in% c("FAMILY", "GAME", "TOOLS")) %>% 
  ggplot(aes(Category, actual_size)) +
  geom_boxplot(coef = 3)

#data labels
play %>% 
  filter(Reviews > 200, actual_size > 1) %>% 
  favstats(actual_size ~ Category, data = .) %>% 
  filter(Category %in% c("FAMILY", "GAME", "TOOLS"))

  
