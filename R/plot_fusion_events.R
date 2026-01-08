plot_fusion_events <- function(edges, DT) {
  edges[!is.na(fusionID), N_by_fusion := .N, by = fusionID]
  sel_fusion <- edges[N_by_fusion > 5, sample(fusionID, 1)]
  sel_fusion <- 124 #229 #264
  sub_edges <- edges[fusionID == sel_fusion]
  sub_edges[, paste0('centroid_', coords) := data.frame(st_coordinates(centroid))]

  fused_timegroups <- sub_edges$timegroup
  sub_DT <- DT[ID %in% sub_edges[, c(ID1, ID2)] &
                 timegroup %in% sub_edges[, c(min(timegroup) - c(1),
                                              unique(timegroup),
                                              max(timegroup) + c(1:2))]]

  g <- ggplot(sub_DT) +
    geom_point(aes(X, Y, color = ID), alpha = 1,
               data = sub_DT[!timegroup %in% fused_timegroups &
                               timegroup != max(timegroup)]) +
    geom_path(aes(X, Y, color = ID),
              linewidth = 1, linetype = 1) +
    geom_path(aes(X, Y, color = ID), arrow = arrow(length = unit(0.2, "inches")),
              linewidth = 1, linetype = 1) +
    geom_path(data = sub_edges,
              aes(x = centroid_X, y = centroid_Y),
              linewidth = 10, alpha = 0.4) +
    geom_point(data = sub_edges,
               aes(x = centroid_X, y = centroid_Y),
               color = 'black', size = 3) +
    guides(color = element_blank()) +
    scale_color_viridis_d(end = 0.5, begin = 0.2) +
    labs(x = '', y = '') +
    coord_fixed()

  tab <- sub_edges[
    ID1 == 'A' &
      (is.na(ID2) | ID2 %in% sub_edges$ID2) &
      between(
        timegroup,
        min(sub_edges$timegroup) - 1,
        max(sub_edges$timegroup) + 1
      ),
    .(timegroup = seq.int(.N) + 1, ID1, ID2,
      distance = round(units::as_units(distance, 'm'), 2))
  ]

  g_tab <- ggplot() + annotation_custom(
    tableGrob(tab, theme = ttheme_default(base_size = font_size), rows = NULL)
  )

  (g / g_tab &
    theme_void(base_size = font_size)) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)
}