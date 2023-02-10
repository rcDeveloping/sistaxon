library(shiny)


url <- 'http://www.ibama.gov.br/phocadownload/sinaflor/2022/2022-07-22_Lista_especies_DOF.csv'

col_names <- c('Código da espécie', 'Nome científico', 
               'Código Nome Popular', 'Nome popular')

if (is.character(RCurl::getURL(url))) {
        con <- read.csv(url, fileEncoding = 'latin1')
        sistaxon <- con
        rm(con)
        names(sistaxon) <- col_names
} else {
        sistaxon <- read.csv('./2022-07-22_Lista_especies_DOF.csv', fileEncoding = 'latin1')
        names(sistaxon) <- col_names
}

ui <- fluidPage(
        titlePanel('SISTAXON'),
        theme = shinythemes::shinytheme('superhero'),
        sidebarLayout(
                sidebarPanel(
                        varSelectInput('option', 'Selecione uma opção', sistaxon[, c(2, 4)]),
                        textInput('name', 'Digite um nome:'),
                        downloadButton('download', 'Download')
                ),
                mainPanel(tableOutput('out'))
        )
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
