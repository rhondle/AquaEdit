# AquaEdit

This is a level editor I built with my friend Alastair in 1995 for a shareware Arkanoid/Breakout clone called Aquanoid.

I enjoyed the game, but being a broke kid I didn't have any money to buy the registered version, so we built this editor.

This program was never released until now - after discovering the code on an old backup disk some 19 years later!

The editor was developed using Borland Turbo Pascal 6.0 (a gift from a great guy, Kevin Brandon in the early '90s, who got me started with programming).

_The following was taken from the original documentation_


## Requirements

* 286+
* VGA
* Mouse


## Features

* Level loading, saving and editing
* Choose the background pattern & colour
* Edit the level rating and name for each level
* Level linker

When you first load `AQUAEDIT.EXE`, it may seem a little intimidating because we used 320x200 resolution to maintain compatibility, and we ended up cramming a lot of things into a limited space.

The level design area is located at the top left and takes up most of the screen, and starts with a grid (which can be toggled on/off by pressing `G`)

At the far right are some selectors that allow some customization of the level. At the top is the background colour selector, which consists of two colour layers.

Beneath that is the background pattern picker. There are 21 different patterns available.

The last selector lets you pick a number from `0-4` which correspond to the level difficulty rating:

| Key | Difficulty
|:---:|:--------
| 0	| Simple
| 1	| Challenging
| 2	| Risky
| 3	| Hard
| 4	| Extreme

When you load the level you will see the difficulty rating and level name displayed together on the splash screen, but different difficulty values have no impact on the game play.


## Instructions

Use the mouse to draw your level on the grid. You can select the blocks using the block selector at the bottom left of the screen. If the grid gets in your way, press `G` to get rid of it. When you have your level complete, press `N` to type in a name for your level.

Then, use your mouse to select the two background colours, the background pattern and the level rating. Then, press `S` to save your level.


### Controls

| Key | Action
|:---:|:---
| S | Save Level
| L | Load Level
| G | Toggle Grid
| N | Name Level
| Q | Quit


## Save Level

Valid filenames are 8+3 characters (standard DOS filename). Levels are each 287 bytes each. You must use `AQUALINK` to bundle all of your custom levels into one large file called `DATA.AQA`, which you then copy to your AQUANOID directory to play.

Levels can be named anything you want, but it's strongly recommend that you give them a `.AQA` extention to keep them organized.


## Toggle Grid

A grid has been included to simplfy planning of levels. You can toggle this grid on/off by pressing `G` on your keyboard. I personally find the grid annoying, but some people may prefer it. You can set the grid on/off status on startup in the `SETUP.EXE` program.


## Name Level

The name is displayed in the splash screen that is displayed before each level, underneath the level number. Level names are permitted to be up to 35 characters in length, but due to screen dimensions, it has been limited to 20. The only the characters permitted are `A-Z ! ?` and `Space`. All other characters will be ignored.


## The Blocks

| Colour | Value
|:---|---:
| Brown | 0
| Red  | 10
| Lt Blue | 20
| Yellow | 30
| Lt Green | 40
| Lt Gray | 50
| Purple | 60
| Dark Blue | 70
| Pink | 80
| Dark Green | 90
| Dark Gray | 100


### Titans

These blocks cannot be broken except with a blue shooter.

### Crackers

These blocks look like Titans, except that they can be broken with a perdetermined number of hits with the ball. In Aquaedit, the number of hits required to break the block is written right on the block. Note that all Crackers must be broken to complete the level.

### Shooters

There are three shooters. The first, a red one, will only destroy ordinary blocks. The second, A greenish one, can destroy ordinary blocks and crackers. The last, a blue one, does not appear in the unregistered version except in the demo levels.

However, it is fully functional and will destroy Titans, Crackers as well as ordinary blocks. Note that shooting a block, no matter what it's value, will give you no points.

### Bonuses

Those things that come down with neat things in them are not specific to any block. They are randomly selected, and only when:

* the ball hits a block that has no other blocks below it, and
* there are no other bonuses currently on the screen.


## Known Bugs

Text input in the input boxes (i.e. Load/Save/Name level) is slightly screwed up, and will mess up when you backspace. It still works though.


## Supported Systems

This program has been tested on the following machines:

| System | CPU | Video
|:---|:---|:---
| IBM PS/2 | 286/8 | IBM VGA
| AST | 386/16 SX | ATI SVGA
| Bondwell | 486/25 DLC | Trident
| AST | 486/66 DX2 | VESA

_(Don't laugh, these were classy machines in their day!! And remember, this is **very old** software)_

## AquaLink

A simple utility that bundles all the levels you have created into one file (`DATA.AQA`). You must replace the file of the same name that comes with the game with this one. Make sure you keep a backup copy of the original file saved somewhere if you still want the default levels.

1. Create an ASCII text file with a list of all the levels, in the order you want.

2. Run `AQUALINK` with the file containing the list as the parameter.

3. Replace the `DATA.AQA` file that comes with your game with the newly created one.


## The Game

Disclaimer: Obviously we are in no way affiliated with the original authors of Aquanoid; we were just some kids having fun writing code.

If you're interested, you can still find copies of the original game floating around the net (example, here: http://www.dosgamesarchive.com/download/aquanoid/)
