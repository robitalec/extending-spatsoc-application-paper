plot_dir_polarization <- function(DT) {
  sel_N <- DT[, .N, group][N > 2, group]
  sub <- DT[group %in% sel_N]

  # sub[, round_pol := round(polarization, 1)]
  # sub_pol <- sub[round_pol %in% seq(0, 1, by = 0.2),
  #            .SD[group == first(group)], by = round_pol]
  #
  # ggplot(sub_pol, aes(direction)) +
  #   stat_interval(.width = 1, color = 'black', linewidth = 0.5) +
  #   geom_point(aes(direction, 0)) +
  #   geom_text(
  #     x = 0, y = 0.3,
  #     aes(label = format(polarization, digits = 2))
  #   ) +
  #   facet_grid(round(polarization, digits = 2) ~ .,
  #              as.table = FALSE) +
  #   theme_bw() +
  #   theme(axis.text.y = element_blank(),
  #         axis.ticks.y = element_blank(),
  #         ) +
  #   labs(y = NULL)

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

  ggplot(sub_DT,
         aes(direction, i_group, group = i_group)) +
    geom_line(linewidth = 0.3) +
    geom_point() +
    facet_grid(~cut_interval(round(polarization, digits = 1), 5)) +
    theme_bw() +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
    ) +
    labs(y = NULL)
}
