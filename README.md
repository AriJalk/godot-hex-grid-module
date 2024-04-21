# 3D Hex Tile System for Godot

3D Hex Tile System for Godot, basic implementation of tile laying in games like Carcassone/Dorfromantik. Based on [Red Blob Games Hexagonal Grids](https://www.redblobgames.com/grids/hexagons).

Was meant to be used for the initial Godot version of [Solo Train Game](https://github.com/AriJalk/SoloTrainGameUnity/) and was extracted from it.

## Features

- **Left click to add a tile:** Add a tile to an available slot.
  
- **Right click to delete a tile:** Delete a tile from a slot if it exists.
  
- **Freeform dynamic map:** Islands of separated hexes could be created without needing to store empty ones.
  
- **Moving camera:** The camera is always bound to the limits of the map.
- **Undo:** Undo the last action made (actions are in a stack so undo works for both adding and removing).

## Usage

- **Hex class:** Data representation of a hex using Cube Coordinates. Initialized with QRS coordinates.
- **HexGrid class:** Provides static functions for handling hex logic and transformations. Main usage:
  - `static func hex_to_world(hex: Hex, hex_size: float, gap_proportion: float, orientation: Orientation = Layout.layout_flat) -> Vector3`
  - `static func hex_neighbor(hex: Hex, direction: HexDirections) -> Hex`
- **TileManager class:** Game-oriented side of the system, handling creation and positioning of 3D HexTile nodes. Main usage:
  - `func add_tile(hex_data: Hex) -> HexTile`: Adds a hex to the map if possible with the specified hex coordinates.
  - `func remove_tile(hex: Hex) -> void`: Removes a hex if it exists.
  - `func add_slot(hex_data: Hex) -> HexSlot`: Adds an empty slot for a hex.
  - `func get_slot(hex) -> HexSlot`: Get the world slot of a possible tile.

![Demonstration](HexGrid.gif)
