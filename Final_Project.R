# Final Project
# Introduction to Data Science for Econ
# Topic: Does qualifying performance affect race outcomes in Formula One?
#
# This script reads in Formula One data, cleans/merges the data, creates new
# variables, makes summary tables, and exports graphs for the final project.


# Load packages used for data wrangling and graphing.
library(dplyr)
library(ggplot2)

setwd("/Users/harishsathiyamoorthy/Documents/New project")
getwd()

# Created folders for the tables and figures
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)


# ------------------------------------------------------------
# 1. Read in the data
# ------------------------------------------------------------

# The files are from Formula One World Championship dataset on Kaggle.

results <- read.csv("data/results.csv")
races <- read.csv("data/races.csv")
drivers <- read.csv("data/drivers.csv")


# ------------------------------------------------------------
# 2. Merge the datasets and create project variables
# ------------------------------------------------------------

# Keep only the race information
races_small <- races %>%
  select(raceId, year, race_name = name)

# Keep only the driver information 
drivers_small <- drivers %>%
  mutate(driver_name = paste(forename, surname)) %>%
  select(driverId, driver_name, nationality)

# Merge results with race and driver information.
f1 <- results %>%
  left_join(races_small, by = "raceId") %>%
  left_join(drivers_small, by = "driverId")

# Created variables that answer the research questions.
# grid is starting position and positionOrder is finishing position.
f1 <- f1 %>%
  filter(grid > 0) %>%
  mutate(
    positions_gained = grid - positionOrder,
    pole_start = ifelse(grid == 1, "Pole Starter", "Not Pole Starter"),
    won_race = ifelse(positionOrder == 1, 1, 0),
    podium_finish = ifelse(positionOrder <= 3, 1, 0),
    points_finish = ifelse(points > 0, 1, 0)
  ) %>%
  select(
    year, race_name, driver_name, nationality, grid, positionOrder,
    positions_gained, pole_start, won_race, podium_finish, points_finish, points
  )


# ------------------------------------------------------------
# 3. Descriptive stat table
# ------------------------------------------------------------

# Table is to compare to pole starters and non-pole starters.
# Reports the mean, median, standard deviation, minimum, and maximum.
descriptive_table <- f1 %>%
  group_by(pole_start) %>%
  summarize_at(
    vars(grid, positionOrder, positions_gained, points),
    list(
      mean = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min = ~min(., na.rm = TRUE),
      max = ~max(., na.rm = TRUE)
    )
  )

# Export the descriptive table.
descriptive_table
write.csv(descriptive_table, "output/tables/descriptive_table_by_pole.csv", row.names = FALSE)


# ------------------------------------------------------------
# 4. Research Question 1
# Does starting position predict finishing position?
# ------------------------------------------------------------

# Calculattion of the average finishing position and points by starting grid position.
starting_position_summary <- f1 %>%
  group_by(grid) %>%
  summarize(
    avg_finish = mean(positionOrder, na.rm = TRUE),
    avg_points = mean(points, na.rm = TRUE),
    races = n(),
    .groups = "drop"
  )

# Export the table.
starting_position_summary
write.csv(starting_position_summary, "output/tables/starting_position_summary.csv", row.names = FALSE)

# Scatter plot of starting position and finishing position.
start_finish_plot <- ggplot(f1, aes(x = grid, y = positionOrder)) +
  geom_jitter(width = 0.25, height = 0.25, alpha = 0.15, color = "steelblue") +
  labs(
    title = "Starting Position and Finishing Position in Formula One",
    x = "Starting Position on Grid",
    y = "Finishing Position"
  ) +
  theme_minimal()

# Save the plot as a PNG file for the README and presentation.
ggsave("output/figures/start_vs_finish_scatter.png", start_finish_plot, width = 8, height = 5)


# Bar chart of average finishing position by starting position.
# I focus on grid positions 1-20 because most modern F1 races have about 20 cars.
avg_finish_plot <- starting_position_summary %>%
  filter(grid <= 20) %>%
  ggplot(aes(x = grid, y = avg_finish)) +
  geom_col(fill = "darkred") +
  labs(
    title = "Average Finishing Position by Starting Position",
    x = "Starting Position on Grid",
    y = "Average Finishing Position"
  ) +
  theme_minimal()

# Save the plot as a PNG file for the README and presentation.
ggsave("output/figures/average_finish_by_grid.png", avg_finish_plot, width = 8, height = 5)


# ------------------------------------------------------------
# 5. Research Question 2
# How often does the driver on pole win the race?
# ------------------------------------------------------------

# Calculate win rate, podium rate, and points rate by pole starter status.
pole_outcome_table <- f1 %>%
  group_by(pole_start) %>%
  summarize(
    races = n(),
    win_rate = mean(won_race, na.rm = TRUE) * 100,
    podium_rate = mean(podium_finish, na.rm = TRUE) * 100,
    points_rate = mean(points_finish, na.rm = TRUE) * 100,
    avg_points = mean(points, na.rm = TRUE),
    .groups = "drop"
  )

# View and export the table.
pole_outcome_table
write.csv(pole_outcome_table, "output/tables/pole_outcome_table.csv", row.names = FALSE)


# Bar chart comparing win rates for pole starters and non-pole starters.
pole_win_plot <- ggplot(pole_outcome_table, aes(x = pole_start, y = win_rate, fill = pole_start)) +
  geom_col() +
  labs(
    title = "Win Rate by Pole Position Status",
    x = "Starting Group",
    y = "Win Rate (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save the plot as a PNG file for the README and presentation.
ggsave("output/figures/win_rate_by_pole_status.png", pole_win_plot, width = 7, height = 5)


# ------------------------------------------------------------
# 6. Research Question 3
# How often do drivers gain or lose positions during a race?
# ------------------------------------------------------------

# Create a simple category for whether a driver gained, lost, or kept position.
position_change_table <- f1 %>%
  mutate(
    position_change_group = ifelse(
      positions_gained > 0, "Gained Positions",
      ifelse(positions_gained < 0, "Lost Positions", "No Change")
    )
  ) %>%
  group_by(position_change_group) %>%
  summarize(
    count = n(),
    percent = count / nrow(f1) * 100,
    .groups = "drop"
  )

# Export the table.
position_change_table
write.csv(position_change_table, "output/tables/position_change_table.csv", row.names = FALSE)


# Bar chart showing how often drivers gain, lose, or keep position.
position_change_plot <- ggplot(position_change_table, aes(x = position_change_group, y = percent, fill = position_change_group)) +
  geom_col() +
  labs(
    title = "How Often Drivers Gain or Lose Positions",
    x = "Race Position Change",
    y = "Percent of Driver Race Entries"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save the plot as a PNG file for the README and presentation.
ggsave("output/figures/position_change_categories.png", position_change_plot, width = 7, height = 5)


# Average positions gained by starting position.
position_gain_by_grid <- f1 %>%
  group_by(grid) %>%
  summarize(
    avg_positions_gained = mean(positions_gained, na.rm = TRUE),
    races = n(),
    .groups = "drop"
  )

# Export the table.
position_gain_by_grid
write.csv(position_gain_by_grid, "output/tables/position_gain_by_grid.csv", row.names = FALSE)


# Bar chart of average positions gained by starting position.
positions_gained_plot <- position_gain_by_grid %>%
  filter(grid <= 20) %>%
  ggplot(aes(x = grid, y = avg_positions_gained)) +
  geom_col(fill = "darkgreen") +
  labs(
    title = "Average Positions Gained by Starting Position",
    x = "Starting Position on Grid",
    y = "Average Positions Gained"
  ) +
  theme_minimal()

# Save the plot as a PNG file for the README and presentation.
ggsave("output/figures/average_positions_gained_by_grid.png", positions_gained_plot, width = 8, height = 5)


# ------------------------------------------------------------
# 7. Main results for the README and presentation
# ------------------------------------------------------------

# Print the main numbers clearly in the console.
pole_win_rate <- pole_outcome_table %>%
  filter(pole_start == "Pole Starter") %>%
  pull(win_rate)

pole_podium_rate <- pole_outcome_table %>%
  filter(pole_start == "Pole Starter") %>%
  pull(podium_rate)

cat("Pole starters won", round(pole_win_rate, 1), "percent of races in the data.\n")
cat("Pole starters finished on the podium", round(pole_podium_rate, 1), "percent of the time.\n")

# Cleaned dataset save.
write.csv(f1, "output/tables/cleaned_f1_data.csv", row.names = FALSE)







