module TurtlesModel where

import Time exposing (Time)
import Random exposing (generate, int, initialSeed)

type alias Position = { x: Int, y: Int }

type alias TurtleSpec = {
    xv: Int,
    yv: Int,
    creationTime: Float
  }

type alias Turtle = {
    position: Position,
    turtleSpec: TurtleSpec
  }

type alias Flower = {
    position: Position
  }

makeTurtle : Time -> TurtleSpec
makeTurtle time =
  let seed1 = initialSeed (round time)
      (xv, seed2) = generate (int 10 50) seed1
      (yv, _) = generate (int 10 50) seed2
  in
    { xv = xv
    , yv = yv
    , creationTime = time
    }
