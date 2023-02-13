# Hitori puzzle solver 🧩

This is a solver for [Hitori puzzles](https://en.wikipedia.org/wiki/Hitori) written with [CLIPS](https://www.clipsrules.net/). This is the result of a project of the [Knowledge Engineering Class](https://www.cs.us.es/cursos/ic/) I took in 2022/2023 at the [University of Seville](https://www.us.es/).

## Usage 🚀

To run the solver, you need to have [CLIPS](https://www.clipsrules.net/) installed. Then, open up the CLIPS IDE and run the following commands:

```bash
CLIPS> (load "hitori.clp")
CLIPS> (solve-puzzles)     # If you want to solve all the puzzles from puzzles.txt
CLIPS> (read-puzzle 23)    # If you want to solve the 23rd puzzle from puzzles.txt
```
