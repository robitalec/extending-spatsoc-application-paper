# === spatsoc paper 2 -----------------------------------------------------
# Alec L. Robitaille



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
targets::tar_source('R')



# Options -----------------------------------------------------------------
tar_option_set(format = 'qs')



# Variables ---------------------------------------------------------------
# Review
filepath_thesaurus <- file.path('map', 'metric-thesaurus.csv')

# Spatiotemporal grouping
filepath <- system.file('extdata', 'DT.csv', package = 'spatsoc')
temporal_threshold <- '10 minutes'
spatial_threshold <- 50

datetime <- 'datetime'
id <- 'ID'
coords <- c('X', 'Y')
utm <- 32736

timegroup <- 'timegroup'
group <- 'group'

# edge_dist
returnDist <- TRUE
fillNA <- FALSE

# dyad_id
id1 <- 'ID1'
id2 <- 'ID2'

# fusion_id
n_min_length <- 3
n_max_missing <- 1
allow_split <- TRUE

# edge_delay
window <- 3

# Plotting
# ggplot theme
theme_set(theme_bw())

# fontsize
font_size <- 16

# Patchwork tags
tag_levels <- 'A'
tag_suffix <- ')'

# Targets: Spatiotemporal groups ------------------------------------------
targets_spatiotemporal_groups <- c(
  tar_target(
    input_data,
    fread(filepath),
    description = 'fread(filepath)'
  ),

  tar_target(
    prepared_geometry,
    get_geometry(input_data, coords = coords, crs = utm),
    description = 'get_geometry()'
  ),

  tar_target(
    prepared_dates,
    prep_dates(
      DT = prepared_geometry,
      datetime = datetime
    ),
    description = 'prep_dates()'
  ),

  tar_target(
    temporal_groups,
    group_times(
      DT = prepared_dates,
      datetime = datetime,
      threshold = temporal_threshold
    ),
    description = 'group_times()'
  ),

  tar_target(
    spatial_groups,
    group_pts(
      DT = temporal_groups,
      threshold = spatial_threshold,
      id = id,
      timegroup = timegroup
    ),
    description = 'group_pts()'
  )
)


# Targets: Distance based edge-lists --------------------------------------
targets_distance_edge_lists <- c(
  tar_target(
    distance_edges,
    edge_dist(
      DT = temporal_groups,
      threshold = spatial_threshold,
      id = id,
      timegroup = timegroup,
      returnDist = TRUE
    )
  ),

  tar_target(
    nn_edges,
    edge_nn(
      DT = temporal_groups,
      id = id,
      timegroup = timegroup
    )
  )
)



# Targets: Intragroup dynamics --------------------------------------------
targets_intragroup_dynamics <- c(
  tar_target(
    step_directions,
    direction_step(
      DT = spatial_groups,
      id = id
    )
  ),

  tar_target(
    group_directions,
    direction_group(
      DT = step_directions
    ),
    description = 'direction_group()'
  ),

  tar_target(
    group_centroids,
    centroid_group(
      DT = group_directions
    ),
    description = 'centroid_group()'
  ),

  tar_target(
    direction_to_centroids,
    direction_to_centroid(
      DT = group_centroids
    ),
    description = 'direction_to_centroid()'
  ),

  tar_target(
    distance_to_centroids,
    distance_to_centroid(
      DT = direction_to_centroids
    ),
    description = 'distance_to_centroid()'
  ),

  tar_target(
    group_direction_leaders,
    leader_direction_group(
      DT = group_centroids,
      return_rank = TRUE
    ),
    description = 'leader_direction_group()'
  ),

  tar_target(
    direction_to_group_dir_leaders,
    direction_to_leader(
      DT = group_direction_leaders
    ),
    description = 'direction_to_leader()'
  ),

  tar_target(
    distance_to_group_dir_leaders,
    distance_to_leader(
      DT = direction_to_group_dir_leaders
    ),
    description = 'distance_to_leader()'
  ),

  tar_target(
    id_dyads,
    dyad_id(
      DT = distance_edges,
      id1 = id1,
      id2 = id2
    ),
    description = 'dyad_id()'
  ),

  tar_target(
    id_fusions,
    fusion_id(
      edges = id_dyads,
      threshold = spatial_threshold,
      n_min_length = n_min_length,
      n_max_missing = n_max_missing,
      allow_split = allow_split
    ),
    description = 'fusion_id()'
  ),

  tar_target(
    delay_edges,
    edge_delay(
      edges = id_fusions,
      DT = step_directions,
      window = window,
      id = id
    ),
    description = 'edge_delay()'
  ),

  tar_target(
    edge_delay_leaders,
    leader_edge_delay(
      edges = delay_edges
    ),
    description = 'leader_edge_delay()'
  ),

  tar_target(
    fusion_centroids,
    centroid_fusion(
      edges = id_fusions,
      DT = temporal_groups,
      id = id
    ),
    description = 'centroid_fusion()'
  ),

  tar_target(
    direction_edges,
    edge_direction(
      edges = fusion_centroids,
      DT = spatial_groups,
      id = id
    ),
    description = 'edge_direction()'
  ),

  tar_target(
    dyad_centroids,
    centroid_dyad(
      edges = id_dyads,
      DT = temporal_groups,
      id = id
    ),
    description = 'centroid_dyad()'
  ),

  tar_target(
    polarization,
    direction_polarization(
      DT = step_directions
    ),
    description = 'direction_polarization()'
  ),

  tar_target(
    alignment,
    edge_alignment(
      DT = step_directions,
      id = id
    ),
    description = 'edge_alignment()'
  )
)




# Targets: Figures --------------------------------------------------------
targets_figures <- c(
  tar_target(
    fig_pos_wi_group,
    plot_pos_wi_group(distance_to_centroids)
  ),
  tar_target(
    fig_pos_group_dir,
    plot_pos_group_dir(group_direction_leaders)
  ),
  tar_target(
    fig_dist_dir_leader,
    plot_dist_dir_leader(distance_to_group_dir_leaders)
  ),
  tar_target(
    fig_fusion_events,
    plot_fusion_events(direction_edges, spatial_groups)
  ),
  tar_target(
    fig_dir_polarization,
    plot_dir_polarization(polarization)
  ),
  tar_target(
    fig_dir_align,
    plot_dir_align(spatial_groups, alignment)
  )
)

# Targets: Review ---------------------------------------------------------
targets_review <- c(
  tar_file_read(
    raw_review,
    file.path('map', 'review.csv'),
    fread(!!.x)
  ),
  tar_target(
    dl_metric_thesaurus,
    write_gs4_to_csv('1YInLKBejpIUaovCnpLanXvPr8uvBEA6skpUcvFc2Ov8',
                     sheet = 'metric-thesaurus',
                     file = filepath_thesaurus),
    cue = tar_cue_age(dl_metric_thesaurus, age = as.difftime(7, units = 'days'))
  ),
  tar_target(
    benchmark_papers,
    data.table(
      read_sheet(
        '112TA9JMfQ6mK9tGPSnJVF6fSmfw9hnR_FB1aasoac-M',
        sheet = 'benchmark papers'))[
          is.na(`Removed as benchmark`),
          .(Citation, `Indexed in WoS`)]
  ),
  tar_target(
    search_strings,
    data.table(
      read_sheet(
        '112TA9JMfQ6mK9tGPSnJVF6fSmfw9hnR_FB1aasoac-M',
        sheet = 'iterative search'))[, last(.SD)[, .(String)], Source]
  ),
  tar_file_read(
    metric_synonyms,
    dl_metric_thesaurus,
    fread(!!.x)
  ),
  tar_target(
    software_meta,
    read_sheet('1YInLKBejpIUaovCnpLanXvPr8uvBEA6skpUcvFc2Ov8',
               sheet = 'software-meta',
               col_types = 'c'),
    cue = tar_cue_age(software_meta, age = as.difftime(7, units = 'days'))
  ),
  tar_target(
    review,
    review_prep(
      raw_review,
      metric_synonyms
    )
  ),
  tar_target(
    geocoded,
    review_geocode(review)
  ),
  tar_target(
    taxized,
    review_taxize(review)
  ),
  tar_target(
    counted,
    review_count(review)
  )
)



# Targets: Quarto ---------------------------------------------------------
# TODO: quarto render
# targets_quarto <- c(
#   tar_quarto(
#     site,
#     path = '.'
#   )
# )





# Targets: All ------------------------------------------------------------
# Automatically grab all the 'targets_*' lists above
lapply(grep('targets', ls(), value = TRUE), get)
