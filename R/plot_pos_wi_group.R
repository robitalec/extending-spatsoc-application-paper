plot_pos_wi_group <- function(DT) {
  g1 <- ggplot(DT) +
    geom_histogram(aes(direction_centroid), bins = 30) +
    labs(x = 'Direction to group centroid', y = '')

  g2 <- ggplot(DT) +
    stat_halfeye(aes(distance_centroid, factor(rank_distance_centroid))) +
    labs(x = 'Distance to group centroid', y = 'Rank distance to group centroid')

  g1 + g2 +
    plot_annotation(tag_levels = 'A', tag_suffix = ')')
}