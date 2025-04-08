# Load libraries
library(readxl)
library(dplyr)

# Load Ix Kuku’il data
ix_data <- read_excel("MOESM14.xlsx") %>%
  mutate(fnd = toupper(fnd)) %>%
  filter(fnd %in% c("LPC", "EC", "LC"))

# Run Kruskal-Wallis tests and extract p-values
kw_ix <- data.frame(
  Variable = c("Number of structures",
               "Total area of structures",
               "Plazuela area",
               "Distance to water",
               "Zonal slope"),
  
  `Ix Kuku’il p-value` = c(
    kruskal.test(strs ~ fnd, data = ix_data)$p.value,
    kruskal.test(str_area ~ fnd, data = ix_data)$p.value,
    kruskal.test(area ~ fnd, data = ix_data)$p.value,
    kruskal.test(h20 ~ fnd, data = ix_data)$p.value,
    kruskal.test(zonal_slope ~ fnd, data = ix_data)$p.value
  )
)

ux_data <- read_excel("MOESM13.xlsx") %>%
  mutate(fnd = toupper(fnd)) %>%
  filter(fnd %in% c("LPC", "EC", "LC"))

# Uxbenká Kruskal-Wallis p-values
kw_ux <- c(
  kruskal.test(strs ~ fnd, data = ux_data)$p.value,
  kruskal.test(str_area ~ fnd, data = ux_data)$p.value,
  kruskal.test(area ~ fnd, data = ux_data)$p.value,
  kruskal.test(h20 ~ fnd, data = ux_data)$p.value,
  kruskal.test(zonal_slope ~ fnd, data = ux_data)$p.value
)


kw_table <- kw_ix %>%
  mutate(`Uxbenká p-value` = kw_ux)

# View table
print(kw_table)



# Or use knitr::kable for a clean printable table
library(knitr)
kable(kw_table, digits = 4, caption = "Table 6: Kruskal-Wallis p-values for Ix Kuku’il and Uxbenká")

