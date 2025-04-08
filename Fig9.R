#DESCRIPTIVE AND INFERENTIAL

# === Load Required Libraries ===
library(readxl)    # For reading Excel files
library(ggplot2)   # For creating plots and visualizations
library(dplyr)     # For data manipulation (filtering, mutating, etc.)
library(tidyr)     # For reshaping data (e.g., pivoting)

# === Load and Clean the Data ===
ix_data <- read_excel("MOESM14.xlsx")  # Load Excel spreadsheet containing raw data (ensure correct file path)

# Process and clean the data for plotting
ix_clean <- ix_data |>
  mutate(fnd = toupper(fnd)) |>                        # Convert the 'fnd' column (time periods) to uppercase for consistency
  filter(fnd %in% c("EC", "LC")) |>                    # Keep only Early Classic (EC) and Late Classic (LC) periods
  select(fnd,                                          # Select only the relevant variables needed for analysis
         Number_of_Structures = strs,                  # Rename 'strs' to 'Number_of_Structures'
         Structure_Area = str_area,                    # Rename 'str_area' to 'Structure_Area'
         Plazuela_Area = area,                         # Rename 'area' to 'Plazuela_Area'
         Distance_to_Water = h20,                      # Rename 'h20' to 'Distance_to_Water'
         Slope = zonal_slope)                          # Rename 'zonal_slope' to 'Slope'

# Reshape data from wide format to long format to prepare for faceted plotting
ix_long <- ix_clean |>
  pivot_longer(cols = -fnd,                            # Keep 'fnd' as the identifier column
               names_to = "Variable",                  # Combine all other columns into a new column called 'Variable'
               values_to = "Value")                    # The values from each variable go into a new column called 'Value'

# Set the order of variables to control their display order in plots
ix_long$Variable <- factor(ix_long$Variable,
                           levels = c("Number_of_Structures",
                                      "Structure_Area",
                                      "Plazuela_Area",
                                      "Distance_to_Water",
                                      "Slope"))

# === Create Human-Readable Labels for Y-Axis Facets ===
pretty_labels <- c(
  "Number_of_Structures" = "Number of Structures",
  "Structure_Area" = expression("Structure Area (m"^2*")"),          # Add units and use mathematical notation
  "Plazuela_Area" = expression("Plazuela Area (m"^2*")"),            # Same as above for Plazuela area
  "Distance_to_Water" = expression("Distance to water (m)"),         # Show that distance is in meters
  "Slope" = "Slope (degrees)"                                        # Indicate slope is measured in degrees
)

# === Ensure Variable column matches pretty label keys ===
ix_long$Variable <- factor(ix_long$Variable, levels = names(pretty_labels))

# === LEFT PANEL: Scatter (Jitter) Plot with Mean and Error Bars ===
p_left <- ggplot(ix_long, aes(x = fnd, y = Value)) +                 # Begin plotting: x = time period, y = value of variable
  geom_jitter(width = 0.1, alpha = 0.7, size = 1.5) +                 # Add individual data points with slight horizontal jitter for visibility
  stat_summary(fun = mean, geom = "point", size = 3, color = "black") +  # Overlay black dots showing the mean of each group
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +     # Add error bars showing standard error around mean
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "gray30") +  # Connect group means with a gray line
  facet_grid(rows = vars(Variable), switch = "y", scales = "free_y",         # Create vertical panels per variable
             labeller = labeller(Variable = pretty_labels)) +               # Use custom axis labels for each variable
  labs(x = expression(italic("Time")), y = NULL) +                          # Label x-axis as "Time" in italics; no y-axis label
  theme_classic(base_size = 14) +                                           # Apply a clean minimal theme
  theme(
    strip.placement = "outside",                                            # Move facet labels outside the plot
    strip.text.y.left = element_text(angle = 0, hjust = 1),                 # Make y-strip text horizontal and left-justified
    strip.background = element_blank()                                      # Remove background shading behind facet labels
  )

# === RIGHT PANEL: Transparent Boxplots Showing Distribution ===
p_right <- ggplot(ix_long, aes(x = fnd, y = Value)) +                # Same structure as left panel
  geom_boxplot(outlier.shape = 16, outlier.size = 2, width = 0.5,    # Draw boxplots, show outliers as small circles
               aes(color = fnd), fill = NA) +                        # Outline colored by time period, but box fill left transparent
  facet_grid(rows = vars(Variable), switch = "y", scales = "free_y",# Facet same as left panel
             labeller = labeller(Variable = pretty_labels)) +       
  labs(x = expression(italic("Time")), y = NULL) +                   # X-axis labeled "Time" in italics
  scale_color_manual(values = c("EC" = "skyblue", "LC" = "orange")) +# Set custom colors for EC and LC
  theme_classic(base_size = 14) +                                    # Apply classic theme for clean look
  theme(
    strip.placement = "outside",                                     # Move facet labels outside the plot
    strip.text.y.left = element_text(angle = 0, hjust = 1),          # Make y-strip text horizontal and left-justified
    strip.background = element_blank(),                              # Remove box around strip labels
    legend.position = "none"                                         # Hide legend (time period already shown on x-axis)
  )

# === Combine Both Plots Side-by-Side Using Patchwork Layout ===
final_plot <- p_left + p_right +                                    # Place left and right plots side by side
  plot_layout(ncol = 2, widths = c(1, 1)) &                          # Define layout with equal width columns
  theme(plot.margin = margin(5, 5, 5, 5))                            # Add consistent padding around entire figure

# === Display the Final Combined Figure ===
final_plot

# === OPTIONAL: Save Plot to File ===
# ggsave("Figure9_Recreation.png", final_plot, width = 10, height = 8, dpi = 300) 
# (Uncomment above line to save the figure as a high-resolution PNG)
