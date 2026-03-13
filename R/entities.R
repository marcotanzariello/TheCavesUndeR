# Entity management

load_data <- function(file_path) {
  if (file.exists(file_path)) {
    return(jsonlite::fromJSON(file_path, simplifyDataFrame = FALSE))
  }
  return(list())
}

create_player <- function(x, y) {
  list(
    x = x,
    y = y,
    max_hp = 30,
    hp = 30,
    attack = 5,
    defense = 2,
    inventory = list()
  )
}

spawn_monsters <- function(config, monster_data, map) {
  monsters <- list()
  if (length(monster_data) == 0) return(monsters)

  num_monsters <- sample(1:config$max_monsters, 1)

  for (i in 1:num_monsters) {
    # Pick a random monster type
    m_template <- sample(monster_data, 1)[[1]]

    # Find a valid floor space
    valid <- FALSE
    while (!valid) {
      x <- sample(2:(config$width - 1), 1)
      y <- sample(2:(config$height - 1), 1)
      if (map[y, x] == config$chars$floor) {
        valid <- TRUE
        # Instantiate monster
        m <- m_template
        m$x <- x
        m$y <- y
        monsters[[length(monsters) + 1]] <- m
      }
    }
  }
  return(monsters)
}

spawn_items <- function(config, item_data, map) {
  items <- list()
  if (length(item_data) == 0) return(items)

  num_items <- sample(1:config$max_items, 1)
  for (i in 1:num_items) {
    i_template <- sample(item_data, 1)[[1]]
    valid <- FALSE
    while (!valid) {
      x <- sample(2:(config$width - 1), 1)
      y <- sample(2:(config$height - 1), 1)
      if (map[y, x] == config$chars$floor) {
        valid <- TRUE
        it <- i_template
        it$x <- x
        it$y <- y
        it$collected <- FALSE
        items[[length(items) + 1]] <- it
      }
    }
  }
  return(items)
}
