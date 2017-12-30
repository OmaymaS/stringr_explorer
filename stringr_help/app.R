#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(stringr)
library(glue)
library(tidyverse)

dat <- readRDS("dat.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
   
   # Application title
   titlePanel("Stringr Explorer"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("want", "I want to",
                    choices = unique(dat$str_fn_title)),
        
        uiOutput("select_level2")
      ),
      
      # Show 
      mainPanel(
        tags$h3(textOutput("fn_name")),
        tags$h4("Usage"),
        verbatimTextOutput("usage"),
        tags$h4("Example"),
        verbatimTextOutput("expr"),
        tags$h4("Output"),
        verbatimTextOutput("expr_res")
        

      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  ## get example_title to show in select_level2 selectInput -----------
  fn_level2 <- reactive({
    req(input$want)
    dat %>% 
      filter(str_fn_title == input$want) %>% 
      pull(example_title)
  })
  
  ## 
  output$select_level2 <- renderUI({
    req(fn_level2())
    selectInput("ex_title", "", choices = fn_level2())
  })
   
  
  # fn_selected <- reactive({
  #   req(input$want, input$ex_title)
  #   dat %>% 
  #     filter(str_fn_title == input$want,
  #            example_title == input$ex_title)
  # })
  
  f_name <- reactive({
    req(input$want)
    dat %>% 
      filter(str_fn_title == input$want
             # example_title == input$ex_title
             ) %>% 
      pull(str_fn_names) %>% .[1]
  })
  
  ## print funcion name
  output$fn_name<- renderText({
     # capture.output(example("str_trunc")) %>%
     #  gsub("str_tr>|str_tr\\+", "", .) %>%
     #  cat(sep = "\n")
    f_name()
    # fn_level2()
  })
  
  ## get the expression corresponding to the selected function
  expression_txt <- reactive({
    req(dat, input$want, input$ex_title)
    
    # req(f_name(), fn_level2())
    
    # if(!is.na(fn_level2())){
      req(input$ex_title)
      res <- dat %>%
        filter(str_fn_title == input$want) %>% 
        filter(example_title == input$ex_title)
    # }
    # 
    # else{
    #   res <- dat %>% 
    #     filter(str_fn_names == f_name())
    # }

      res %>% pull(example) %>% unique()
  })
  
  ## print selected expression 
  output$expr <- renderText({
    req(expression_txt())
    
    expression_txt() %>%  
      glue()
  })
  
  
  ## evaluate and print selected expression 
  output$expr_res <- renderPrint({
    req(expression_txt())
    parse(text = expression_txt()) %>% eval
  })

  output$usage <- renderPrint({
    req(f_name())
    
 # if(!is.na(fn_level2())){
      req(input$ex_title)
      res2 <- dat %>%
        filter(str_fn_title == input$want) %>% 
        filter(example_title == input$ex_title)
    # }
    # 
    # else{
    #   res2 <- dat %>% 
    #     filter(str_fn_names == f_name())
    # }
    # 
    res2 %>%
      pull(str_fn_usage) %>% unique() %>% unlist() %>% glue()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

