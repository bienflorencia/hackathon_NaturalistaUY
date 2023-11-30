
library(httr)
library(jsonlite)
library(tidyverse)

getiNatObservations <- function(project_id){
  
  total_results = NULL
  page = 1 
  delay = 1.0
  results = tibble()
  
  while(is.null(total_results) || nrow(results) < total_results) {
    
    call_url <- str_glue('https://api.inaturalist.org/v1/observations?',
                         'project_id={project_id}',
                         '&per_page=200&page={page}')
    
    get_json_call <- GET(url = call_url) %>% 
      content(as = "text") %>% fromJSON(flatten = TRUE)
    
    if (!is.null(get_json_call)) {
      if (is.null(total_results)) {
        total_results <- get_json_call$total_results # number of results of the call
      }
      results_i <- as_tibble(get_json_call$results) %>% 
        select(taxon_name=taxon.name, taxon_rank=taxon.rank, identifications_count, 
               created_at, observed_on, class, order, family, 
               captive, quality_grade,
               geojson.coordinates, positional_accuracy, obscured,
               user_login=user.login, user_id=user.id, user_name=user.name, 
               user_observations_count=user.observations_count,
               license_code, num_identification_agreements, uri) %>%
        unnest_wider(geojson.coordinates, names_sep = "_") %>%
        rename(longitude=geojson.coordinates_1, latitude=geojson.coordinates_2)
      results <- rbind(results, results_i)
      page <- page + 1
      Sys.sleep(delay)
    }
  }
  return(results)
}


datos_GBS22 <- getiNatObservations(project_id='gbs-2022-uruguay')

