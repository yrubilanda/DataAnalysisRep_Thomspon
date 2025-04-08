#Figure 9 script

library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)



# === Load and Clean the Data ===
ix_data <- read_excel("MOESM14.xlsx")  # Adjust file path if needed

# Filter and rename relevant variables
ix_clean <- ix_data |>
  mutate(fnd = toupper(fnd)) |>                        # Standardize time periods
  filter(fnd %in% c("EC", "LC")) |>                    # Keep EC and LC only
  select(fnd,
         Number_of_Structures = strs,
         Structure_Area = str_area,
         Plazuela_Area = area,
         Distance_to_Water = h20,
         Slope = zonal_slope)                          # Select relevant columns

# Pivot to long format for plotting
ix_long <- ix_clean |>
  pivot_longer(cols = -fnd, names_to = "Variable", values_to = "Value")

# Set custom order of facets
ix_long$Variable <- factor(ix_long$Variable,
                           levels = c("Number_of_Structures",
                                      "Structure_Area",
                                      "Plazuela_Area",
                                      "Distance_to_Water",
                                      "Slope"))

# === Define Pretty Labels for the Y Axis ===
pretty_labels <- c(
  "Number_of_Structures" = "Number of Structures",
  "Structure_Area" = expression("Structure Area (m"^2*")"),
  "Plazuela_Area" = expression("Plazuela Area (m"^2*")"),
  "Distance_to_Water" = expression("Distance to water (m)"),
  "Slope" = "Slope (degrees)"
)

# === LEFT PANEL: Jitter + Means + Error Bars ===
p_left <- ggplot(ix_long, aes(x = fnd, y = Value)) +
  geom_jitter(width = 0.1, alpha = 0.7, size = 1.5) +                    # Points
  stat_summary(fun = mean, geom = "point", size = 3, color = "black") + # Means
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +    # SE bars
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "gray30") +  # Line
  facet_grid(rows = vars(Variable), switch = "y", scales = "free_y",
             labeller = labeller(Variable = pretty_labels)) +           # Custom labels
  labs(x = expression(italic("Time")), y = NULL) +                      # Italic x-axis
  theme_classic(base_size = 14) +                                       # Clean theme
  theme(
    strip.placement = "outside",                                        # Move facet labels to left
    strip.text.y.left = element_text(angle = 0, hjust = 1),             # Horizontal facet labels
    strip.background = element_blank()                                  # Remove box around labels
  )

# === RIGHT PANEL: Transparent Boxplots ===
p_right <- ggplot(ix_long, aes(x = fnd, y = Value)) +
  geom_boxplot(outlier.shape = 16, outlier.size = 2, width = 0.5,
               aes(color = fnd), fill = NA) +                           # Transparent box, colored outline
  facet_grid(rows = vars(Variable), switch = "y", scales = "free_y",
             labeller = labeller(Variable = pretty_labels)) +          # Same facet setup
  labs(x = expression(italic("Time")), y = NULL) +
  scale_color_manual(values = c("EC" = "skyblue", "LC" = "orange")) +  # Custom colors
  theme_classic(base_size = 14) +
  theme(
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, hjust = 1),
    strip.background = element_blank(),
    legend.position = "none"                                           # Hide legend
  )

# === Combine Both Panels Side-by-Side ===
final_plot <- p_left + p_right +
  plot_layout(ncol = 2, widths = c(1, 1)) &                            # Side-by-side layout
  theme(plot.margin = margin(5, 5, 5, 5))                             # Outer padding

# === Display Final Output ===
final_plot

# === Optional: Save to File ===
# ggsave("Figure9_Recreation.png", final_plot, width = 10, height = 8, dpi = 300)
