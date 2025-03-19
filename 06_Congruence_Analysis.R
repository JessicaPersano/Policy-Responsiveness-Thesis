# ==========================================
# Policy Congruence Analysis
# ==========================================
# This script calculates and visualizes policy congruence for a given policy topic.
# Modify the policy name, congruence threshold, and file paths as needed.
# ==========================================

# Load required libraries
library(tidyverse)
library(ggplot2)

# ==========================================
# 1. Load Data
# ==========================================

# 🔹 Define the policy topic (Change this based on the analysis)
policy_name <- "Policy_Name_Here"  # Example: "Abortion", "Gun Control", etc.

# 🔹 Define file paths (Modify as needed)
data_path <- "path/to/merged_policy_data.csv"  # Replace with actual file path
output_path <- "path/to/results/"

# 🔹 Load the merged dataset for the selected policy
policy_data <- read_csv(data_path) 

# ==========================================
# 2. Define Congruence (Modify Threshold as Needed)
# ==========================================

congruence_threshold <- 1.5  # Modify based on policy topic

policy_data <- policy_data %>%
  mutate(
    congruence = ifelse(
      (estimated_opinion >= congruence_threshold & policy_score == 1) | 
        (estimated_opinion < congruence_threshold & policy_score == 0), 
      1, 0
    ),
    policy_score = factor(policy_score, levels = c(0, 1), labels = c("Conservative", "Liberal"))
  )

# ==========================================
# 3. Calculate Congruence Rates
# ==========================================

# 🔹 Overall Congruence Rate
overall_congruence <- mean(policy_data$congruence, na.rm = TRUE)

# 🔹 State-Level Congruence
state_congruence <- policy_data %>%
  group_by(state) %>%
  summarize(congruence_rate = mean(congruence, na.rm = TRUE))

# ==========================================
# 4. Save Results
# ==========================================

# 🔹 Save State-Level Congruence to CSV
write_csv(state_congruence, paste0(output_path, policy_name, "_state_congruence.csv"))

# ==========================================
# 5. Print Results
# ==========================================

print(paste("Overall Congruence Rate for", policy_name, ":", round(overall_congruence, 3)))
print(state_congruence)

# ==========================================
# 6. Visualizations
# ==========================================

# Load library for better fonts (optional)
library(ggthemes)  

# 🔹 Custom Theme for All Plots
custom_theme <- theme_minimal(base_family = "serif") + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  
    axis.title = element_text(size = 14),  
    axis.text = element_text(size = 12)  
  )

# 🔹 Overall Congruence Bar Chart
ggplot(data.frame(policy_topic = policy_name, congruence_rate = overall_congruence), 
       aes(x = policy_topic, y = congruence_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    title = paste("Overall Congruence Rate for", policy_name, "Policy"),
    x = "Policy Topic",
    y = "Congruence Rate"
  ) +
  custom_theme

# 🔹 Save Overall Congruence Chart
ggsave(paste0(output_path, policy_name, "_congruence_plot.png"), width = 7, height = 5)

# 🔹 State-Level Congruence Bar Chart
ggplot(state_congruence, aes(x = reorder(state, congruence_rate), y = congruence_rate)) +
  geom_bar(stat = "identity", fill = "darkblue") +
  coord_flip() +
  labs(
    title = paste("Congruence Rate by State for", policy_name, "Policy"),
    x = "State",
    y = "Congruence Rate"
  ) +
  custom_theme

# 🔹 Save State-Level Congruence Chart
ggsave(paste0(output_path, policy_name, "_state_congruence_plot.png"), width = 8, height = 6)
