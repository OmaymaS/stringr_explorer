library(tidyverse)
library(glue)
library(tools)
library(here)

## get stringr functions ---------------------------
str_fn_names <- ls("package:stringr") 

## exclude data and some values -------------------------
str_fn_names_exclude <- c("%>%", "boundary", "coll", "fixed",
                          "fruit", "ignore.case", "invert_match" ,
                          "perl", "regex", "sentences", "words", "str_sub<-")

## update the str_fn_names vector ---------------------
str_fn_names <- setdiff(str_fn_names, str_fn_names_exclude)

## get stringr functions help -------------------------
str_fn_help <- map(str_fn_names,  ~ utils:::.getHelpFile(help(.x, package = "stringr"))) 

## get stringr functions title ------------------------
str_fn_title <- map_chr(str_fn_help, ~ tools:::.Rd_get_metadata(.x, "title")) 

## get stringr functions usage ------------------------
str_fn_usage <- map(str_fn_help, ~ tools:::.Rd_get_metadata(.x, "usage")) %>%  
  map(~.x[.x!=""]) %>% 
  map(~paste(.x, collapse = "\n")) %>% 
  map(glue)


## create a tibble with examples coresponding to each function ----------------------
dat <- tibble(str_fn_names = str_fn_names,
              str_fn_help = str_fn_help,
              str_fn_title = str_fn_title,
              str_fn_usage = str_fn_usage)

fn_examples <- tribble(~str_fn_names, ~example_title, ~example,
                       # "str_c", NA ,  'str_c("Letter: ", letters)',
                       "str_extract", "Extract first match",
                       'shopping_list <- c("apples x4", "bag of flour", "bag of sugar", "milk x2")\n str_extract(shopping_list, "[a-z]+")',
                       
                       "str_extract_all", "Extract all matches",
                       'shopping_list <- c("apples x4", "bag of flour","bag of sugar", "milk x2")\n str_extract_all(shopping_list, "[a-z]+")',
                       
                       "str_extract_all", "Extract all words",
                       'str_extract_all("This is, suprisingly, a sentence.", boundary("word"))',
                       
                       "str_detect", "Vectorized over string", 'fruit <- c("apple", "banana", "pear", "pinapple")\n
                       str_detect(fruit, "e$")',
                       
                       "str_detect", "Vectorized over pattern", 
                       'str_detect("aecfg", letters)',
                       
                       "str_locate", "Find the first match location",
                       'fruit <- c("apple", "banana", "pear", "pineapple")\n
                       str_locate(fruit, "e")',
                       
                       "str_locate_all", "Find all matches locations",
                       'fruit <- c("apple", "banana", "pear", "pineapple")\n
                       str_locate_all(fruit, "e")',
                       
                       "str_to_upper", "To uppercase",
                       'dog <- "The quick brown dog"\n str_to_upper(dog)',
                       
                       "str_to_lower", "to lowercase",
                       'dog <- "The quick brown dog"\n str_to_lower(dog)',
                       
                       "str_to_title", "to title",
                       'dog <- "The quick brown dog"\n str_to_title(dog)'
)


## join examples with dat  ---------------------
dat  <- dat %>% inner_join(fn_examples)

## save data
data_path <- paste0(here(), "/data-raw/")

dat <- saveRDS(dat, paste0(data_path, "/dat.rds"))