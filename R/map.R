# Map generation

generate_map <- function(config) {
  # Create an empty matrix filled with empty chars
  map <- matrix(config$chars$empty, nrow = config$height, ncol = config$width)

  # Create a simple room with borders
  for (y in 1:config$height) {
    for (x in 1:config$width) {
      if (y == 1 || y == config$height || x == 1 || x == config$width) {
        map[y, x] <- config$chars$wall
      } else {
        map[y, x] <- config$chars$floor
      }
    }
  }

  # Add some random walls inside
  num_obstacles <- as.integer((config$width * config$height) * 0.1)
  for (i in 1:num_obstacles) {
    ox <- sample(2:(config$width - 1), 1)
    oy <- sample(2:(config$height - 1), 1)
    map[oy, ox] <- config$chars$wall
  }

  return(map)
}
