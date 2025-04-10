library(readxl)
library(dplyr)
library(ggplot2)
library(cowplot)

# === Load and clean data ===
df <- read_excel("MOESM9.xlsx")
names(df) <- trimws(names(df))  # Clean column names

df_clean <- df %>%
  mutate(
    Site = trimws(Site),
    Group = case_when(
      Site == "IKK" ~ "Ix Kuku’il",
      Site == "UXB" ~ "Uxbenká",
      TRUE ~ NA_character_
    ),
    DateRaw = `Mean of 2σ date`,
    Date = case_when(
      grepl("BCE", DateRaw) ~ -as.numeric(gsub(" cal BCE", "", DateRaw)),
      grepl("CE", DateRaw) ~ as.numeric(gsub(" cal CE", "", DateRaw)),
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(Date), !is.na(Group))

# === Create separate data frames ===
ikk_data <- df_clean %>% filter(Group == "Ix Kuku’il")
uxb_data <- df_clean %>% filter(Group == "Uxbenká")

# === Create LEFT plot (IKK, orange, y-axis on left) ===
p_left <- ggplot() +
  geom_density(data = ikk_data, aes(x = Date), 
               fill = "orange", alpha = 0.4, color = "darkorange") +
  scale_x_continuous(name = "Modeled Date (BCE/CE)") +
  scale_y_continuous(name = "Density: Ix Kuku’il") +
  theme_minimal(base_size = 14) +
  theme(
    axis.title.y.right = element_blank(),
    axis.text.y.right = element_blank(),
    axis.ticks.y.right = element_blank()
  )

# === Create RIGHT plot (UXB, blue, y-axis on right, no x-axis) ===
p_right <- ggplot() +
  geom_density(data = uxb_data, aes(x = Date), 
               fill = "skyblue", alpha = 0.4, color = "blue4") +
  scale_x_continuous(name = NULL) +  # suppress duplicate x-axis label
  scale_y_continuous(name = "Density: Uxbenká", position = "right") +
  theme_minimal(base_size = 14) +
  theme(
    axis.title.y.left = element_blank(),
    axis.text.y.left = element_blank(),
    axis.ticks.y.left = element_blank(),
    axis.text.x = element_blank(),
    axis.title.x = element_blank()
  )

# === Overlay the two plots using cowplot ===
final_plot <- ggdraw() +
  draw_plot(p_left) +
  draw_plot(p_right)

# === Show it ===
final_plot