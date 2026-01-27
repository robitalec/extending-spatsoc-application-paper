plot_pos_group_dir <- function(DT) {
  DT[, N_by_group := .N, group]
  # sel_group <- DT[N_by_group > 3, sample(group, 1)]
  sel_group <- 932
  sub_DT <- DT[group == sel_group]

  sub_DT[, c('centroid_X', 'centroid_Y') :=
           data.frame(st_coordinates(centroid))]

  slope <- sub_DT[1, as.numeric(tan(group_direction))]
  intercept <- sub_DT[1, centroid_Y - slope * centroid_X]
  intercept_inv <- sub_DT[1, centroid_Y - (-1/slope * centroid_X)]

  g_xy <- ggplot(sub_DT, aes(x = X, y = Y)) +
    geom_spoke(
      aes(centroid_X, centroid_Y,
        radius = 30,
        angle = as.numeric(group_direction)
      ),
      arrow = arrow(length = unit(0.2, 'inches'))
    ) +
    geom_spoke(
      aes(radius = 10, angle = as.numeric(direction)),
      arrow = arrow(length = unit(0.1, 'inches')),
      color = 'grey30'
    ) +
    geom_abline(
      slope = -1 / slope, intercept = intercept_inv,
      linewidth = 0.2
    ) +
    geom_point(aes(centroid_X, centroid_Y), size = 1) +
    geom_point(aes(X, Y), size = 0.5) +
    labs(x = '', y = '') +
    theme(axis.text = element_blank(), axis.ticks = element_blank()) +
    coord_fixed() +
    guides(color = 'none')

  g_pos <- ggplot(DT[N_by_group > 1]) +
    stat_pointinterval(aes(units::as_units(position_group_direction, 'm'),
                     factor(rank_position_group_direction))) +
    scale_y_discrete(limits = rev(levels(factor(DT$rank_position_group_direction))))
    labs(x = 'Position group direction',
         y = 'Rank position group direction') +

  (g_xy / g_pos) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)
}
