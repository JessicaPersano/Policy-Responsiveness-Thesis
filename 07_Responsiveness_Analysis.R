# ==========================================
# Policy Responsiveness Analysis
# ==========================================
# This script performs logistic regression to measure policy responsiveness 
# and generates visualizations.
# Modify the policy name and file paths as needed.
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
# 2. Run Logistic Regression for Responsiveness
# ==========================================

# 🔹 Fit a logistic regression model
responsiveness_model <- glm(policy_score ~ estimated_opinion, 
                            data = policy_data, 
                            family = binomial(link = "logit"))

# 🔹 Extract and summarize model results
responsiveness_results <- summary(responsiveness_model)
responsiveness_summary <- data.frame(responsiveness_results$coefficients)

# ==========================================
# 3. Save Results
# ==========================================

# 🔹 Save Responsiveness Results to CSV
write_csv(responsiveness_summary, paste0(output_path, policy_name, "_responsiveness_results.csv"))

# ==========================================
# 4. Print Results
# ==========================================

print(paste("Responsiveness Analysis for", policy_name))
print(responsiveness_results)

# ==========================================
# 5. Visualizations
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

# 🔹 Responsiveness Scatter Plot
ggplot(policy_data, aes(x = estimated_opinion, y = policy_score)) +
  geom_jitter(width = 0.02, alpha = 0.6, color = "blue") +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE, color = "red") +
  labs(
    title = paste("Policy Responsiveness:", policy_name),
    x = paste("Public Opinion on", policy_name),
    y = "Policy Score (0 = Conservative, 1 = Liberal)"
  ) +
  custom_theme

# 🔹 Save the Responsiveness Scatter Plot
ggsave(paste0(output_path, policy_name, "_responsiveness_plot.png"), width = 8, height = 6)
