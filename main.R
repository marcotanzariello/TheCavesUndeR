# main.R - Entry point for the R Roguelike

# Source all R scripts
source("R/engine.R")
source("R/entities.R")
source("R/map.R")
source("R/input.R")

# Main execution function
main <- function() {
  cat("Loading game data...\n")

  # Load configuration
  if (!file.exists("data/map_config.json")) stop("Configuration file missing!")
  config <- jsonlite::fromJSON("data/map_config.json")

  # Load entities
  monster_data <- load_data("data/monsters.json")
  item_data <- load_data("data/items.json")

  # Initialize Game State
  state <- list(
    running = TRUE,
    config = config,
    messages = list("Welcome to the R Roguelike! Use W/A/S/D to move, Q to quit.")
  )

  # Generate map
  state$map <- generate_map(state$config)

  # Spawn entities
  state$monsters <- spawn_monsters(state$config, monster_data, state$map)
  state$items <- spawn_items(state$config, item_data, state$map)

  # Spawn player in the center
  center_x <- as.integer(state$config$width / 2)
  center_y <- as.integer(state$config$height / 2)
  state$player <- create_player(center_x, center_y)

  # Game Loop
  while (state$running) {
    # Render
    draw_game(state)

    # Input
    action <- get_input()

    # Update State
    state <- process_turn(state, action)
  }

  # Render final state before exiting
  draw_game(state)
  cat("Thanks for playing!\n")
}

# Run the game
main()
