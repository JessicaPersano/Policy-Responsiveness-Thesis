library(dplyr)
library(readr)
library(ggplot2)

# Replace with your actual path
setwd("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results")

# ==========================================
# Congruence Summary Table
# ========================================== 

# List all congruence files in the working directory
congruence_files <- list.files(pattern = "_state_congruence.csv")

# Create summary table using `congruence_rate` instead of nonexistent `congruence`
congruence_summary <- lapply(congruence_files, function(file) {
  data <- read_csv(file)
  
  # Filter out the "Overall" row
  state_data <- data %>% filter(state != "Overall")
  
  # Count how many states had a congruence rate of 1 (i.e., congruent)
  congruent <- sum(state_data$congruence_rate == 1, na.rm = TRUE)
  total <- nrow(state_data)
  policy_name <- gsub("_state_congruence.csv", "", file)
  
  data.frame(
    Policy = policy_name,
    Congruent_States = congruent,
    Total_States = total,
    Percent_Congruent = round(100 * congruent / total, 1),
    Raw_Count = paste0(congruent, "/", total)
  )
}) %>% bind_rows()

write_csv(congruence_summary, "congruence_summary.csv")
print(congruence_summary)

# ==========================================
# Congruence Bar Graph
# ==========================================

# Add policy type manually
congruence_summary$Policy_Type <- c("Moral", "Moral", "Moral", "Moral", 
                                    "Technical", "Technical", "Technical", "Technical")  # match order

# OPTIONAL: Clean up axis labels if needed
congruence_summary$Policy_Label <- c(
  "Abortion",
  "Drug\nSentencing",
  "Paid Family\nLeave",
  "Medicaid\nExpansion",
  "Renewable\nEnergy",
  "Capital\nPunishment",
  "Gun\nControl",
  "Minimum\nWage"
)

# Set custom theme to match responsiveness plots
custom_theme <- theme_minimal(base_family = "serif") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

# Create the bar chart
ggplot(congruence_summary, aes(x = reorder(Policy_Label, -Percent_Congruent), 
                               y = Percent_Congruent, fill = Policy_Type)) +
  geom_col(width = 0.7) +
  labs(
    title = "Congruence by Policy Topic",
    x = "Policy Topic",
    y = "Percent of States Congruent with Majority Opinion",
    fill = "Policy Type"
  ) +
  scale_y_continuous(limits = c(0, 90), expand = c(0, 0)) +
  scale_fill_manual(values = c("Moral" = "#3f3f3f", "Technical" = "#d9d9d9")) +
  custom_theme

ggsave("congruence_bar_chart.png", width = 9, height = 6)

# ==========================================
# Responsiveness Summary Table
# ========================================== 

# Load responsiveness results and combine
responsiveness_files <- list.files(pattern = "_responsiveness_results.csv")

responsiveness_summary <- lapply(responsiveness_files, function(file) {
  df <- read_csv(file)
  policy <- gsub("_responsiveness_results.csv", "", file)
  
  # Ensure you're extracting the estimate for `estimated_opinion`
  if ("term" %in% colnames(df)) {
    beta_row <- df[df$term == "estimated_opinion", ]
  } else {
    beta_row <- df[2, ]  # fallback: second row is usually estimated_opinion
  }
  
  estimate <- beta_row$Estimate
  se <- beta_row$Std..Error
  p <- beta_row$Pr...z..
  
  stars <- ifelse(p < 0.001, "***",
                  ifelse(p < 0.01, "**",
                         ifelse(p < 0.05, "*",
                                ifelse(p < 0.1, ".", ""))))
  
  data.frame(
    Policy = policy,
    Estimate = round(estimate, 3),
    `Std. Error` = round(se, 3),
    `p-value` = round(p, 3),
    `Significance` = stars
  )
}) %>% bind_rows()

write_csv(responsiveness_summary, "responsiveness_summary.csv")
print(responsiveness_summary)

# ==========================================
# Full Summary Table
# ========================================== 

# === Generate compiled_policy_results.csv from raw results ===
library(readr)
library(dplyr)

# Manually define metadata for each policy
policy_metadata <- tibble::tibble(
  Policy = c("abortion", "death_penalty", "drugsentence", "gun_control", 
             "medicaid", "minwage", "paidleave", "renewable"),
  Type = c("Moral", "Moral", "Moral", "Moral", 
           "Technical", "Technical", "Technical", "Technical"),
  Salience = c("High", "Low", "Low", "High", 
               "Low", "High", "Low", "High")  
)

# Collect responsiveness estimates
responsiveness_files <- list.files(pattern = "_responsiveness_results.csv")

responsiveness_data <- lapply(responsiveness_files, function(file) {
  df <- read_csv(file)
  policy <- gsub("_responsiveness_results.csv", "", file)
  beta <- df$Estimate[2]  
  data.frame(Policy = policy, beta = beta)
}) %>% bind_rows()

# Collect congruence percentages from congruence files
congruence_files <- list.files(pattern = "_state_congruence.csv")

congruence_data <- lapply(congruence_files, function(file) {
  df <- read_csv(file)
  policy <- gsub("_state_congruence.csv", "", file)
  overall_row <- df %>% filter(state == "Overall")
  congruence_pct <- round(100 * overall_row$congruence_rate, 1)
  data.frame(Policy = policy, congruence_pct = congruence_pct)
}) %>% bind_rows()

# Merge all data together
compiled_results <- responsiveness_data %>%
  inner_join(congruence_data, by = "Policy") %>%
  inner_join(policy_metadata, by = "Policy") %>%
  select(policy = Policy, beta, congruence_pct, type = Type, salience = Salience)

# Save to CSV
write_csv(compiled_results, "compiled_policy_results.csv")
print(compiled_results)

# Load the compiled results from the previous step
df <- read_csv("compiled_policy_results.csv") %>%
  
  # Create a new column that combines salience and policy type into a category label
  # (e.g., "High + Moral", "Low + Technical")
  mutate(category = paste(salience, type, sep = " + "))

# Group the data by category and calculate average responsiveness and congruence
df_summary <- df %>%
  group_by(category) %>%
  summarise(
    # Average policy responsiveness (slope) within each category
    Avg_Responsiveness = round(mean(beta, na.rm = TRUE), 3),
    
    # Average percentage of states with congruent policy within each category
    Avg_Congruence = round(mean(congruence_pct, na.rm = TRUE), 1)
  )

# Save the summary table as a CSV for your results section
write_csv(df_summary, "category_summary_table.csv")

# Print it to the console
print(df_summary)