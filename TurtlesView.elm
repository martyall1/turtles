module TurtlesView where

import TurtlesModel exposing (Turtle, Flower, TurtleSpec, Position)
import Color exposing (Color, green, yellow, red, black)
import Graphics.Collage exposing (circle, rect, collage, filled, move, outlined, solid, Form)
import Graphics.Element exposing (layers, Element)
import List exposing (map)

boundingBox : Int -> Int -> Element
boundingBox w h =
  collage w h [ outlined (solid black) <| rect (toFloat w) (toFloat h)
              , outlined (solid red) <| rect (toFloat (w - 2)) (toFloat (h - 2))
              ]

drawTurtle : Int -> Int -> Turtle -> Form
drawTurtle w h s =
  let {position, turtleSpec} = s
  in filled green (rect (toFloat 4) (toFloat 4))
       |> move (toFloat position.x - (toFloat w)/2,
               (toFloat h)/2 - toFloat position.y)

drawFlower : Int -> Int -> Flower -> Form
drawFlower w h f =
  let {position} = f
  in filled yellow (circle (toFloat 2))
     |>  move (toFloat position.x - (toFloat w)/2,
              (toFloat h)/2 - toFloat position.y)

drawTurtles : Int -> Int -> List Turtle -> Element
drawTurtles w h turtles = collage w h <| map (drawTurtle w h) turtles

drawFlowers : Int -> Int -> List Flower -> Element
drawFlowers w h flowers = collage w h <| map (drawFlower w h) flowers

view : Int -> Int -> List Flower -> List Turtle -> Element
view w h flowers turtles =
  layers [ boundingBox w h
         , drawTurtles w h turtles
         , drawFlowers w h flowers
         ]
