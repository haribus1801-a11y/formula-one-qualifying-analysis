Harish Sathiyamoorthy
ECON 4970 - Data Science for Economics
April 2026

# Does Qualifying Performance Affect Race Outcomes in Formula One?

## Motivation
Formula One is a sport where small differences can have a big effect on race results. Before each race, drivers compete in a qualifying session that determines their starting position on the grid. This project studies whether qualifying performance affects race outcomes, including finishing position, winning, and gaining or losing places during the race.

## Research Questions
1. Does starting position predict finishing position?
2. How often does the pole sitter win the race?
3. How often do drivers gain or lose positions during the race?

## Data
The data comes from the Formula One World Championship dataset on Kaggle. I used three files from the dataset:

- `results.csv`
- `races.csv`
- `drivers.csv`

These files were merged to include race results, race year, race name, and driver information.

## R Packages Used
- `dplyr`
- `ggplot2`

## Methods
I merged the race information, race results, and driver data into one dataset. Then I created variables to answer the research questions, including whether a driver started on pole position, whether they won the race, whether they finished on the podium, and how many positions they gained or lost during the race.

The main variables used in the analysis were:

- `grid`: starting position
- `positionOrder`: finishing position
- `points`: points scored
- `positions_gained`: starting position minus finishing position
- `pole_start`: whether the driver started on pole or not

## Results

### Average Finishing Position by Starting Position
<img src="https://raw.githubusercontent.com/haribus1801-a11y/formula-one-qualifying-analysis/main/average_finish_by_grid.png" alt="Average Finishing Position by Starting Position" width="800">

This graph shows that starting position is strongly related to finishing position. Drivers who start closer to the front tend to finish closer to the front on average. As starting position gets worse, average finishing position also becomes worse.

### Win Rate by Pole Position Status
<img src="https://raw.githubusercontent.com/haribus1801-a11y/formula-one-qualifying-analysis/main/win_rate_by_pole_status.png" alt="Win Rate by Pole Position Status" width="800">

Pole starters win much more often than non-pole starters. In this dataset, pole starters won about 42.3% of races, while non-pole starters had a much lower win rate. This suggests that starting first provides a major advantage.

### Average Positions Gained by Starting Position
<img src="https://raw.githubusercontent.com/haribus1801-a11y/formula-one-qualifying-analysis/main/average_positions_gained_by_grid.png" alt="Average Positions Gained by Starting Position" width="800">

Drivers starting farther back tend to gain more positions on average during the race, while drivers starting near the front tend to lose positions on average. This makes sense because drivers at the front have fewer positions to gain and more positions to lose, while drivers farther back have more room to move up.

### Position Change Categories
<img src="https://raw.githubusercontent.com/haribus1801-a11y/formula-one-qualifying-analysis/main/position_change_categories.png" alt="How Often Drivers Gain or Lose Positions" width="800">

This graph shows that drivers gained positions in about 51.0% of driver-race entries, lost positions in about 39.7%, and had no change in about 9.3%. This shows that race-day movement is common, even though qualifying still matters a lot.

## Conclusion
The results show that qualifying performance is strongly related to race outcomes in Formula One. Drivers who start near the front generally finish in better positions and score more points. Pole starters also win much more often than other drivers. At the same time, race outcomes are not completely determined by qualifying because drivers can still gain or lose positions during the race.

## Repository Files
- `Final_Project.R`: R code for the project
- `results.csv`, `races.csv`, `drivers.csv`: data files used in the analysis
- `.png` files: graphs created from the analysis
- `.csv` output files: summary tables created from the analysis
