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
        radius = max(as.numeric(position_group_direction)),
        angle = as.numeric(group_direction)
      ),
      arrow = arrow(length = unit(0.2, 'inches'))
    ) +
    geom_spoke(
      aes(radius = 20, angle = as.numeric(direction)),
      arrow = arrow(length = unit(0.1, 'inches')),
      color = 'grey30'
    ) +
    geom_spoke(aes(centroid_X, centroid_Y,
      radius = -min(as.numeric(position_group_direction)),
      angle = pi + as.numeric(group_direction)
    )) +
    geom_abline(
      slope = -1 / slope, intercept = intercept_inv,
      linewidth = 0.2
    ) +
    geom_point(aes(centroid_X, centroid_Y), size = 2) +
    geom_label(aes(
      label = paste(format(position_group_direction, digits = 1), 'm')
    ), ) +
    labs(x = '', y = '') +
    theme(axis.text = element_blank(), axis.ticks = element_blank()) +
    coord_fixed() +
    guides(color = 'none') +
    scale_x_continuous(expand = expansion(add = 10))

  g_pos <- ggplot(DT[N_by_group > 1]) +
    stat_halfeye(aes(units::as_units(position_group_direction, 'm'),
                     factor(rank_position_group_direction))) +
    labs(x = 'Position along group direction',
         y = 'Rank along group direction') +
    scale_y_discrete(limits = rev(levels(factor(DT$rank_position_group_direction))))

  (g_xy / g_pos) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)
}
