library(readxl)
library(dplyr)
library(ggplot2)

# === 1. Load the data ===
df <- read_excel("MOESM9.xlsx")
names(df) <- trimws(names(df))

# === 2. Clean and parse dates ===
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
      grepl("CE", DateRaw) ~  as.numeric(gsub(" cal CE", "", DateRaw)),
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(Date), !is.na(Group))

# === 3. Bin dates into 100-year intervals ===
df_binned <- df_clean %>%
  mutate(CenturyBin = floor(Date / 100) * 100) %>%  # e.g., 650 → 600, -350 → -400
  group_by(Group, CenturyBin) %>%
  summarise(Count = n(), .groups = "drop")

# === 4. Plot stacked timeline ===
ggplot(df_binned, aes(x = CenturyBin, y = Count, fill = Group)) +
  geom_col(position = "dodge", width = 90, color = "black") +  # Separate bars per site
  scale_fill_manual(values = c("Ix Kuku’il" = "orange", "Uxbenká" = "skyblue")) +
  labs(title = "Figure 5: Chronology of Settlement Expansion",
       x = "Date (BCE/CE)", y = "Number of Dates") +
  scale_x_continuous(breaks = seq(-1000, 1000, 100), expand = c(0, 0)) +
  theme_minimal(base_size = 14)
