module Huebrynth exposing (..)

import Browser
import Html exposing (Attribute, Html, button, div, text, ul, li)
import Html.Attributes exposing (style, tabindex)
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json
import List


-- MAIN

main =
  Browser.sandbox {
    init = init,
    update = update,
    view = view
  }


-- MODEL

type alias NodeId = Int
type NodeType = Start | Empty | End
type alias Occupied = Bool
type Node = Node NodeId NodeType

type alias Lock = Int
type Edge = Open | Gated Lock
type alias Board = List (List Node)

type alias Player = {
  currentPosition: {
    x: Int,
    y: Int
  },
  targetNode: Int
  }

type alias Model = {
  board: Board,
  player: Player
  }

colorScheme = {
  darkPurple = "#210b2cff",
  eminence = "#55286fff",
  wisteria = "#bc96e6ff",
  pearlyPurple = "#ae759fff",
  pinkLavender = "#d8b4e2ff"
  }

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)

init : Model
init = {
  board =
    [
      [ Node 0 Start
      , Node 1 Empty
      , Node 2 Empty
      ],
      [ Node 3 Empty
      , Node 4 Empty
      , Node 5 Empty
      ],
      [ Node 6 Empty
      , Node 7 Empty
      , Node 8 Empty
      ],
      [ Node 9 Empty
      , Node 10 Empty
      , Node 11 Empty
      ]
    ],
  player = {
    currentPosition = {
      x = 0,
      y = 0
    },
    targetNode = 0
  }
  }

type Msg = NoOp | KeyDown Int

-- UPDATE

update : Msg -> Model -> Model
update msg ({ player } as model) =
  case msg of
    NoOp -> model
    KeyDown key -> { model | player = { player | targetNode = key }}

-- VIEW

view : Model -> Html Msg
view { board, player } =
  let
    viewNode : Node -> Html String
    viewNode (Node id _) = div [ style "width" "50px"
                               , style "height" "50px"
                               , style "background-color" "#FFFFFF"
                               ] [ String.fromInt id |> text ]

    viewRow : List Node -> Html String
    viewRow rows =
      div [ style "display" "flex"]
        (List.map viewNode rows)

    {x, y} = player.currentPosition
  in
    div [ onKeyDown KeyDown
        , tabindex 0
        , style "width" "100vw"
        , style "height" "100vh"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ] [
          text ("cat" ++ String.fromInt player.targetNode)
          ]
        --[
        --div  [ style "position" "relative" ]
          --(div [ style "width" "50px"
              --, style "height" "50px"
              --, style "background-color" "#000000"
              --, style "position" "absolute"
              --, style "transform" ("translateX(" ++ String.fromInt x  ++ "px) translateY(" ++ String.fromInt y ++ "px)")
              --] [] :: List.map viewRow board)
        --]
