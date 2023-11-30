# Paquetes -----
library(tidyverse)

# Datos -------
d <- read_csv(
  "data/observations-376080.csv.zip",
  col_types = cols(
    observed_on_string = col_skip(),
    observed_on = col_skip(),
    time_observed_at = col_datetime(format = "%Y-%m-%d %H:%M:%S UTC"),
    image_url = col_skip(), sound_url = col_skip()
  )
)

# Explicación de las columnas:
# https://www.naturalista.uy/observations/export
# Con poner el mouse sobre el nombre del campo aparece una explicación sencilla

# Mi exportación 14/11
# https://www.naturalista.uy/observations/export?flow_task_id=376080

names(d)
head(d, 2)
summary(d)
str(d)

# Conteo -----
?count
# count(x, ..., wt = NULL, sort = FALSE, name = NULL)

# Ejemplo: "..." = iconic_taxon_name
count(d, iconic_taxon_name) # Sin comillas!


## TUBO / PIPE ----

# Lo mismo, pero con el "tubo" (pipe)...
d %>%
  count(iconic_taxon_name)



# NO SUBESTIMEN EL PODER DE LOS ATAJOS!

# %>%  =  Ctrl+Shift+M


# Para qué queremos el tubo? Para enganchar sentencias de a una... facilita a ir
# construyendo el código de manera más o menos harmónica con el proceso mental:

# Ahora quiero ordenar de menos a más:
d %>%
  count(iconic_taxon_name) %>%
  arrange(n)

# O al revés:
d %>%
  count(iconic_taxon_name) %>%
  arrange(desc(n))


# Group BY ------

# Ahora, el count es muy bueno si la cuenta que queremos sacar es exactamente
# esa...

# Pero puede que querramos hacer otras cosas. Para esto están group_by y
# summarise.

# group_by determina qué columnas ofician de etiquetas para agrupar
# summarise indica qué cuentas vamos a hacer

# La cuenta anterior, se puede hacer, idéntica, así:
d %>%
  group_by(iconic_taxon_name) %>%
  summarise(n = n())

# Con n_distinct podemos agregar un conteo de especies, por ejemplo:
d %>%
  group_by(iconic_taxon_name) %>%
  summarise(n = n(),
            S = n_distinct(scientific_name)) %>%
  arrange(desc(S), desc(n))

# Avanzado! -----

# Cuál es la especie más representada?

## Spp frecuente ------

spp <- c("Spp.B", "Spp.A", "Spp.B")
table(spp)
table(spp) %>% sort(decreasing = TRUE)
spp_ordenada <- table(spp) %>% sort(decreasing = TRUE)
spp_top <- names(spp_ordenada)[1]

## Una funcioncita ------
get_spp_top <- function(spp) {
  spp_ordenada <- table(spp) %>% sort(decreasing = TRUE)
  spp_top <- names(spp_ordenada)[1]
  return(spp_top)
}

# Comprobar que funciona:
get_spp_top(spp) # Spp.B
get_spp_top(c("Spp.B", "Spp.A", "Spp.A")) # Spp.A

# Función + Group BY -----

# Ahora, imaginemos que nos interesa contar la cantidad de especies diferentes
d %>%
  group_by(iconic_taxon_name) %>%
  summarise(n = n(),
            S = n_distinct(scientific_name),
            Top = get_spp_top(scientific_name)) %>%
  arrange(desc(S), desc(n))



