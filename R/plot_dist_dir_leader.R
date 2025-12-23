plot_dist_dir_leader <- function(DT) {
  DT[, N_by_group := .N, group]
  # sel_group <- DT[N_by_group > 3, sample(group, 1)]
  sel_group <- 932
  sub_DT <- DT[group == sel_group]

  g_dist <- ggplot(DT, aes(direction_leader,
                           factor(rank_position_group_direction))) +
    stat_halfeye() +
    labs(x = 'Direction to leader', y = 'Rank along group direction') +
    theme_bw()

  g_dir <- ggplot(DT, aes(units::as_units(distance_leader, 'm'),
                          factor(rank_position_group_direction))) +
    stat_halfeye() +
    labs(x = 'Distance to leader', y = 'Rank along group direction') +
    theme_bw()

  g_dist + g_dir
}