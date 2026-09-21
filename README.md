# Deep Earth

A 2D pixel-art platformer built in Godot 4.6, where you descend through a corrupted cave system, phase through reality to dodge death, and outrun the things that live in the dark.

## Story & Concept

You explore an underground world that's slowly being consumed by corruption. Guided by a mentor NPC and pieces of dialogue found along the way, you'll need to phase between spots, swing on vines, dodge crumbling and moving platforms, and survive enemies (crawlers, followers) across 16 levels leading up to a final confrontation.

## Features

- **16 handcrafted levels** with an ending sequence
- **Phase mechanic** — hold to phase through designated spots and reposition instantly
- **Vine swinging** — physics-based swing traversal
- **Crumbling & moving platforms**
- **Enemies with behavior-tree AI** (crawler, follower)
- **Dialogue system** with an in-game mentor/NPC
- **Full menu suite** — main menu, pause menu, settings (including rebindable controls), level transitions
- **Save system** — progress is saved automatically to a config file

## Controls

| Action   | Key   |
|----------|-------|
| Move     | A / D |
| Jump     | Space |
| Phase    | J     |
| Grab     | K     |
| Interact | E     |
| Pause    | Esc   |

Controls are rebindable from the in-game Settings menu.

## Running the Game

**Playing a build:**
1. Make sure `deep_earth.exe` and `deep_earth.pck` are in the same directory.
2. Launch the `.exe`.
3. A save file is created automatically at `user://save.cfg` (on Windows, under `%appdata%\Godot\app_userdata\deep-earth`). Delete it to reset progress.

**Opening the project in the editor:**
1. Clone this repository.
2. Open [Godot 4.6](https://godotengine.org/) and import the project via `project.godot`.
3. Run the main scene from the editor.

## Project Structure

```
Deep-Earth/
├── scenes/          # Godot scenes: levels, player, enemies, UI, managers
├── scripts/         # GDScript sources (player, enemies, menus, save system)
│   └── bt/          # Behavior-tree nodes used for enemy AI
├── assets/          # Sprites, tilesets, fonts, and sounds
├── project.godot    # Godot project configuration
└── default_bus_layout.tres
```

## Credits

**Assets**
- Game Font — [Dekartaretro](https://asemdjoworks.itch.io/dekartaretro-font)
- Menu Background — [Cave Background Pixel Art](https://slashdashgamesstudio.itch.io/cave-background-pixel-art)
- Corruption Assets — [Strange Underground Platformer](https://unholymoly.itch.io/strange-underground-platformer)
- Player Character — [Free Pixel Art Tiny Hero Sprites](https://craftpix.net/freebies/free-pixel-art-tiny-hero-sprites/)
- Uncorrupted Backgrounds + Crawler Enemy — [Cave Tileset Free](https://the-pixel-nook.itch.io/cave-tileset-free), [Tileset](https://odiurd.itch.io/tileset)

**Sounds**
- Walking — [freesound.org](https://freesound.org/people/TechspiredMinds/sounds/729203/)
- Death (Spikes/Follower) — [freesound.org](https://freesound.org/people/Mateusz_Chenc/sounds/547600/)
- Phasing — [freesound.org](https://freesound.org/people/sound.variant/sounds/807304/)
- Swinging — [freesound.org](https://freesound.org/people/InspectorJ/sounds/394457/)
- Crawler Movement — [freesound.org](https://freesound.org/people/Zuzek06/sounds/353250/)
- Crawler Death — [freesound.org](https://freesound.org/people/qubodup/sounds/751340/)
- Crumbling Platform (Crumble) — [freesound.org](https://freesound.org/people/TechspiredMinds/sounds/729212/)
- Crumbling Platform (Reappear) — [freesound.org](https://freesound.org/people/Halgrimm/sounds/195463/)
- Moving Platform — [freesound.org](https://freesound.org/people/patchytherat/sounds/530988/)
- Game Background Music — [Cave Theme](https://opengameart.org/content/cave-theme)
- Main Menu/Credits Music — [Crystal Cave Song](https://opengameart.org/content/crystal-cave-song18)
- Menu Click — [Menu Choice](https://opengameart.org/content/menu-choice)
