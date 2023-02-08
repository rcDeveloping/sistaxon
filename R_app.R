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
        varSelectInput(
                'option', 'Selecione uma opção',
                sistaxon[, c(2, 4)]
        ),
        textInput('name', 'Enter your name:'),
        tableOutput('out'),
        downloadButton('download', 'Download')
)

server <- function(input, output, session) {
        df <- reactive({
                dplyr::filter(sistaxon, !!input$option == R.utils::capitalize(tolower(input$name)))
        })
        output$out <- renderTable({
                df()
        })
        output$download <- downloadHandler(
                filename = function() {
                        paste(input$name, '.csv', sep = '')
                },
                content = function(file) {
                        write.csv2(df(), file, row.names = FALSE, fileEncoding = 'latin1')
                }
        )

}

shinyApp(ui = ui, server = server)
