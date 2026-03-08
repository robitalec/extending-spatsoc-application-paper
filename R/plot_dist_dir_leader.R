plot_dist_dir_leader <- function(DT) {
  g_dir <- ggplot(
    DT[!is.nan(direction_leader) & !is.na(direction_leader)],
    aes(direction_leader, factor(rank_position_group_direction))
  ) +
    stat_pointinterval() +
    labs(x = 'Direction to leader', y = 'Rank position group direction') +
    scale_y_discrete(
      limits = rev(levels(factor(DT$rank_position_group_direction)))
    )

  g_dist <- ggplot(
    DT[!is.na(distance_leader)],
    aes(
      units::as_units(distance_leader, 'm'),
      factor(rank_position_group_direction)
    )
  ) +
    stat_pointinterval() +
    labs(x = 'Distance to leader', y = 'Rank position group direction') +
    scale_y_discrete(
      limits = rev(levels(factor(DT$rank_position_group_direction)))
    )

  g_out <- (g_dist + g_dir & theme_bw(base_size = font_size)) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)

  ggsave(
    file.path('graphics', 'fig_dist_dir_leader.png'),
    g_out,
    width = 8,
    height = 5
  )
}
