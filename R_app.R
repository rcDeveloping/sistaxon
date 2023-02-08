library(shiny)


url <- 'http://www.ibama.gov.br/phocadownload/sinaflor/2022/2022-07-22_Lista_especies_DOF.csv'

con <- read.csv(url, fileEncoding = 'latin1')
sistaxon <- con
rm(con)
names(sistaxon) <- c('Código da espécie', 'Nome científico', 
                     'Código Nome Popular', 'Nome popular')

ui <- fluidPage(
        titlePanel('SISTAXON'),
        theme = shinythemes::shinytheme('superhero'),
        textInput('name', 'Enter your name:'),
        tableOutput('out')
)

server <- function(input, output, session) {
        output$out <- renderTable({
                subset(sistaxon, `Nome científico` == R.utils::capitalize(tolower(input$name))) 
        })
        
}

shinyApp(ui = ui, server = server)
