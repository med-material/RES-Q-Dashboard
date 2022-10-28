#the following should not yield any fields
structureData %>% filter(isKPI=="x") %>% select(dataColumns) %>% filter(!(dataColumns %in% unique(structureData$dataColumns)))
