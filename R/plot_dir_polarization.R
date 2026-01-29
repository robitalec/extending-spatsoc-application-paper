plot_dir_polarization <- function(DT) {
  sel_N <- DT[, .N, group][N > 2, group]
  sub <- DT[group %in% sel_N]

  drop_groups <- DT[, any(direction > as_units(pi - 0.5, 'rad') |
                           direction < as_units(-pi + 0.5, 'rad') |
                            .N < 3),
                   by = group][(V1)]$group

  DT[, cut_polarization := cut_interval(polarization, 10)]
  n <- 3
  sel_groups <- DT[!is.na(polarization) & !group %in% drop_groups][,
    sample(unique(group), n, replace = TRUE), by = cut_polarization]$V1
  sub_DT <- DT[group %in% sel_groups]
  sub_DT[, i_group := .GRP, group]

  setnames(sub_DT, 'direction', 'Direction')
  ggplot(sub_DT,
         aes(Direction, i_group, group = i_group)) +
    geom_line(linewidth = 0.4) +
    geom_point(size = 0.8) +
    facet_wrap(~cut_interval(round(polarization, digits = 1), 4)) +
    theme_bw(base_size = font_size) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
    ) +
    labs(y = NULL)
}
