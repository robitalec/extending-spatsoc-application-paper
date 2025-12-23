plot_pos_group_dir <- function(DT) {
  DT[, N_by_group := .N, group]
  # sel_group <- DT[N_by_group > 3, sample(group, 1)]
  sel_group <- 1025
  sub_DT <- DT[group == sel_group]

  sub_DT[, c('centroid_X', 'centroid_Y') := data.frame(st_coordinates(centroid))]

  slope <- sub_DT[1, as.numeric(tan(group_direction))]
  intercept <- sub_DT[1, centroid_Y - slope * centroid_X]
  intercept_inv <- sub_DT[1, centroid_Y - (-1/slope * centroid_X)]

  g_pos <- ggplot(sub_DT, aes(x = X, y = Y)) +
    geom_spoke(
      aes(centroid_X, centroid_Y,
        radius = max(as.numeric(position_group_direction)),
        angle = as.numeric(group_direction)
      ),
      arrow = arrow()
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
    theme_bw() +
    labs(x = '', y = '') +
    theme(axis.text = element_blank(), axis.ticks = element_blank()) +
    coord_sf() +
    guides(color = 'none') +
    scale_x_continuous(expand = expansion(add = 10))

  g_hist <- ggplot(DT[N_by_group > 1]) +
    geom_histogram(aes(position_group_direction), binwidth = 1) +
    labs(x = 'Distance along group az', y = '')

    geom_histogram(aes(rank_position_group_direction), binwidth = 1) +
    labs(x = 'Rank distance along group az', y = '')
  # g_hist2 <- ggplot(DT[N_by_group > 1]) +

  g_dist <- ggplot(DT[N_by_group > 1]) +
    stat_halfeye(aes(position_group_direction, factor(rank_position_group_direction))) +
    labs(x = 'Distance along group az', y = 'Rank distance along group az')

  list(
    positions = g_pos,
    dist_dir = (g_dist + (g_hist / g_hist2))
  )
}
