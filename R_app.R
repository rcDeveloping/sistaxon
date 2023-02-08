library(shiny)

ui <- fluidPage(
        titlePanel('SISTAXON'),
        textInput('name', 'Enter your name:'),
        tableOutput('out')
)

server <- function(input, output, session) {
        output$out <- renderTable({
                subset(sistaxon, NomeCientifico == R.utils::capitalize(tolower(input$name))) 
        })
        
}

shinyApp(ui = ui, server = server)
