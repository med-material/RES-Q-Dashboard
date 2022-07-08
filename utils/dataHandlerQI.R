#If you want to test this function on the console, you need to import dataloader and load the data so you can see what it's doing (check last lines)
source("utils/dataLoader.R", local = T)

#Takes in the data and parameters that define which & how the data will be aggregated.
#Returns: Aggregated data for the last 4 quarters for trends data & aggregated data for the last quarter for stacked_bargraphs
dataHandlerQI <- function (data, dataType, QI_Fetch, hospital, country, aggType) {
  
  #Find latest quarter of hospital of interest
  starting <- data %>% filter(site_name == hospital)
  latest <- max(starting$YQ)
  
  #Define scope of the data
  scope <- sort(unique(starting$YQ), decreasing = TRUE)
  scope <- head(scope,4)
  scope <- data.frame(YQ = scope)
  
  #Hospital scope
  hosp_data_scope <- data %>% 
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_name == hospital) %>%
    group_by(YQ) 
  
  #Country Scope
  country_data_scope <- data %>%
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_country == country) %>%
    group_by(YQ)
  
  #What to do in case the data is quantitative, for quantitative we have mean and median aggregates.
  if (dataType == "Quantitative") {
  
    hosp_data_scope <- hosp_data_scope %>%
      summarize(.groups = 'drop',
        Hospital = 
          if (!!aggType == "mean") {
            mean(Value, na.rm = T)
          }
        
        else if (!!aggType == "median") {
          median(Value, na.rm = T)
        }
        
        
        
      )
    
    country_data_scope <- country_data_scope %>%
      summarize(.groups = 'drop',
        Country = 
          if (!!aggType == "mean") {
            mean(Value, na.rm = T)
          }
        
        else if (!!aggType == "median") {
          median(Value, na.rm = T)
        }
      )
    
    #Collecting both Country & Hospital data under the same variable
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    hosp_data_agg$Country <- country_data_agg$Country
    
    #Test missing data flag
    #hosp_data_agg$Hospital[2] <- NA
    
    #Flagging data, if want to add more flags add more condition checking below
    hosp_data_agg$Flag <- as.factor(ifelse(is.na(hosp_data_agg$Hospital), "Missing", "Good"))
    
    #Filling missing data with rolling mean of data
    hosp_data_agg <- hosp_data_agg %>% mutate(Hospital = ifelse(is.na(Hospital), mean(Hospital, na.rm=T), Hospital))
    hosp_data_agg <- hosp_data_agg %>% mutate(Country = ifelse(is.na(Country), mean(Country, na.rm=T), Country))
    return(hosp_data_agg)
  }
  
  #What to do in case the dataType is categorical binary, for this dataType we have 2 aggregates % and count.
  else if (dataType == "Categorical_binary") {
    
    #Renaming value to category and generating a hospital tag
    hosp_data_scope <- hosp_data_scope  %>% 
      rename(Category = Value) %>% mutate(Scope = "Hospital") %>% select(c(YQ, QI, Category, Scope))
    
    #Renaming value to category and generating a country tag
    country_data_scope <- country_data_scope  %>%
      rename(Category = Value) %>% mutate(Scope = "Country") %>% select(c(YQ, QI, Category, Scope))
    
    #Merge hopsital & country data with the scope to ensure there is data for all quarters within the scope 
    #(if no values are present for a quarter it will merge as NA)
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    
    #Bind the two together
    hosp_data_agg <- rbind(hosp_data_agg, country_data_agg)
    
    #Converts characters such as "True" and "False" into their logical values R recognizes TRUE/FALSE or T/F
    hosp_data_agg$Category <- as.logical(hosp_data_agg$Category)
    
    #How to aggregate for % aggregates (we are interested in what percentage is true for example). Note denom counts the entrees for each grouped (YQ QI Scope)
    if (aggType == "%") {
      hosp_data_agg <- hosp_data_agg %>% group_by(YQ, QI, Scope) %>% 
        summarise(.groups = 'drop',
          denom = n(),
          Category = sum(Category, na.rm = T)
        )
      #Converting to percentages and changing to wide format for plotting purposes
      hosp_data_agg <- hosp_data_agg %>% mutate(Category = 100*Category/denom) %>% select(-denom)
      hosp_data_agg <- hosp_data_agg %>% pivot_wider(names_from = Scope, values_from = Category)
    }
    
    #How to aggregte for count aggregates, sum counts the number of TRUE entrees per grouped (YQ QI Scope)
    else if (aggType == "count") {
      #Counting and changing to wide format for plotting
      hosp_data_agg <- hosp_data_agg %>% group_by(YQ, QI, Scope) %>% summarise(.groups = 'drop', Category = sum(Category, na.rm = T))
      hosp_data_agg <- hosp_data_agg %>% pivot_wider(names_from = Scope, values_from = Category)
    }
    #Flagging data, if want to add more flags add more condition checking below
    hosp_data_agg$Flag <- as.factor(ifelse(is.na(hosp_data_agg$Hospital), "Missing", "Good"))
    return(hosp_data_agg)
  }
  
  #What to do if the data is categorical (plural, more than binary) this is what woull output aggregates for stacked bargraphs.
  else {
    #Renaming and adding a hospital/country value under Scope for plotting
    hosp_data_scope <- hosp_data_scope  %>% 
      rename(Category = Value) %>% mutate(Scope = "Hospital") %>% select(c(YQ, QI, Category, Scope))
    
    country_data_scope <- country_data_scope  %>%
      rename(Category = Value) %>% mutate(Scope = "Country") %>% select(c(YQ, QI, Category, Scope))
    
    #Merge hopsital and country data with the scope to make sure each quarter is present, if no data is available for that quarter it will receive NA values
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    
    #Bind country and hospital data together, think of this as vertically adding more rows to the data frame.
    hosp_data_agg <- rbind(hosp_data_agg, country_data_agg)
    
    return(hosp_data_agg)
    
  }
}

#Testing
# db <- dataLoader()
# numVars <- db$numVars
# catVars <- db$catVars
# 
# metrics <- dataHandlerQI(catVars, "Categorical", "discharge_mrs", "uggeebfixudwdhb", "vrprkigsxydwgni", "cat")
# metrics <- metrics %>% filter(YQ == max(metrics$YQ))
# 
# if (all(!is.na(metrics$Category))) {
#   plot <- ggplot(metrics, aes(x = Scope, fill = Category)) +
#     geom_bar(position ="fill", width = 0.4) + coord_flip() +
#                                 theme(axis.ticks.x = element_blank(),
#                                       axis.text.x = element_blank(),
#                                       axis.title.x = element_blank(),
#                                       axis.ticks.y = element_blank(),
#                                       legend.position = "none",
#                                       axis.title.y = element_blank(),
#                                       panel.grid.major = element_blank(),
#                                       panel.grid.minor = element_blank(),
#                                       panel.background = element_blank())
#   
#   ggplotly(plot)
# }
# metrics2 <- dataHandlerQI(numVars, "Quantitative", "door_to_imaging", "uggeebfixudwdhb", "vrprkigsxydwgni", "median")
# metrics2$Hospital <- round(metrics2$Hospital,1)
# 
# metrics3 <- dataHandlerQI(catVars, "Categorical_binary", "discharge_antidiabetics", "uggeebfixudwdhb", "vrprkigsxydwgni", "%")
# plot2 <- ggplot(metrics3, aes(x = YQ)) + geom_point(aes(y = Hospital, group = 1)) + geom_line(aes(y = Hospital, group = 1)) +
#   geom_point(aes(y = Country, group = 1)) + geom_line(aes(y = Country, group = 1)) +
#   theme(axis.ticks.x = element_blank(),
#       axis.text.x = element_blank(),
#       axis.title.x = element_blank(),
#       axis.ticks.y = element_blank(),
#       axis.text.y = element_blank(),
#       axis.title.y = element_blank(),
#       panel.grid.major = element_blank(),
#       panel.grid.minor = element_blank(),
#       panel.background = element_blank())
# 
# ggplotly(plot2)


#ggplot(metrics, aes(x = Value, fill = group)) + 
#  geom_bar()