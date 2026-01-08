plot_edge_zones <- function(zones) {
  zones[, direction_dyad_relative :=
        spatsoc:::diff_rad(direction, direction_dyad, signed = TRUE)]

  ggplot(zones[ID1 == 'G' & ID2 == 'E' & !is.na(zone)]) +
    geom_spoke(aes(x = 0, y = 0,
                   angle = direction_dyad_relative,
                   # angle = drop_units(direction_dyad),
                   radius = distance)) +
    geom_vline(xintercept = 0, linewidth = 0.1) +
    geom_hline(yintercept = 0, linewidth = 0.1) +
    facet_wrap(~zone) +
    coord_flip() +
    labs(x = NULL, y = NULL) +
    theme(aspect.ratio = 1,
          axis.ticks = element_blank(),
          axis.text = element_blank()) +
    plot_annotation(tag_levels = tag_levels, tag_suffix = tag_suffix)

}