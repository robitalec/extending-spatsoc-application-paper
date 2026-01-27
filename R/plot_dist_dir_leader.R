plot_dist_dir_leader <- function(DT) {
  DT[, N_by_group := .N, group]
  # sel_group <- DT[N_by_group > 3, sample(group, 1)]
  sel_group <- 932
  sub_DT <- DT[group == sel_group]

  g_dir <- ggplot(DT, aes(direction_leader,
                           factor(rank_position_group_direction))) +
    stat_pointinterval() +
    labs(x = 'Direction to leader', y = 'Rank position group direction') +
    scale_y_discrete(limits = rev(levels(factor(DT$rank_position_group_direction))))

  g_dist <- ggplot(DT, aes(units::as_units(distance_leader, 'm'),
                          factor(rank_position_group_direction))) +
    stat_pointinterval() +
    labs(x = 'Distance to leader', y = 'Rank position group direction') +
    scale_y_discrete(limits = rev(levels(factor(DT$rank_position_group_direction))))

  (g_dist + g_dir &
    theme_bw(base_size = font_size)) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)
}