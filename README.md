# AquaEdit

This is a level editor I built with my friend Alastair in 1995 for a shareware Arkanoid/Breakout clone called Aquanoid.

I enjoyed the game, but being a broke kid I didn't have any money to buy the registered version so we built an editor to create new levels and breathe new life into the game.

This program was never released until now, after discovering the code on an old backup disk some 19 years later!

The editor was developed using Borland Turbo Pascal 6.0 (a gift from a great guy, Kevin Brandon in the early '90s, which got me started with programming).

######The following was taken directly from the original documentation:

####Requirements

- 286+
- VGA
- Mouse


####Features

* Level loading, saving and editing
* Choose the background pattern & colour
* Edit the level rating and name for each level
* Level linker

When you first load AQUAEDIT.EXE, it may seem a little intimidating. This is because we used the 320x200 resolution to maintain compatibility, and we ended up cramming a lot of things onto the screen.

When you load the editor, look at the screen. At the top left, there is a grid (which can be toggled on/off by pressing G)

At the far right there is a box containing the background colour editor. The background consists of two layers of colour. These two colour selectors change the values.

Next, you can select the background pattern. There are 21 different patters you can use for the background, which is plenty. At the bottom of the box is a scrolly that lets you select a number from 0-4. The numbers indicate the level rating, so memorize the following chart:

```
0 - Simple
1 - Challenging
2 - Risky 
3 - Hard
4 - Extreme
```

When you play your level, you'll see the level rating displayed on the same screen as the level name.


####Instructions

Use the mouse to draw your level on the grid. You can select the blocks using the block selector at the bottom left of the screen. If the grid gets in your way, press G to get rid of it. When you have your level complete, press N to type in a name for your level.

Then, use your mouse to select the 2 background colours, the background pattern and the level rating. Then, press S to save your level. Once you have several levels, use AQUALINK to link them together and then you can add it to AquaNoid.

```
S  - Save Level
L  - Load Level from Disk
G  - Toggle Grid on/off
N  - Name Level
Q  - Quit
```

#####Save Level

Valid filenames are 8+3 characters, a standard DOS filename. Levels are each 287 bytes, and you must use AQUALINK to link these into one large file called DATA.AQA, which you can copy to your AQUANOID directory and play.

Levels can be called anything you want, but I strongly recommend that you name them with a .AQA extention for organization.


#####Toggle Grid

A grid has been included to simplfy planning of levels. You can toggle this grid on/off by pressing G on your keyboard. I personally find the grid annoying, but some people like it. You can set the grid on/off status on startup in the SETUP.EXE program.


#####Name Level

The name is displayed in the startup screen that is displayed before each level, underneath the level number. Level names are permitted to be up to 35 characters in length, but due to screen dimensions, it has been limited to 20. Note that only the characters permitted are A-Z ! ? and Space. All other characters will be ignored.


####The Blocks


#####Colour (Value)
```
  Brown         (0)
  Red           (10)
  Lt Blue       (20)
  Yellow        (30)
  Lt Green      (40)
  Lt Gray       (50)
  Purple        (60)
  Dark Blue     (70)
  Pink          (80)
  Dark Green    (90)
  Dark Gray     (100)
```

######Titans
These blocks cannot be broken except with a blue shooter.

######Crackers
These blocks look like Titans, except that they can be broken with a perdetermined number of hits with the ball. In Aquaedit, the number of hits required to break the block is written right on the block. Note that all Crackers must be broken to complete the level.

######Shooters
There are three shooters. The first, a red one, will only destroy ordinary blocks. The second, A greenish one, can destroy ordinary blocks and crackers. The last, a blue one, does not appear in the unregistered version except in the demo levels.

However, it is fully functional and will destroy Titans, Crackers as well as ordinary blocks. Note that shooting a block, no matter what it's value, will give you no points.

######Bonuses
Those things that come down with neat things in them are not specific to any block. They are randomly selected, and only when:

- the ball hits a block that has no other blocks below it, and
- there are no other bonuses currently on the screen.


####Known Bugs
Text input in the input boxes (i.e. Load/Save/Name level) is slightly screwed up, and will mess up when you backspace. It still works though.


This program has been tested on the following machines:

- IBM PS/2 286/8        IBM VGA
- AST      386/16 SX    ATI SVGA
- Bondwell 486/25 DLC   Trident
- AST      486/66 DX2   VESA



####AquaLink

This simple utility allows you to compile all the levels you have created into one file (DATA.AQA). You must replace the same file that comes with Aquanoid with this one. Make sure you have a copy of this file saved somewhere if you still want the original levels.

step 1: Create an ASCII text file with a list of all the levels, in the order you want.

step 2: Run AQUALINK with the file containing the list as the parameter.

step 3: Replace the DATA.AQA file that comes with your game with the newly created one.


####The Game

Disclaimer: Obviously we are in no way affiliated with the original authors of Aquanoid; we were just some kids having fun writing code.

If you're interested, you can still find copies of the original game floating around the net (example, here: http://www.dosgamesarchive.com/download/aquanoid/)

