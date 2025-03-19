# ==========================================
# Abortion Policy Analysis: Responsiveness
# ========================================== 

# Load required libraries
library(tidyverse)
library(ggplot2)

# Step 1: Load Abortion Data
abortion_data <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/merged_abortion_data.csv") 

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
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  
    axis.title = element_text(size = 14),  
    axis.text = element_text(size = 12)  
  )

# Responsiveness Scatter Plot
ggplot(abortion_data, aes(x = estimated_opinion, y = policy_score)) +  # <- Added closing parenthesis
  geom_jitter(width = 0.02, alpha = 0.6, color = "blue") +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE, color = "red") +
  labs(
    title = "Policy Responsiveness: Abortion",
    x = "Public Opinion on Abortion (0 = Never Permitted, 3 = Always Allowed)",
    y = "Policy Score (0 = Conservative, 1 = Liberal)"
  ) +
  custom_theme

# Save the Responsiveness Scatter Plot
ggsave("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results/abortion_responsiveness_plot.png", width = 8, height = 6)
