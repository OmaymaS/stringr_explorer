library(tidyverse)
library(glue)
library(tools)
library(here)

## get stringr functions ---------------------------
str_fn_names <- ls("package:stringr") 

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
                       "str_c", "...",
                       'str_c("Letter: ", letters)',
                       
                       "str_conv", "...",
                       'as.raw(177) %>% rawToChar %>% str_conv("ISO-8859-1")',
                       
                       "str_count", "...",
                       'fruit <- c("apple", "banana", "pear", "pineapple")\n
                       str_count(fruit, "a")',
                       
                       "str_detect", "...",
                       'fruit <- c("apple", "banana", "pear", "pinapple")\n
                       str_detect(fruit, "b")',
                       
                       "str_dup", "...",
                       'fruit <- c("apple", "pear", "banana")\n
                       str_dup(fruit, 2)',
                       
                       "str_length", "...",
                       'str_length(c("i", "like", "programming", NA))',
                       
                       "str_order", "....",
                       'fruit <- c("pineapple", "pear", "apple", "banana")\n
                       str_order(fruit)',
                       
                       "str_pad", "...",
                       'str_pad(c("a", "abc", "abcdef"), 10)',
                       
                       
                       "str_extract", "Extract first match",
                       'shopping_list <- c("apples x4", "bag of flour",
                       "bag of sugar", "milk x2")\n str_extract(shopping_list, "[a-z]+")',
                       
                       "str_extract_all", "Extract all matches",
                       'shopping_list <- c("apples x4", "bag of flour","bag of sugar", "milk x2")\n
                       str_extract_all(shopping_list, "[a-z]+")',
                       
                       "str_extract_all", "Extract all words",
                       'str_extract_all("This is, suprisingly, a sentence.", boundary("word"))',
                       
                       "str_detect", "Vectorized over string",
                       'fruit <- c("apple", "banana", "pear", "pinapple")\n str_detect(fruit, "e$")',
                       
                       "str_detect", "Vectorized over pattern", 
                       'str_detect("aecfg", letters)',
                       
                       "str_sub", "...",
                       'hw <- "Hadley Wickham"\n\n str_sub(hw, 1, 6)',
                       
                       "str_subset", "...",
                       'fruit <- c("apple", "banana", "pear", "pinapple")\n
                       str_subset(fruit, "e$")',
                       
                       "str_split", "At a certain pattern",
                       'fruits <- c("apples and oranges and pears and bananas",
                       "pineapples and mangos and guavas")\n
                       str_split(fruits, " and ")',
                       
                       "str_split", "Specify n to restrict the number of possible matches",
                       'fruits <- c("apples and oranges and pears and bananas",
                       "pineapples and mangos and guavas")\n
                       str_split(fruits, " and ", n =2)',
                       
                       "str_split_fixed", "Use fixed to return a character matrix",
                       'fruits <- c("apples and oranges and pears and bananas",
                       "pineapples and mangos and guavas")\n
                       str_split_fixed(fruits, " and ", 3)',
                       
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
                       'dog <- "The quick brown dog"\n str_to_title(dog)',
                       
                       "str_replace", "Replace first match",
                       'fruits <- c("one apple", "two pears", "three bananas")\n
                       str_replace(fruits, "[aeiou]", "-")',
                       
                       "str_replace", "Replace all  matchs",
                       'fruits <- c("one apple", "two pears", "three bananas")\n
                       str_replace_all(fruits, "[aeiou]", "-")',
                       
                       "str_replace_na", '...',
                       'str_replace_na(c(NA, "abc", "def"))',
                       
                       "word", "Extract first word",
                       'sentences <- c("Jane saw a cat", "Jane sat down")\n
                       word(sentences, 1)',
                       
                       "word", "Extract last word",
                       'sentences <- c("Jane saw a cat", "Jane sat down")\n
                       word(sentences, -1)',
                       
                       "word", "Extract words from start to end positions(inclusive)",
                       'sentences <- c("Jane saw a cat", "Jane sat down")\n
                        word(sentences, start = 2, end = -1)',
                       
                       "word", "Define words by other separators",
                       "str <- 'abc.def..123.4568.999'\n
                       word(str, 1, sep = fixed('..'))"
)


## join examples with dat  ---------------------
dat  <- dat %>% inner_join(fn_examples)

## save data
# data_path <- paste0(here(), "/data-raw/")
data_path <- paste0(here(), "/stringr_help/")

saveRDS(dat, paste0(data_path, "/dat.rds"))