# INFERENTIAL

# Load libraries
library(readxl)   # For reading Excel spreadsheet files
library(dplyr)    # For data manipulation (filtering, mutating, etc.)

# === Load and Filter Ix Kuku’il Data ===
ix_data <- read_excel("MOESM14.xlsx") %>%             # Load data from Excel file for Ix Kuku’il
  mutate(fnd = toupper(fnd)) %>%                      # Convert the 'fnd' (chronological phase) column to uppercase for consistency
  filter(fnd %in% c("LPC", "EC", "LC"))               # Keep only Late Preclassic (LPC), Early Classic (EC), and Late Classic (LC)

# === Run Kruskal-Wallis Tests for Ix Kuku’il ===
kw_ix <- data.frame(                                  # Create a data frame to store test results for Ix Kuku’il
  Variable = c("Number of structures",                # List of variables to test
               "Total area of structures",
               "Plazuela area",
               "Distance to water",
               "Zonal slope"),
  
  `Ix Kuku’il p-value` = c(                           # Run Kruskal-Wallis test for each variable and store the p-value
    kruskal.test(strs ~ fnd, data = ix_data)$p.value,         # Test for number of structures by phase
    kruskal.test(str_area ~ fnd, data = ix_data)$p.value,     # Test for structure area by phase
    kruskal.test(area ~ fnd, data = ix_data)$p.value,         # Test for plazuela area by phase
    kruskal.test(h20 ~ fnd, data = ix_data)$p.value,          # Test for distance to water by phase
    kruskal.test(zonal_slope ~ fnd, data = ix_data)$p.value   # Test for slope by phase
  )
)

# === Load and Filter Uxbenká Data ===
ux_data <- read_excel("MOESM13.xlsx") %>%             # Load data from Excel file for Uxbenká
  mutate(fnd = toupper(fnd)) %>%                      # Standardize 'fnd' column by converting to uppercase
  filter(fnd %in% c("LPC", "EC", "LC"))               # Keep the same chronological periods as for Ix Kuku’il

# === Run Kruskal-Wallis Tests for Uxbenká and Store p-values ===
kw_ux <- c(                                           # Create a vector of p-values for Uxbenká
  kruskal.test(strs ~ fnd, data = ux_data)$p.value,           # Number of structures by phase
  kruskal.test(str_area ~ fnd, data = ux_data)$p.value,       # Structure area by phase
  kruskal.test(area ~ fnd, data = ux_data)$p.value,           # Plazuela area by phase
  kruskal.test(h20 ~ fnd, data = ux_data)$p.value,            # Distance to water by phase
  kruskal.test(zonal_slope ~ fnd, data = ux_data)$p.value     # Slope by phase
)

# === Combine Ix Kuku’il and Uxbenká p-values into One Table ===
kw_table <- kw_ix %>%                                # Start with Ix Kuku’il results table
  mutate(`Uxbenká p-value` = kw_ux)                  # Add a new column for Uxbenká p-values

# === Print Table to Console ===
print(kw_table)                                       # Print the p-value table to the R console

# === Optional: Display as a Formatted Table Using knitr ===
library(knitr)                                        # Load knitr for table formatting
kable(kw_table, digits = 4,                           # Format table with 4 decimal places
      caption = "Table 6: Kruskal-Wallis p-values for Ix Kuku’il and Uxbenká")  # Add caption for table
