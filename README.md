# GodotHexGridSystem

Implementation of Hexagonal Grid in godot, based on the guide from Red Blob Games: https://www.redblobgames.com/grids/hexagons/</br>
Built using custom godot build with my custom object pooling module: https://github.com/AriJalk/GodotNodePoolModule</br>
Interface is made in the style of Dorfromantik hex placement.
The grid expands (and can also shrink if needed) dynamically, adding a tile will also add the next available neighbor slots of the new hex, while removing a hex tile will remove neighbor slots that are no longer connected to a tile.</br>

## Controls

* Mouse Left-Click on available slot: Add tile on slot and expand grid.
* Mouse Right-Click on available slot: Remove tile from slot and shrink grid.
* UI Undo button: Undo last action (it keeps track of both adding and removal so every state is reversible to the starting one no matter what actions were made)
* WASD: Move camera (the camera bounds are automatically adjusted based on the size of the grid)

## In-Action

![HexGrid](ReadmeImages/HexGrid.gif)</br>
