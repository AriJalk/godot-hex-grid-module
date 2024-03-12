# GodotHexGridSystem

Implementation of Hexagonal Grid in godot, based on the guide from Red Blob Games: https://www.redblobgames.com/grids/hexagons/
Interface is made in the style of Dorfromantik hex placement.

## Controls

* Mouse Left-Click on available slot: Add tile on slot and expand grid.
* Mouse Right-Click on available slot: Remove tile from slot and shrink grid.
* UI Undo button: Undo last action (it keeps track of both adding and removal so every state is reversible to the starting one no matter what actions were made)
* WASD: Move camera (the camera bounds are limited by the size of the grid)

## In-Action

![HexGrid](ReadmeImages/HexGrid_demo.mp4)</br>
