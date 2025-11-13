This is a game developed in assembly for the computer desingned by ICMC-USP. It is a simple Von Neumann computer implementing a RISC instruction set that includes arithimatic, logical, stack, IO, conditional, call, jump, etc. 

More info can be found can be found [here](https://github.com/simoesusp/Processador-ICMC/tree/master)

This game is a sokoban, a type of puzzle game which you solve chalendges primarely by pushing objects around.

The twist of this game will be the exploration of the topologies of diferent 2d manifolds, in which the puzles will reside. 

The ground work is going well. 

What is Done already:

- Player Movement
- Layered Rendering
- Dirty Rendering
- Easy way to load new levels via the CurentLayer Pointers
- Pushing Boxes
- Pushing Multiple Boxes
- Pushing Multiple Boxes Over Topological bounderies
- Torus Topology - Pacman like

Intermediary ToDo's:

  - Run Lenght Econder/Decoder for layers and big strings

Big ToDo's: 

- UI System, alows for the stacking of ui elements, and interaction with the top-most one.
- Other Objects like walls, buttons, doors, etc...
- Making topology variable and configurable. Curently Stuck on a toroidal surface
- Undo Function
- Non Orientable Surfaces
- Non traditional 2d manifolds
- Puzzles

ToDo's If there is enought time:

- Extensible Object System with pointers to Behaviour functions
- Dynamic Backgrounds
- Animations




