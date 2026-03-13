# Core game engine logic

clear_screen <- function() {
  cat("\033[2J\033[H")
}

draw_game <- function(state) {
  clear_screen()

  map <- state$map

  # Draw entities over the map
  if (!is.null(state$player)) {
    map[state$player$y, state$player$x] <- state$config$chars$player
  }

  for (m in state$monsters) {
    if (m$hp > 0) {
      map[m$y, m$x] <- m$symbol
    }
  }

  for (i in state$items) {
    if (!i$collected) {
      map[i$y, i$x] <- i$symbol
    }
  }

  # Render the map
  for (i in 1:nrow(map)) {
    cat(paste(map[i, ], collapse = ""), "\n")
  }

  # Render HUD
  cat(sprintf("\nHP: %d/%d | ATK: %d | DEF: %d\n",
              state$player$hp, state$player$max_hp,
              state$player$attack, state$player$defense))

  # Render messages
  if (length(state$messages) > 0) {
    cat("\nMessages:\n")
    for (msg in tail(state$messages, 5)) {
      cat("- ", msg, "\n")
    }
  }
}

add_message <- function(state, msg) {
  state$messages <- c(state$messages, msg)
  return(state)
}

process_turn <- function(state, action) {
  if (action == "quit") {
    state$running <- FALSE
    return(state)
  }

  # Player movement
  dx <- 0
  dy <- 0

  if (action == "up") dy <- -1
  if (action == "down") dy <- 1
  if (action == "left") dx <- -1
  if (action == "right") dx <- 1

  if (dx != 0 || dy != 0) {
    new_x <- state$player$x + dx
    new_y <- state$player$y + dy

    # Simple collision detection
    if (new_x >= 1 && new_x <= state$config$width &&
        new_y >= 1 && new_y <= state$config$height &&
        state$map[new_y, new_x] != state$config$chars$wall) {

        # Check if monster is there
        monster_hit <- FALSE
        for (i in seq_along(state$monsters)) {
          m <- state$monsters[[i]]
          if (m$hp > 0 && m$x == new_x && m$y == new_y) {
            # Attack!
            damage <- max(1, state$player$attack - m$defense)
            state$monsters[[i]]$hp <- m$hp - damage
            state <- add_message(state, sprintf("You hit the %s for %d damage!", m$name, damage))
            if (state$monsters[[i]]$hp <= 0) {
               state <- add_message(state, sprintf("The %s dies!", m$name))
            }
            monster_hit <- TRUE
            break
          }
        }

        if (!monster_hit) {
          state$player$x <- new_x
          state$player$y <- new_y

          # Check for item
          for (i in seq_along(state$items)) {
            it <- state$items[[i]]
            if (!it$collected && it$x == new_x && it$y == new_y) {
               state$items[[i]]$collected <- TRUE
               state <- add_message(state, sprintf("You picked up a %s!", it$name))
               if (it$effect == "heal") {
                 state$player$hp <- min(state$player$max_hp, state$player$hp + it$value)
               } else if (it$effect == "attack_bonus") {
                 state$player$attack <- state$player$attack + it$value
               } else if (it$effect == "defense_bonus") {
                 state$player$defense <- state$player$defense + it$value
               }
               break
            }
          }
        }
    } else {
        state <- add_message(state, "Ouch! You bumped into a wall.")
    }
  }

  # Monsters turn (simplified - they just attack if next to player, or don't move)
  for (i in seq_along(state$monsters)) {
    m <- state$monsters[[i]]
    if (m$hp > 0) {
       dist_x <- abs(m$x - state$player$x)
       dist_y <- abs(m$y - state$player$y)
       if (dist_x <= 1 && dist_y <= 1 && (dist_x + dist_y) > 0) {
          # Monster attacks
          damage <- max(0, m$attack - state$player$defense)
          state$player$hp <- state$player$hp - damage
          state <- add_message(state, sprintf("The %s hits you for %d damage!", m$name, damage))
          if (state$player$hp <= 0) {
             state <- add_message(state, "You have died... Game Over.")
             state$running <- FALSE
          }
       }
    }
  }

  return(state)
}
