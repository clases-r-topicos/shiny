
library(shiny)

ui <- fluidPage(
  numericInput("valor1","Valor 1",value = 10),

  shiny::br(),
  shiny::br(),

  numericInput("valor2","Valor 2",value = 10),

  shiny::br(),
  shiny::br(),

  verbatimTextOutput("resultado"),

  shiny::br() ,
  shiny::br() ,


  shiny::actionButton("calc_btn","Calcular")

)

server <- function(input, output, session) {

observeEvent(input$calc_btn,{
  output$resultado = renderText({

    isolate({input$valor1})  * isolate({ input$valor2})

  })

})



}

shinyApp(ui, server)



runExample("01_hello")



