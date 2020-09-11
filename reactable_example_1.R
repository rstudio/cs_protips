library(reactable)
library(palmerpenguins)
library(dplyr)
library(sparklines)

# Let's begin by building a fun dataset to use: the Palmer Penguins
tux <- penguins %>% 
  select(species, sex, body_mass_g, flipper_length_mm) %>% 
  rename(Species = species, Sex = sex, Mass = body_mass_g, Flippers = flipper_length_mm) %>%
  filter(complete.cases(.))
tux
# Now let's use reactable to that table and give it superpowers
reactable(tux)

# First, let's use our new powers to control the aeshetics of how the table looks
reactable(tux, 
  borderless = TRUE,
  highlight = TRUE,
  fullWidth = FALSE,
  resizable = TRUE,
  defaultColDef = colDef(
    align = "center",
    headerStyle = list(background = "lightgray")),
  columns = list(
    Species = colDef(minWidth = 180)
  ),
)

# Second, let's use reactable to explore the data make the table... react-able: sortable, searchable, filterable, conditional formatting, summary stats
reactable(tux, 
  defaultSorted = c("Mass"),
  filterable = TRUE,
  searchable = TRUE,
  borderless = TRUE,
  highlight = TRUE,
  resizable = TRUE,
  defaultColDef = colDef(
    align = "center",
    headerStyle = list(background = "lightgray")),
  columns = list(
    Species = colDef(minWidth = 140, footer="Mean"),
    Flippers = colDef(style=function(value) {
      if (value > 190) clr <- "red" else clr <- "black"
      list(color=clr, fontWeight="bold") },
      footer = function(value) sprintf("%.0f", mean(value, na.rm=TRUE)))
  )
)

# Third, let's group rows
reactable(tux, groupBy = "Species",
  columns = list(
    Flippers = colDef(aggregate = "mean", format = colFormat(suffix = " mm", digits = 0)),
    Mass = colDef(aggregate = "mean", format = colFormat(suffix = " g", digits =0)),
    Sex = colDef(aggregate = "frequency")),
  borderless = TRUE,
  highlight = TRUE,
  defaultColDef = colDef(
    align = "center",
    headerStyle = list(background = "lightgray"),
    footer = function(values) {
      if (!is.numeric(values)) return()
      sparkline(values, chart_type = "box") }
    )
)

# Lastly, how can we scale this? As in ggplot, we can create a theme to apply to all our reactables so that way we declare the aesthetics once then we're done
# themes, e.g. dark,
options(reactable.theme = reactableTheme(
  color = "hsl(233, 9%, 87%)",
  backgroundColor = "hsl(233, 9%, 19%)",
  borderColor = "hsl(233, 9%, 22%)",
  stripedColor = "hsl(233, 12%, 22%)",
  highlightColor = "hsl(233, 12%, 24%)",
  inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
))
# Let's use our dark theme
reactable(tux, 
  borderless = TRUE,
  highlight = TRUE,
  defaultColDef = colDef(
    align = "center"),
  columns = list(
    Species = colDef(minWidth = 180)
  ),
)
# Now let's go back to the defaults, 
options(reactable.theme = NULL)
reactable(tux, 
  borderless = TRUE,
  highlight = TRUE,
  fullWidth = FALSE,
  defaultColDef = colDef(
    align = "center"),
  columns = list(
    Species = colDef(minWidth = 180)
  ),
)
