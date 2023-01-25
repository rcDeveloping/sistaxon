library(dplyr, warn.conflicts = FALSE)

## read data sets
sistaxon <- read.csv2(
        './data/2021-04-30-sistaxon_DOF-Especies-e-Codigos.csv', fileEncoding = 'latin1'
)

CITES_443 <- read.csv2(
        './data/Especies_Ameacadas_BRA.csv', 
        fileEncoding = 'latin1'
)

## Query by popular name
sistaxon_seek <- sistaxon %>%
        filter(NomePopular == 'Acapu')

sistaxon_seek

## Query by genus
genus <- sistaxon %>%
        filter(grepl('^Vouacapoua', NomeCientifico))

genus

## Query by specie
sp <- sistaxon %>%
        filter(grepl('Handroanthus spongiosus', NomeCientifico))

sp 

## Save query as csv file
write.csv2(sistaxon_seek, 
           './output/Vouacapoua.csv', 
           row.names = FALSE)

## Find out the ecological status of the specie
sistaxon_seek %>%
        inner_join(CITES_443, 
                   by = c('NomeCientifico' = 'nome_cientifico'))
