library(shiny)
library(shinythemes)
library(stringr)
library(glue)
library(tidyverse)
library(shinyjs)

## read data
dat <- readRDS("dat.rds")

## UI ----------------------------------
ui <- fluidPage(theme = shinytheme("flatly"),
                useShinyjs(),
                
                # Application title
                titlePanel("Stringr Explorer"),
                
                # Sidebar with a slider input for number of bins 
                sidebarLayout(
                  sidebarPanel(
                    
                    ## 1st level select input
                    selectInput("want", "I want to",
                                choices = unique(dat$str_fn_title)),
                    
                    ## 2nd level select input 
                    uiOutput("select_level2")
                    # conditionalPanel("input.want != input.ex_title",
                    #                  uiOutput("select_level2"))
                  ),
                  
                  mainPanel(
                    
                    fluidRow(column(width = 12,
                                    conditionalPanel("output.cond",
                                                     tags$h3(textOutput("fn_name")),
                                                     tags$h4("Usage"),
                                                     verbatimTextOutput("usage"),
                                                     tags$h4("Example"),
                                                     verbatimTextOutput("expr"),
                                                     tags$h4("Output"),
                                                     verbatimTextOutput("expr_res"))
                    ))
                  )
                )
)

## Server -------------------------------------
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
    req(fn_level2(), input$want)
    selectInput("ex_title", "", choices = fn_level2())
  })
  
  
  fn_selected <- reactive({
    req(input$want, input$ex_title)
    dat %>%
      filter(str_fn_title == input$want,
             example_title == input$ex_title)
  })
  
  ## get selected function name
  f_name <- reactive({
    req(fn_selected())
    
    fn_selected() %>% 
      pull(str_fn_names) 
  })
  
  ## print funcion name
  output$fn_name<- renderText({
    f_name()
  })
  
  ## panel condition -----------------
  output$cond <- reactive({
    req(expression_txt())
    length(expression_txt())
  })
  
  outputOptions(output, "cond", suspendWhenHidden = FALSE) 
  
  ## get the expression corresponding to the selected function --------------------
  expression_txt <- reactive({
    req(fn_selected())
    
    fn_selected() %>% 
      pull(example) %>% 
      unique()
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
  
  ## print function usage
  output$usage <- renderPrint({
    req(fn_selected())
    
    fn_selected() %>% 
      pull(str_fn_usage) %>% 
      unique() %>% 
      unlist() %>% 
      glue()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

