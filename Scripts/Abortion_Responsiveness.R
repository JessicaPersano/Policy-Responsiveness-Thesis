# ==========================================
# Abortion Policy Analysis: Responsiveness
# ========================================== 

# Load required libraries
library(tidyverse)
library(ggplot2)

# Step 1: Load Abortion Data
abortion_data <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_merged_data.csv") 

# Step 2: Run Logistic Regression for Responsiveness
responsiveness_model <- glm(policy_score ~ estimated_opinion, 
                            data = abortion_data, 
                            family = binomial(link = "logit"))
responsiveness_results <- summary(responsiveness_model)
responsiveness_summary <- data.frame(summary(responsiveness_model)$coefficients)

# Save Responsiveness Results
write_csv(responsiveness_summary, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_responsiveness_results.csv")

# Step 3: Print Results
print(responsiveness_results)

# Step 4: Visualizations

# Load library for better fonts (optional)
library(ggthemes)  

# Theme customization for all plots
custom_theme <- theme_minimal(base_family = "serif") +
  theme(
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90"),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 13, face = "italic"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Responsiveness Scatter Plot with 95% CI
ggplot(abortion_data, aes(x = estimated_opinion, y = policy_score)) +  
  geom_jitter(width = 0.05, height = 0.05, alpha = 0.6, color = "blue") +  
  geom_smooth(
    method = "glm",
    method.args = list(family = "binomial"),
    se = TRUE,                           # Enable 95% confidence intervals
    color = "red",
    fill = "pink",                      
    alpha = 0.2                         
  ) +
  labs(
    title = "Policy Responsiveness: Abortion",
    subtitle = paste("N =", nrow(abortion_data), "U.S. states"),
    x = "Public Opinion on Abortion (0 = Conservative, 1 = Liberal)",
    y = "Abortion Policy Score (0 = Conservative, 1 = Liberal)"
  ) +
  custom_theme

# Save the Responsiveness Scatter Plot
ggsave("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_responsiveness_plot.png", width = 8, height = 6)
