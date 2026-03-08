plot_edge_delay <- function(edges, leaders, DT) {
  sel_fusion <- edges[dyadID == 'C-G'][, .N, fusionID][N == 6]$fusionID[[1]]
  sub_edges <- edges[fusionID == sel_fusion]
  sel_dyad <- first(sub_edges$dyadID)
  sel_ids <- sort(unique(sub_edges$ID1))

  sub_leaders <- unique(
    leaders[, .(
      ID = ID1,
      mean_direction_delay = round(mean_direction_delay, 2)
    )]
  )[
    order(ID)
  ]

  sub_DT <- DT[timegroup %in% sub_edges$timegroup & ID %in% sub_edges$ID1]

  sub_edges[
    sub_DT,
    direction := direction,
    on = .(ID1 == ID, timegroup == timegroup)
  ]

  left <- sub_edges[ID1 == first(sel_ids)][
    timegroup == median(timegroup),
    .(
      timegroup = median(seq.int(uniqueN(sub_DT$timegroup))),
      ID1,
      ID2,
      direction = round(direction, 2),
      direction_delay
    )
  ]
  right <- sub_DT[ID == last(sel_ids)][
    order(timegroup),
    .(timegroup = .I, ID, direction = round(direction, 2))
  ]

  which_ids <- c(sel_ids, sample(setdiff(leaders$ID1, sel_ids), 1))
  sub_leaders <- leaders[order(dyadID)][
    ID1 %in% which_ids & ID2 %in% which_ids,
    .(
      ID1,
      ID2,
      mean_direction_delay_dyad = round(mean_direction_delay_dyad, 2),
      mean_direction_delay = round(mean_direction_delay, 2)
    )
  ]

  g_left <- ggplot() +
    annotation_custom(
      tableGrob(
        left,
        theme = ttheme_default(base_size = font_size),
        rows = NULL
      )
    )
  g_right <- ggplot() +
    annotation_custom(
      tableGrob(
        right,
        theme = ttheme_default(base_size = font_size),
        rows = NULL
      )
    )
  g_leaders <- ggplot() +
    annotation_custom(
      tableGrob(
        sub_leaders,
        theme = ttheme_default(base_size = font_size),
        rows = NULL
      )
    )

  g_out <- (g_left /
    g_right /
    g_leaders &
    theme_void(base_size = font_size) &
    theme(plot.background = element_rect(fill = 'white', color = 'white'))) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix) +
    plot_layout(widths = 1, heights = c(1, 1, 3))

  ggsave(
    file.path('graphics', 'fig_edge_delay.png'),
    g_out,
    width = 7,
    height = 6
  )
}
