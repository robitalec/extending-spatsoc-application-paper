plot_dist_dir_cent <- function(DT) {
  sub_DT <- DT[
    rank_distance_centroid != 1.5 &
      !is.nan(direction_centroid)
  ]
  g_dist <- ggplot(sub_DT) +
    stat_pointinterval(aes(
      x = units::as_units(distance_centroid, 'm'),
      y = factor(rank_distance_centroid)
    )) +
    labs(
      x = 'Distance to group centroid',
      y = 'Rank distance to group centroid'
    ) +
    scale_y_discrete(
      limits = rev(levels(factor(sub_DT$rank_distance_centroid)))
    )

  g_dir <- ggplot(sub_DT) +
    geom_histogram(aes(x = direction_centroid), bins = 30) +
    labs(x = 'Direction to group centroid', y = '')

  g_out <- g_dist +
    g_dir +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)

  ggsave(
    file.path('graphics', 'fig_dist_dir_cent.png'),
    g_out,
    width = 9,
    height = 5
  )
}
