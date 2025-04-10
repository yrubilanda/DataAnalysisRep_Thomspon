# DESCRIPTIVE

# Load required libraries
library(readxl)       # For reading Excel files
library(dplyr)        # For data manipulation (filtering, mutating, etc.)
library(ggplot2)      # For creating visualizations
library(patchwork)    # For combining multiple ggplot plots into a single layout

# === 1. Load Uxbenká and Ix Kuku’il data ===
uxb <- read_excel("MOESM13.xlsx") %>%         # Load Uxbenká data from Excel file
  mutate(site = "UXB")                         # Add a new column 'site' to identify this as Uxbenká

ikk <- read_excel("MOESM14.xlsx") %>%         # Load Ix Kuku’il data from Excel file
  mutate(site = "IKK")                         # Add a new column 'site' to identify this as Ix Kuku’il

# Combine the two datasets and create grouping labels
data <- bind_rows(uxb, ikk) %>%                # Merge the two datasets into one
  mutate(
    fnd = toupper(fnd),                        # Standardize time period column to uppercase
    site_fnd = paste(site, fnd)                # Create a combined label of site and time (e.g., IKK EC)
  )

# Recode bedrock codes into labeled, ordered factor with 'mudstone' first
bedrock_lut <- c("1" = "mudstone", "2" = "mixed")  # Define lookup table for bedrock codes

data <- data %>%
  mutate(
    bedrock_label = factor(bedrock_lut[as.character(bedrock2)],   # Apply lookup table to create readable labels
                           levels = c("mixed", "mudstone")),      # Set display order of factor levels
    erosion = as.factor(erosion),                                 # Convert erosion values to categorical
    soil_s = as.factor(soil_s)                                    # Convert soil classification codes to categorical
  )

# === 2. Panel A: Bedrock Frequencies ===
p1 <- data %>%
  filter(!is.na(bedrock_label)) %>%             # Exclude missing bedrock values
  count(site_fnd, bedrock_label) %>%            # Count frequency of each bedrock type by site and time
  ggplot(aes(x = site_fnd, y = n, fill = bedrock_label)) +  # Start plot: x = site/time, y = count, fill = bedrock type
  geom_col(position = "dodge", width = 0.7, color = "black") +  # Create side-by-side bar chart with outlined bars
  scale_fill_manual(values = c("mudstone" = "grey70", "mixed" = "steelblue")) +  # Custom colors for bedrock types
  labs(title = "Bedrock Frequencies", x = NULL, y = "Number of Occurrences", fill = NULL) +  # Add labels and remove x/fill titles
  theme_minimal(base_size = 13) +               # Use minimal theme with base font size 13
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Tilt x-axis labels for readability

# === 3. Panel B: Soil Classification Frequencies ===
p2 <- data %>%
  filter(!is.na(soil_s)) %>%                    # Exclude missing soil classification values
  count(site_fnd, soil_s) %>%                   # Count frequency of each soil type by site and time
  ggplot(aes(x = site_fnd, y = n, fill = soil_s)) +  # Plot frequency by site/time and soil class
  geom_col(position = "dodge", width = 0.7, color = "black") +  # Create outlined side-by-side bars
  scale_fill_manual(values = c("25" = "#8B4513",    # Brown for soil class 25
                               "26" = "#FFCC00",    # Yellow for 26
                               "29" = "#6AA121",    # Green for 29
                               "63" = "#FF6600")) + # Orange for 63
  labs(title = "Soil Classification Frequencies", x = NULL, y = "Number of Occurrences", fill = NULL) +  # Add plot labels
  theme_minimal(base_size = 13) +               # Apply minimal theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis text for visibility

# === 4. Panel C: Erosion Frequencies ===
p3 <- data %>%
  filter(!is.na(erosion)) %>%                   # Exclude missing erosion values
  count(site_fnd, erosion) %>%                  # Count number of observations per erosion level by site/time
  ggplot(aes(x = site_fnd, y = n, fill = erosion)) +  # Begin plot with erosion as fill
  geom_col(position = "dodge", width = 0.7, color = "black") +  # Bar plot with black outlines
  scale_fill_manual(values = c("2" = "#7FBF7F",    # Light green for erosion level 2
                               "3" = "#1F78B4",    # Blue for level 3
                               "4" = "#FFD700")) + # Gold for level 4
  labs(title = "Erosion Frequencies", x = NULL, y = "Number of Occurrences", fill = NULL) +  # Set title and axis labels
  theme_minimal(base_size = 13) +               # Use minimal styling
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Angled x-axis labels for clarity

# === 5. Combine all panels ===
final_plot <- (p1 | p2 | p3) +                  # Combine plots side-by-side using patchwork syntax
  plot_annotation(title = "Figure 10: Environmental Characteristics by Site and Time Period")  # Add shared title

# === 6. Show plot ===
final_plot                                       # Display the combined figure
