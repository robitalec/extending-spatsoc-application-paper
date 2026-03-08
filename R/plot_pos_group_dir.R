plot_pos_group_dir <- function(DT) {
  DT[, N_by_group := .N, group]
  # sel_group <- DT[N_by_group > 3, sample(group, 1)]
  sel_group <- 932
  sub_DT <- DT[group == sel_group]

  sub_DT[,
    c('centroid_X', 'centroid_Y') := data.frame(st_coordinates(centroid))
  ]

  slope <- sub_DT[1, as.numeric(tan(group_direction))]
  intercept <- sub_DT[1, centroid_Y - slope * centroid_X]
  intercept_inv <- sub_DT[1, centroid_Y - (-1 / slope * centroid_X)]

  g_xy <- ggplot(sub_DT, aes(x = X, y = Y)) +
    geom_abline(
      slope = -1 / slope,
      intercept = intercept_inv,
      linewidth = 0.6
    ) +
    geom_spoke(
      aes(
        centroid_X,
        centroid_Y,
        radius = 30,
        angle = as.numeric(group_direction)
      ),
      linewidth = 2,
      arrow = arrow(length = unit(0.2, 'inches'))
    ) +
    geom_spoke(
      aes(radius = 10, angle = as.numeric(direction)),
      arrow = arrow(length = unit(0.1, 'inches')),
      linewidth = 2,
      color = 'grey30'
    ) +
    geom_point(aes(centroid_X, centroid_Y), size = 3) +
    geom_point(aes(X, Y), size = 2) +
    labs(x = '', y = '') +
    theme_void(base_size = font_size) +
    theme(axis.text = element_blank(), axis.ticks = element_blank()) +
    coord_fixed() +
    guides(color = 'none')

  g_pos <- ggplot(DT[N_by_group > 1 & !is.na(position_group_direction)]) +
    stat_pointinterval(aes(
      units::as_units(position_group_direction, 'm'),
      factor(rank_position_group_direction)
    )) +
    labs(x = 'Position group direction', y = 'Rank position group direction') +
    scale_y_discrete(
      limits = rev(levels(factor(DT$rank_position_group_direction)))
    ) +
    theme_bw(base_size = font_size)

  g_out <- (g_xy + g_pos) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix) +
    plot_layout(widths = 1, heights = 1)

  ggsave(
    file.path('graphics', 'fig_pos_group_dir.png'),
    g_out,
    width = 8,
    height = 5
  )
}
