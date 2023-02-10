library(dplyr, warn.conflicts = FALSE)
library(ggplot2)


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

png('./output/plot.png', width = 1500, height = 750, units = 'px', res = 300)

data_plot <- sistaxon %>%
        group_by(`Nome científico`) %>%
        summarize(n = n()) %>%
        arrange(desc(n)) %>%
        slice_head(n = 10) %>%
        mutate(`Nome científico` = forcats::fct_reorder(`Nome científico`, n)) %>%
        ggplot(aes(`Nome científico`, n)) +
        geom_col(fill = 'steelblue') +
        coord_flip() +
        geom_text(aes(label = n), hjust = 1.5, color = 'white', size = 1.5) +
        labs(title = 'Espécies com Maior Número de Nomes Populares', x = '', y = '') +
        theme(
                plot.title = element_text(size = 10, hjust = 0.5, face = 'bold'),
                axis.text.y = element_text(size = 8, face = 'italic'),
                panel.grid = element_blank(),
                axis.ticks.x = element_blank(),
                axis.text.x = element_blank(),
                plot.caption = element_text(size = 6, face = 'italic'),
                legend.position = 'top',
                panel.border = element_blank()
        )

print(data_plot)

dev.off()
