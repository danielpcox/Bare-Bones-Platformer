Bare Bones Platformer
=====================

A little bare-bones platformer written in Ruby using the Gosu and Chipmunk gems.
Written using gosu 0.7.41, chipmunk 5.3.4.5, and ruby 1.9.3p0.

Usage
-----

1. Clone the repo and cd into its directory
2. Copy levels/sandbox.yml.example to levels/sandbox.yml for the thing to work, at the moment.
3. Run "bundle install" to get gosu and chipmunk. You may need to install some of *their* dependencies manually
4. Run "ruby platformer.rb" to play

Controls
--------

* Left and Right arrow keys move the character left and right.
* The Up arrow key jumps
* Ctrl+E goes into editing mode
* In editing mode, left click creates a platform and right click destroys one.
* If you change the platform configuration at all, Escape will exit the game, saving the modified level to levels/sandbox.yml

Credits
-------

* Sprites were taken from [the Gosu examples](https://github.com/jlnr/gosu/tree/master/examples).
* Background is an edited version of [a photo by Niklas Agevik](http://www.e.kth.se/~na/photo/tree_large.jpg).
* "Wow" sound is [a free PacDV sound effect](http://www.pacdv.com/sounds/voices/wow-2.wav).
