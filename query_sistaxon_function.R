## Set a function to serach in the SISTAXON dataset
query_sistaxon <- function() {
        
        # Sets the "type" and "name" variables
        type <- ''
        name <- ''
        
        # Show command messages to the user
        cat('Busca SISTAXON\n\n')
        cat('Digite 1 - Para buscar por Nome Popular (ex.: Cedro, Angelim-de-folha-larga)\n')
        cat('Digite 2 - Para buscar por Gênero (ex.: Cedrela)\n')
        cat('Digite 3 - Para buscar por Espécie (ex.: Cedrela odorata)\n')
        
        # Read data from the keyboard user
        type <- scan(what = 'integer', nmax = 1, flush = TRUE)
        
        ## Serach by popular name
        if (type == 1) {
                # Show message on user's screen
                cat('Digite o nome popular\n')
                # get the scientific name form console's user
                name <- scan(what = 'character', n = 1, encoding = 'latin1', flush = TRUE)
                # Convert name to lower case
                name <- tolower(name)
                # Fix Capitalization inconsistency
                name <- R.utils::capitalize(name)
                # remove extra white space
                name <- gsub('\\s+', ' ', name)
                # remove white space from the beginning and end of the popular name
                name <- gsub('^\\s|\\s$', '', name)
                # Convert 'white space' to '-'
                name <- gsub(' ', '-', name)
                
                # Set a dataframe
                output <- sistaxon %>%
                        filter(NomePopular == name)
                
                # Checks if the dataframe has at least 1 row and most 15 rows
                if (nrow(output) & nrow(output) <= 15) {
                        return(head(output, 15))
                }
                # Checks if the dataframe has more than 15 row
                else if (nrow(output) & nrow(output) > 15) {
                        # Show message on user's screen
                        cat('Sua busca retornou mais de 15 registros.\n
                            Estamos abrindo uma aba com os dados!')
                        # Sets a 2 seconds pause
                        Sys.sleep(2)
                        # Pop-up a viewer of the dataframe
                        return(View(output))
                }
                else {
                        # Show message on user's screen
                        cat('Nome não consta no SISTAXON.')
                }
        }
        
        ## Serach by genus
        else if (type == 2) {
                # Show message on user's screen
                cat('Digite o Gênero\n')
                # get the scientific name form console's user
                name <- scan(what = 'character', n = 1, encoding = 'latin1', flush = TRUE)
                # Convert name to lower case
                name <- tolower(name)
                # Fix Capitalization inconsistency
                name <- R.utils::capitalize(name)
                # remove extra white space
                name <- gsub('\\s+', ' ', name)
                # remove white space from the beginning and end of genus
                name <- gsub('^\\s|\\s$', '', name)
                
                # Set a dataframe
                output <- sistaxon %>%
                        filter(grepl('^Vouacapoua', NomeCientifico))
                
                if (nrow(output) & nrow(output) <= 15) {
                        return(head(output, 15))
                                
                }
                # Checks if the dataframe has more than 15 row
                else if (nrow(output) & nrow(output) > 15) {
                        # Show message on user's screen
                        cat('Sua busca retornou mais de 15 registros.\n
                            Estamos abrindo uma aba com os dados!')
                        # Sets a 2 seconds pause
                        Sys.sleep(2)
                        # Pop-up a viewer of the dataframe
                        return(View(output))
                }

                else {
                        # Show message on user's screen
                        cat('Gênero não consta no SISTAXON.') 
                }
        }
        
        ## Serach by scientific name
        else {
                # Show message on user's screen
                cat('Digite o Nome Científico (ex.: Cedrela odorata\n')
                # get the scientific name form console's user
                name <- scan(what = 'character', n = 1, encoding = 'latin1', flush = TRUE)
                # Convert name to lower case
                name <- tolower(name)
                # Fix Capitalization inconsistency
                name <- R.utils::capitalize(name)
                # remove extra white space between genus and epithet
                name <- gsub('\\s+', ' ', name)
                # remove white space from the beginning and end of the scientific names
                name <- gsub('^\\s|\\s$', '', name)
                
                # Set a dataframe
                output <- sistaxon %>%
                        filter(NomeCientifico == 'Vouacapoua americana')
                
                if (nrow(output) & nrow(output) <= 15) {
                        return(head(output, 15))
                }  
                # Checks if the dataframe has more than 15 row
                else if (nrow(output) & nrow(output) > 15) {
                        # Show message on user's screen
                        cat('Sua busca retornou mais de 15 registros.\n
                            Estamos abrindo uma aba com os dados!')
                        # Sets a 2 seconds pause
                        Sys.sleep(2)
                        # Pop-up a viewer of the dataframe 
                        return(View(output))
                }
                else {
                        # Show message on user's screen
                        cat('Espécie não consta no SISTAXON.')
                }
        }
}

## Call for the query_sistaxon() function
query_sistaxon()
