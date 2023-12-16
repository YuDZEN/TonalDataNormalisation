# get necessary packages
library(ggplot2)
library(readr)
library(readxl)
library(tidyverse)

# read the file
df <- read_excel("C:/Users/Yu/OneDrive/桌面/GENERAL/EXPECTATION.xlsx")

# read baseline
df_baseline <- read_excel("C:/Users/Yu/OneDrive/桌面/GENERAL/BASELINE.xlsx")

# change TON_COMBINAISONinto factors，yo ensure the order of every picture
df$TON_COMBINAISON <- factor(df$TON_COMBINAISON, levels = unique(df$TON_COMBINAISON))

# idem
df_baseline$TON_COMBINAISON <- factor(df_baseline$TON_COMBINAISON, levels = unique(df_baseline$TON_COMBINAISON))

# divide the data
df_S1 <- df %>% filter(POSITION_SYL == "S1")
df_S2 <- df %>% filter(POSITION_SYL == "S2")

# get the baseline from data
df_baseline_S1 <- df_baseline %>% filter(POSITION_SYL == "S1")
df_baseline_S2 <- df_baseline %>% filter(POSITION_SYL == "S2")

# make new F0_Percentage colone
df_S1_long <- df_S1 %>% pivot_longer(cols = starts_with("F0_"), names_to = "F0_Percentage", values_to = "value") %>% 
  mutate(F0_Percentage = paste("1", substring(F0_Percentage, 4), sep="/"))

df_S2_long <- df_S2 %>% pivot_longer(cols = starts_with("F0_"), names_to = "F0_Percentage", values_to = "value") %>% 
  mutate(F0_Percentage = paste("2", substring(F0_Percentage, 4), sep="/"))

# make new F0_Percentage colone of baseline
df_baseline_S1_long <- df_baseline_S1 %>% pivot_longer(cols = starts_with("F0_"), names_to = "F0_Percentage", values_to = "BASELINE") %>% 
  mutate(F0_Percentage = paste("1", substring(F0_Percentage, 4), sep="/"))

df_baseline_S2_long <- df_baseline_S2 %>% pivot_longer(cols = starts_with("F0_"), names_to = "F0_Percentage", values_to = "BASELINE") %>% 
  mutate(F0_Percentage = paste("2", substring(F0_Percentage, 4), sep="/"))

# combine data 
df_long <- bind_rows(df_S1_long, df_S2_long)

# combine data 
df_baseline_long <- bind_rows(df_baseline_S1_long, df_baseline_S2_long)

# add baselin to main figure
df_long <- df_long %>% left_join(df_baseline_long, by = c("TON_COMBINAISON","CONTEXTE", "POSITION_SYL", "F0_Percentage"))


# combine
df_all <- df_long %>%
  mutate(DataType = "Data") %>%
  bind_rows(df_baseline_long %>% mutate(DataType = "Baseline"))

# filter
df_all_filtered <- df_all %>%
  group_by(CONTEXTE, TON_COMBINAISON, POSITION_SYL) %>%
  filter(!is.na(value) & !is.na(BASELINE))


# make plot  in the current repertory
for (CONTEXTE in unique(df_all_filtered$CONTEXTE)) {
  p <- ggplot(df_all_filtered %>% filter(CONTEXTE == !!CONTEXTE), aes(x = F0_Percentage, color = POSITION_SYL, group = interaction(TON_COMBINAISON, POSITION_SYL))) +
    geom_line(aes(y = ifelse(POSITION_SYL == "S1", value, NA)), linetype = "solid") +
    geom_line(aes(y = ifelse(POSITION_SYL == "S2", value, NA)), linetype = "solid") +
    geom_point(aes(y = value, shape = POSITION_SYL), color = "black", size = 1.5,shape = 1) +
    geom_line(aes(y = BASELINE, linetype = "dashed", shape = POSITION_SYL), color = "black") +
    geom_point(aes(y = BASELINE, shape = POSITION_SYL), color = "black", size = 1.5, , shape = 2) +
    facet_wrap(~TON_COMBINAISON, ncol = 5) +
    labs(x = "F0 curvePercentage", y = "Mean F0 (z-score)", color = "Position Syllabique") +
    theme_bw() +
    theme(legend.position = "none")
  
  
# save plots
ggsave(paste0(CONTEXTE, "_plot.png"), p, width = 1920/96, height = 1017/96, dpi = 600)

  
# show plots
print(p)
}

# get current repertory
getwd()

