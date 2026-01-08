plot_edge_zones <- function(zones) {
  zones[, direction_dyad_relative :=
        spatsoc:::diff_rad(direction, direction_dyad, signed = TRUE)]

  r <- data.table(
    zone_thresholds,
    zone_labels,
    x0 = rep_len(0, length(zone_thresholds)),
    y0 = rep_len(0, length(zone_thresholds))
  )
  r[, zone_labels := factor(zone_labels, levels = c(zone_labels, 'blind'))]
  r_highlight <- copy(r)
  setnames(r_highlight, 'zone_labels', 'zone')

  zones[, zone := factor(zone, levels = c(zone_labels, 'blind'))]

  ggplot(zones[ID1 == 'G' & ID2 == 'E' & !is.na(zone)]) +
    geom_spoke(aes(x = 0, y = 0,
                   angle = direction_dyad_relative,
                   radius = distance)) +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = zone_thresholds),
                         color = 'black', linewidth = 0.2, data = r) +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = zone_thresholds),
                         color = 'black', linewidth = 0.5, data = r_highlight) +

    geom_vline(xintercept = 0, linewidth = 0.1) +
    geom_hline(yintercept = 0, linewidth = 0.1) +
    facet_wrap(~zone, ncol = 3) +
    coord_flip() +
    labs(x = NULL, y = NULL) +
    theme(aspect.ratio = 1,
          axis.ticks = element_blank(),
          axis.text = element_blank()) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)

}