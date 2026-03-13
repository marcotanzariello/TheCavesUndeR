# The-Caves-UndeR

A Roguelike project written in R.
It uses JSON files to configure the map, monsters, and items.

## Prerequisites

To play the game, ensure you have R installed on your system.
You will also need a few R packages.

Install the required packages by starting an R session and running:

```R
install.packages(c("jsonlite", "keypress"))
```

*Note: `keypress` is highly recommended to allow movement with arrow keys or WASD without having to press Enter. If not installed, the game uses a standard fallback method.*

## How to Play

Open your terminal, navigate to the repository directory, and run the game with:

```bash
Rscript main.R
```

### Controls
- Use arrow keys or **W/A/S/D** to move the character (`@`).
- Walk into a monster to attack it.
- Walk over an item to collect it (it is used automatically for now).
- Press **Q** to quit.

## Project Structure

- `main.R`: Main entry point and Game Loop.
- `data/`: Contains JSON configuration files (`monsters.json`, `items.json`, `map_config.json`).
- `R/`: Logic scripts:
  - `engine.R`: Screen rendering and turn management.
  - `entities.R`: Creation/loading of player, monsters, and items.
  - `map.R`: Room generation.
  - `input.R`: Textual input handling.
