# Input handling

get_input <- function() {
  # We try to use keypress if available, else fallback to readline
  if (requireNamespace("keypress", quietly = TRUE)) {
    # It waits for a single character input without needing to press enter
    k <- keypress::keypress()

    if (k == "up" || k == "w") return("up")
    if (k == "down" || k == "s") return("down")
    if (k == "left" || k == "a") return("left")
    if (k == "right" || k == "d") return("right")
    if (k == "q" || k == "escape") return("quit")

  } else {
    # Fallback if keypress is not installed (requires pressing Enter)
    cat("Command (w/a/s/d/q): ")
    k <- tolower(readline())

    if (k == "w") return("up")
    if (k == "s") return("down")
    if (k == "a") return("left")
    if (k == "d") return("right")
    if (k == "q") return("quit")
  }

  return("none")
}
