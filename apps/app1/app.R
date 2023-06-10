library(shiny)
library(guaguas)
library(dplyr)
library(ggplot2)


datos <- guaguas %>% filter(n >= 100)

ui <- fluidPage(
  titlePanel("Buscando nombres"),
      sidebarLayout(
        sidebarPanel(h3("Inputs"),
                    selectInput(inputId = "nombre",
                    label = "Nombres",
                    choices = unique(datos$nombre))
             ),
        mainPanel(h3("Outputs"),
                  plotOutput(outputId = "frecuencia_guaguas")
             )
             )
)



server <- function(input, output, session) {

  output$frecuencia_guaguas <- renderPlot({
    datos %>%
      filter(nombre == input$nombre) %>%
      ggplot(aes(anio,n)) +
      geom_line()
  })

}

shinyApp(ui, server)
