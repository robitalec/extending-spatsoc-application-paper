plot_edge_dir_and_align <- function(DT, edges) {
  DT[, N_by_group := .N, group]
  sel_group <- DT[N_by_group > 2, sample(group, 1)]
  sel_group <- 1048 #1011
  sel_ids <- c('E', 'F') #I
  sub <- DT[
    ID %in%
      sel_ids &
      between(
        timegroup,
        DT[group == sel_group, min(timegroup) - 1],
        DT[group == sel_group, max(timegroup) + 2]
      )
  ]
  sub[, timegroup := timegroup - min(timegroup) + 1]
  g <- ggplot(sub, aes(X, Y, color = ID)) +
    geom_path(arrow = arrow()) +
    geom_label(
      aes(label = timegroup),
      fill = 'white',
      data = sub[timegroup != max(timegroup)]
    ) +
    scale_color_viridis_d(end = 0.5) +
    labs(x = '', y = '') +
    coord_fixed() +
    scale_x_continuous(expand = expansion(mult = 0.1)) +
    scale_y_continuous(expand = expansion(mult = 0.1))

  tab <- edges[
    (ID1 %in% sel_ids & ID2 %in% sel_ids) &
      between(
        timegroup,
        DT[group == sel_group, min(timegroup) - 1],
        DT[group == sel_group, max(timegroup) + 1]
      ),
    .(
      timegroup = timegroup - min(timegroup) + 1,
      ID1,
      ID2,
      direction_dyad = round(direction_dyad, digits = 2),
      direction_diff = round(direction_diff, digits = 2)
    )
  ]

  g_tab <- ggplot() +
    annotation_custom(
      tableGrob(tab, theme = ttheme_default(base_size = font_size), rows = NULL)
    )

  (g / g_tab & theme_void(base_size = font_size)) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix) +
    plot_layout(widths = 1, heights = 1)
}
