# Paquetes ----
library(tidyverse)

# Datos ----
d <- read_csv(
  "datos/observations-376080.csv.zip",
  col_types = cols(
    observed_on_string = col_skip(),
    observed_on = col_skip(),
    time_observed_at = col_datetime(format = "%Y-%m-%d %H:%M:%S UTC"),
    image_url = col_skip(), sound_url = col_skip()
  )
)

cnts <- d %>%
  group_by(iconic_taxon_name) %>%
  summarise(n = n(),
            S = n_distinct(scientific_name)) %>%
  arrange(desc(S), desc(n))

# Primer intento
ggplot(cnts) +
  aes(iconic_taxon_name, S) +
  geom_col()

# Orden alfabético!

# El orden de los factores ----

# Factor:
factor(cnts$iconic_taxon_name,
       levels = cnts$iconic_taxon_name)

# Ver los "Levels"! (están en el orden que queremos...)

cnts$iconic_taxon_name <- factor(cnts$iconic_taxon_name,
                                 levels = cnts$iconic_taxon_name)

ggplot(cnts) +
  aes(iconic_taxon_name, S) +
  geom_col()


# Acomodar el plot:
ggplot(cnts) +
  aes(iconic_taxon_name, S) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = rev)

# rev???
?rev

# O sea, que "limits" (el argumento de scale_x_discrete) puede ser una
# función...
?scale_x_discrete

# "limits"
#
# One of:
#
# NULL to use the default scale values
#
# A character vector that defines possible values of the scale and their order
#
# A function that accepts the existing (automatic) values and returns new ones.
# Also accepts rlang lambda function notation.


#

ggplot(cnts) +
  aes(iconic_taxon_name, S) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = rev) +
  xlab("")

cnts$grupo_animal <- c("No Animal", "Vertebrados", "Invertebrados",
                       "Invertebrados", "Vertebrados", "Vertebrados",
                       "Vertebrados", "No Animal", "Vertebrados",
                       "Invertebrados")

ggplot(cnts) +
  aes(iconic_taxon_name, S, fill = grupo_animal) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = rev) +
  xlab("")
