module Turtles where

import TurtlesModel exposing (..)
import TurtlesView exposing (..)
import List exposing ((::), map)
import Time exposing (Time, fps, timestamp)
import Mouse
import Signal exposing (Signal, (~), (<~), filter, foldp, sampleOn, constant)

import Collision exposing (..)

clockSignal : Signal Time
clockSignal = fst <~ timestamp (fps 50)

clickPositionsSignal : Signal (Int, Int)
clickPositionsSignal = sampleOn Mouse.clicks Mouse.position

inBoxClickPositionsSignal : Int -> Int -> Signal (Int, Int)
inBoxClickPositionsSignal w h =
  let positionInBox pos = fst pos <= w && snd pos <= h
  in
    filter positionInBox (0,0) clickPositionsSignal

creationTimeSignal : Int -> Int -> Signal Time
creationTimeSignal w h =
  sampleOn (inBoxClickPositionsSignal w h) clockSignal

newTurtleSpecSignal : Int -> Int -> Signal TurtleSpec
newTurtleSpecSignal w h =
  makeTurtle <~ creationTimeSignal w h

newTurtleSignal : Int -> Int -> Signal Turtle
newTurtleSignal w h =
  let makeTurtle (x,y) spec = { position = { x = x, y = y }, turtleSpec = spec }
  in
    makeTurtle <~ inBoxClickPositionsSignal w h
                ~ newTurtleSpecSignal w h

allTurtlesSpecSignal : Int -> Int -> Signal (List Turtle)
allTurtlesSpecSignal w h =
  foldp (::) [] (newTurtleSignal w h)


{- for now this all takes place on a torus -}
computeCoordinate : Int -> Int -> Float -> Float -> Int
computeCoordinate startingPointCoordinate boxSize velocity time =
  let distance = startingPointCoordinate + round (velocity * time/1000)
  in distance % boxSize

positionedTurtle : Int -> Int -> Float -> Turtle -> Turtle
positionedTurtle w h time turtle =
  let { position, turtleSpec } = turtle
      { xv, yv, creationTime } = turtleSpec
      relativeTime = time - creationTime
      boxSizeX = w - 4
      boxSizeY = h - 4
      x = 2 + computeCoordinate (position.x - 2) boxSizeX (toFloat xv) relativeTime
      y = 2 + computeCoordinate (position.y - 2) boxSizeY (toFloat yv) relativeTime
  in
    { position = { x = x, y = y}, turtleSpec = turtleSpec }

positionedTurtles : Int -> Int -> Float -> List Turtle -> List Turtle
positionedTurtles w h time turtles =
  map (positionedTurtle w h time) turtles

turtlesSignal : Int -> Int -> Signal (List Turtle)
turtlesSignal w h = positionedTurtles w h <~ clockSignal ~ allTurtlesSpecSignal w h

main  =
  let main' w h = view w h [] <~ turtlesSignal w h
  in
    main' 500 500


turtleSupport : Turtle -> Pt -> Pt
turtleSupport turtle (x',y') =
  let { position, turtleSpec } = turtle
      (x,y) = (position.x, position.y)
  in (toFloat x + x' + 2, toFloat y + y' + 2)


turtleToMink : Turtle -> Mink Turtle
turtleToMink turtle =
  let {position, turtleSpec} = turtle
  in (turtle, turtleSupport)


flowerSupport : Flower -> Pt -> Pt
flowerSupport flower (x',y') =
  let { position } = flower
      (x,y) = (position.x, position.y)
  in (toFloat x + x' + 2, toFloat y + y' + 2)


flowerToMink : Flower -> Mink Flower
flowerToMink flower =
  let {position} = flower
  in (flower, flowerSupport)
