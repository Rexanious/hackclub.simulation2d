# 2D physics simulation for planets (SolarBox)

A 2D physics sandbox where celestial bodies attract each other with realistic gravity. Made with Godot 4.

## Features
- Newtonian gravity physics
- Adjustable mass
- Camera pan/zoom controls
- tutorial levels
- orbital velocity calculator

## Requirements
- Godot 4.X or later

## Installation
1. Clone this repository
2. Open the project in Godot
3. Run `Main_menu.tscn`

## Controls
| Action | Input             |
|--------|-------------------|
| Spawn planet | Q    |
| Zoom | Mouse wheel |
| Move | WASD |
| Spawn star| E |

(controls subject to change later)

## Configuration
Edit `planet.gd` to adjust:
- `G` - Gravitational constant
- `mass` - Default planet mass
- `initial_velocity` - Starting velocity

## License
MIT
