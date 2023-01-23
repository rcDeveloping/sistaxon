library(dplyr, warn.conflicts = FALSE)

## rad dataset
sistaxon <- read.csv2('./sistaxon/data/2021-04-30-sistaxon_DOF-Especies-e-Codigos.csv', 
                      fileEncoding = 'latin1')

## Query by popular name
sistaxon_seek <- sistaxon %>%
        filter(NomePopular == 'Inharé')

## Query by genus
genus <- sistaxon %>%
        filter(grepl('^Vouacapoua', NomeCientifico))


## Query by specie
sp <- sistaxon %>%
        filter(grepl('Handroanthus spongiosus', NomeCientifico))

## Save query as csv file
write.csv2(sistaxon_seek, 
           './output/psidiumREFLORA.csv', 
           row.names = FALSE)

CITES_443 <- read.csv2('D:/data/endangeredBrazilianPlantSpecies/output/Especies_Ameacadas_BRA.csv', 
                       fileEncoding = 'latin1')


sistaxon_seek %>%
        inner_join(CITES_443, 
                   by = c('NomeCientifico' = 'nome_cientifico'))
