plot_dist_dir_cent <- function(DT) {
  DT <- DT[rank_distance_centroid != 1.5]
  g_dist <- ggplot(DT) +
    stat_halfeye(aes(x = units::as_units(distance_centroid, 'm'),
                     y = factor(rank_distance_centroid))) +
    labs(x = 'Distance to group centroid', y = 'Rank distance to group centroid') +
    scale_y_discrete(limits = rev(levels(factor(DT$rank_distance_centroid))))

  g_dir <- ggplot(DT) +
    geom_histogram(aes(x = direction_centroid), bins = 30) +
    labs(x = 'Direction to group centroid', y = '')

  g_dist + g_dir +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)
}