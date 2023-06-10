library(shiny)
library(calidad)
library(survey)


### declaramos diseño complejo
com_dis <- svydesign(ids = ~Conglomerado,
                     strata = ~VarStrat,
                     weights = ~Fact_Pers,data = enusc)

options(survey.lonely.psu = "certainty")


## APP #

### UI ####
ui <- fluidPage(
  titlePanel("Probando paquete calidad del INE"),
  sidebarLayout(sidebarPanel(
    selectInput("var",label = "Variable de interés",choices = c("",names(enusc)),selected = ""),
    selectInput("denom",label = "Variable denominador",choices = c("",names(enusc)),selected = ""),
    selectInput("dominio",label = "Variable desagregacion",choices = c("",names(enusc)),selected = ""),
    downloadButton("download_tabla","Descarga")),
                mainPanel(tableOutput("tabla")
                          ))
)

### SERVER ####
server <- function(input, output, session) {


  if(input$denom == ""){
    R_denom =  NULL
  }else{
    R_denom = input$dominio
  }


#   R_denom <- reactiveVal(NULL)
#
#   R_denom = reactive({
# #    print(input$denom)
#
#   if(input$denom != ""){
#
#     input$denom
#
#   }
#
#   })

  R_dominio = reactive({
    # print(input$dominio)

    if(input$dominio == ""){
      NULL
    }else{
      input$dominio
    }
  })

### generamos tabla
  tabulado <- reactive({
  calidad::assess(calidad::create_prop(var = input$var,
                denominator = R_denom(),
                domains = R_dominio(),
                design = com_dis))
  })


  output$tabla <- renderTable({
req(input$var)

    # print(R_dominio)
    # print(R_denom)

tabulado()

    })


  output$download_tabla <- downloadHandler(
    filename = function() {
      paste0("tabulado-", format(Sys.time(),"%Y-%m-%d-%H%M%S"), ".xlsx", sep="")
    },
    content = function(file) {
      writexl::write_xlsx(tabulado(), file)
    }
  )
}

shinyApp(ui, server)



