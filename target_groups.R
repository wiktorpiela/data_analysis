source("uploading and data clearing.R") 

glimpse(play)

# target groups and categories of apps ------------------------------------

play %>% 
  filter(!is.na(Group)) %>% 
  ggplot(aes("", fill = Group))+
  geom_bar(position = "fill")+
  coord_polar(theta = "y")+
  scale_y_continuous(labels = percent, breaks = seq(0, 1, 0.15))+
  theme(axis.title = element_blank(),
        axis.ticks = element_blank())

#data labels
play %>% 
  filter(!is.na(Group)) %>% 
  count(Group) %>% 
  mutate(percent = n / sum(n) * 100)


# which category of apps is the most popular among given group ?  --------
#I count the most popular categories for each of the groups
play %>% 
  filter(Group %in% c("Everyone", "Teen", "Adults")) %>% 
  group_by(Group) %>% 
  count(Category, sort = TRUE) %>% 
  mutate(prop = n / sum(n)* 100) %>% 
  group_by(Group) %>% 
  top_n(3, prop) %>% 
  arrange(Group, desc(prop))

#Adults
play %>% 
  filter(Group == "Adults") %>% 
  mutate(Category = fct_other(Category,
                              keep = c("DATING", "GAME", "SOCIAL"))) %>% 
  ggplot(aes(Group, fill = Category))+
  geom_bar(position = "fill", width = 0.6)+
  scale_y_continuous(labels = percent)+
  theme(axis.text.x = element_blank())+
  labs(y = "Proportion", 
       title = "Dating apps the most popular among adult users")+
  annotate(geom = "label", x = "Adults", y = 0.8, label = "40%")+
  annotate(geom = "label", x = "Adults", y = 0.5, label = "14.7%")+
  annotate(geom = "label", x = "Adults", y = 0.4, label = "13.3%")



play_groups_category_adults <- play %>% 
  filter(!is.na(Group)) %>% 
  mutate(Category = fct_other(Category,
                              keep = c("DATING", "GAME", "SOCIAL")))

crosstab(play_groups_category_adults$Group, 
         play_groups_category_adults$Category, prop.r = TRUE)  

#Teen
play %>% 
  filter(Group == "Teen") %>% 
  mutate(Category = fct_other(Category,
                              keep = c("GAME", "FAMILY"))) %>% 
  ggplot(aes(Group, fill = fct_infreq(Category)))+
  geom_bar(position = "fill", width = 0.5)+
  scale_y_continuous(labels = percent)+
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())+
  labs(y = "Proportion",
       title = "Teen's group more diversified - only two categories domination",
       fill = "Category")+
  annotate(geom = "label", x = "Teen", y = 0.75, label = "47.3%")+
  annotate(geom = "label", x = "Teen", y = 0.45, label = "28.5%")+
  annotate(geom = "label", x = "Teen", y = 0.15, label = "24.2%")

play_groups_category_teens <- play %>% 
  filter(!is.na(Group)) %>% 
  mutate(Category = fct_other(Category,
                              keep = c("GAME", "FAMILY")))

crosstab(play_groups_category_teens$Group, 
         play_groups_category_teens$Category, prop.r = TRUE)
  
#Everyone
play %>% 
  filter(Group == "Everyone") %>% 
  mutate(Category = fct_other(Category, 
                              keep = "FAMILY")) %>% 
  ggplot(aes(Group, fill = Category))+
  geom_bar(position = "fill", width = 0.5)+
  scale_y_continuous(labels = percent)+
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())+
  annotate(geom = "label", x = "Everyone", y = 0.9, label = "17.6%")+
  labs(title = "The group of Everyone the most diversified comparing with the rest -
       only one category domination", y = "Proportion")

play_groups_category_everyone <- play %>% 
  filter(!is.na(Group)) %>% 
  mutate(Category = fct_other(Category, 
                              keep = "FAMILY"))

crosstab(play_groups_category_everyone$Group, 
         play_groups_category_everyone$Category, prop.r = TRUE)


#how many apps of given type includes adult and teens customes?
play %>% 
  filter(Reviews > 200, !is.na(Group), Type %in% c("Paid", "Free"), 
         Group != "Everyone") %>% 
  ggplot(aes(Type, fill = Group))+
  geom_bar(position = "fill")+
  scale_y_continuous(labels = percent)

#data labels counting / or crosstable
play %>% 
  filter(Reviews > 200, Group %in% c("Adults", "Teen"), 
         Type %in% c("Paid", "Free")) %>% 
  group_by(Type, Group) %>% 
  count(Type) %>%
  group_by(Type) %>% 
  mutate(prop = n / sum(n) * 100)

play_adultsvsteens_type <- play %>% 
  filter(Reviews > 200, !is.na(Group), Type %in% c("Paid", "Free"),
         Group != "Everyone")

crosstab(play_adultsvsteens_type$Group,
         play_adultsvsteens_type$Type, prop.c = TRUE)


