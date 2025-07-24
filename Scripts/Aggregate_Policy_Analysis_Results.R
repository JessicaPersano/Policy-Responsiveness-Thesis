#Load required libraries
library(dplyr)
library(readr)
library(ggplot2)

# Replace with your actual path
setwd("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Results")

# Full master mapping for all policies
name_mapping <- tibble(
  Policy = c("abortion", "gun_control", "death_penalty", "drugsentence",
             "minwage", "renewable", "medicaid", "paidleave"),
  Policy_Topic = c("Abortion", "Gun Control", "Capital Punishment", "Drug Sentencing Reform",
                   "Minimum Wage", "Renewable Energy Requirements", "Medicaid Expansion", "Paid Family Leave"),
  Policy_Label = c(
    "Abortion",
    "Gun\nControl",
    "Capital\nPunishment",
    "Drug\nSentencing",
    "Minimum\nWage",
    "Renewable\nEnergy",
    "Medicaid\nExpansion",
    "Paid Family\nLeave"
  ),
  Policy_Type = c(
    "Moral", "Moral", "Moral", "Moral",
    "Technical", "Technical", "Technical", "Technical"
  ),
  Policy_Salience = c(
    "High", "High", "Low", "Low",
    "High", "High", "Low", "Low"
  )
)

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

# Join cleaned names and labels
congruence_summary <- congruence_summary %>%
  left_join(name_mapping, by = "Policy") %>%
  select(-Policy) %>%
  rename(Policy = Policy_Topic)

# Save the updated table
write_csv(congruence_summary, "new_congruence_summary.csv")
print(congruence_summary)

# ==========================================
# Congruence Bar Graph
# ==========================================

# Define consistent serif theme
custom_theme <- theme_minimal(base_family = "serif") +
  theme(
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90"),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 13, face = "italic"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    panel.background = element_rect(fill = "white", color = NA),
    panel.border = element_blank(),          
    axis.line = element_blank()             
  )

# Create the bar chart
ggplot(congruence_summary, aes(x = reorder(Policy_Label, -Percent_Congruent), 
                               y = Percent_Congruent, fill = Policy_Type)) +
  geom_col(width = 0.7) +
  labs(
    x = "Policy Topic",
    y = "Percent of States Congruent with Majority Opinion",
    fill = "Policy Type"
  ) +
  scale_y_continuous(limits = c(0, 90), expand = c(0, 0)) +
  scale_fill_manual(values = c("Moral" = "black", "Technical" = "gray80")) +
  custom_theme +
  theme(
    axis.text.x = element_text(size = 12, color = "gray20"),   # darker bar labels
    axis.title.x = element_text(margin = margin(t = 10)),      # more vertical spacing
    legend.title = element_text(size = 14),                    # slightly larger legend title
    legend.text = element_text(size = 13)                      # slightly larger legend items
  )

# Save output
ggsave("congruence_bar_chart.pdf", width = 8.6, height = 6, device = cairo_pdf)

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

write_csv(responsiveness_summary, "new_responsiveness_summary.csv")
print(responsiveness_summary)

# ==========================================
# Full Summary Table
# ========================================== 

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
  inner_join(name_mapping %>% select(Policy, Policy_Type, Policy_Salience), by = "Policy") %>%
  select(policy = Policy, beta, congruence_pct, type = Policy_Type, salience = Policy_Salience)

# Save to CSV
write_csv(compiled_results, "new_compiled_policy_results.csv")
print(compiled_results)

# Load the compiled results from the previous step
df <- read_csv("new_compiled_policy_results.csv") %>%
  
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
write_csv(df_summary, "new_category_summary_table.csv")

# Print it to the console
print(df_summary)