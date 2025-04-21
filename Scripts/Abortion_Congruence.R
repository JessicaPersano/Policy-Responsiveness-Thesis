# ==========================================
# Abortion Policy Analysis: Congruence
# ========================================== 

# Load required libraries
library(tidyverse)
library(ggplot2)

# Step 1: Load Abortion Data
abortion_data <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_merged_data.csv") 

# Step 2: Define Congruence for Binary Opinion Scale
abortion_data <- abortion_data %>%
  mutate(
    congruence = ifelse(
      (estimated_opinion >= 0.5 & policy_score == 1) | 
        (estimated_opinion < 0.5 & policy_score == 0), 
      1, 0
    ),
    policy_score = factor(policy_score, levels = c(0, 1), labels = c("Conservative", "Liberal"))
  )

# Step 3: Calculate Overall Congruence Rate
overall_congruence <- mean(abortion_data$congruence, na.rm = TRUE)

# Step 4: Calculate State-Level Congruence
state_congruence <- abortion_data %>%
  group_by(state) %>%
  summarize(congruence_rate = mean(congruence, na.rm = TRUE))

# Step 4.5: Add Overall Congruence Rate as a Row
overall_row <- tibble(state = "Overall", congruence_rate = overall_congruence)
state_congruence_combined <- bind_rows(state_congruence, overall_row)

# Save Combined Congruence Rates to CSV
write_csv(state_congruence_combined, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_state_congruence.csv")

# Step 5: Print Results
print(paste("Overall Congruence Rate for Abortion:", round(overall_congruence, 3)))
print(state_congruence_combined)

# Step 6: Visualizations

# Load library for better fonts (optional)
library(ggthemes)  

# Theme customization for all plots
custom_theme <- theme_minimal(base_family = "serif") + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  
    axis.title = element_text(size = 14),  
    axis.text = element_text(size = 12)  
  )

# Congruence Bar Chart (Overall)
ggplot(data.frame(policy_topic = "Abortion", congruence_rate = overall_congruence), 
       aes(x = policy_topic, y = congruence_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    title = "Overall Congruence Rate for Abortion Policy",
    x = "Policy Topic",
    y = "Congruence Rate"
  ) +
  custom_theme

# Save the Overall Congruence Bar Chart
ggsave("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_congruence_plot.png", width = 7, height = 5)

# State-Level Congruence Plot
ggplot(state_congruence, aes(x = reorder(state, congruence_rate), y = congruence_rate)) +
  geom_bar(stat = "identity", fill = "darkblue") +
  coord_flip() +
  labs(
    title = "Congruence Rate by State for Abortion Policy",
    x = "State",
    y = "Congruence Rate"
  ) +
  custom_theme

# Save the State-Level Congruence Plot
ggsave("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_state_congruence_plot.png", width = 8, height = 6)

