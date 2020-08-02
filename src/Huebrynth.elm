module Huebrynth exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Attribute, Html, button, div, text, ul, li)
import Html.Attributes exposing (style, tabindex)
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json
import List exposing (map, length, indexedMap, concat)
import List.Extra exposing (find, getAt)


-- MAIN

main : Program () Model Msg
main =
  Browser.element {
    init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
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

type Direction = Left | Right | Up | Down
type Msg = NoOp | KeyDown Int | Frame Float

colorScheme = {
  darkPurple = "#210b2cff",
  eminence = "#55286fff",
  wisteria = "#bc96e6ff",
  pearlyPurple = "#ae759fff",
  pinkLavender = "#d8b4e2ff"
  }

onKeyDown : (Int -> Msg) -> Attribute Msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)

keyCodeToDirection : Int -> Maybe Direction
keyCodeToDirection int =
  case int of
    37 -> Just Left
    38 -> Just Up
    39 -> Just Right
    40 -> Just Down
    _ -> Nothing


subscriptions : Model -> Sub Msg
subscriptions _ = onAnimationFrameDelta Frame

init : flag -> (Model, Cmd Msg)
init flag = ({
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
    targetNode = 4
  }}, Cmd.none)


-- UPDATE

getCurrentNode : Player -> Board -> Maybe (Int, Int, Node)
getCurrentNode { currentPosition, targetNode } board =
  let
    indexedBoard = indexedMap (\y row -> indexedMap (\x node -> (x, y, node)) row) board |> concat
    maybeCurrentNodePos = find (\(x, y, Node id _) -> id == targetNode) indexedBoard
  in
    maybeCurrentNodePos

getNextTargetNode : Player -> Board -> Direction -> Maybe Node
getNextTargetNode { currentPosition, targetNode} board direction =
  let
    indexedBoard = indexedMap (\y row -> indexedMap (\x node -> (x, y, node)) row) board |> concat
    maybeCurrentNodePos = find (\(x, y, Node id _) -> id == targetNode) indexedBoard
    coordToNode : Int -> Int -> Maybe Node
    coordToNode x y =
      let
        maybeRow = getAt y board
      in
        case maybeRow of
          Nothing -> Nothing
          Just row -> getAt x row
    getNextNode : Int -> Int -> Maybe Node
    getNextNode x y =
      case direction of
        Left -> coordToNode (x - 1) y
        Up -> coordToNode x (y - 1)
        Right -> coordToNode (x + 1) y
        Down -> coordToNode x (y + 1)
  in
    case maybeCurrentNodePos of
      Nothing -> Nothing
      Just (x, y, _) -> getNextNode x y

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ board, player } as model) =
  case msg of
    NoOp -> (model, Cmd.none)
    KeyDown code ->
      case (keyCodeToDirection code) of
        Nothing -> (model, Cmd.none)
        Just direction ->
          let
            maybeNode = getNextTargetNode player board direction
          in
            case maybeNode of
              Nothing -> (model, Cmd.none)
              Just (Node id _) -> ({ model | player = { player | targetNode = id }}, Cmd.none)
    Frame delta ->
      let
        maybeNodePos = getCurrentNode player board
        {x, y} = player.currentPosition
      in
        case maybeNodePos of
          Nothing -> (model, Cmd.none)
          Just (i, j, Node id _) -> ({ model | player = { player | currentPosition = { x = calcPos (i * 50) x, y = calcPos (j * 50) y} }}, Cmd.none)

-- VIEW

view : Model -> Html Msg
view { board, player } =
  let
    viewNode : Node -> Html Msg
    viewNode (Node id _) = div [ style "width" "50px"
                               , style "height" "50px"
                               , style "background-color" "#FFFFFF"
                               ] [ String.fromInt id |> text ]

    viewRow : List Node -> Html Msg
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
        ]
        [
          div  [ style "position" "relative"]
            --[ text ( String.fromInt player.targetNode) ]
            (div [ style "width" "50px"
                , style "height" "50px"
                , style "background-color" "#000000"
                , style "position" "absolute"
                , style "transform" ("translateX(" ++ String.fromInt x  ++ "px) translateY(" ++ String.fromInt y ++ "px)")
                ] [] :: List.map viewRow board)
        ]

-- Utils
calcPos : Int -> Int -> Int
calcPos a b = toFloat (a + b) / 2 |> round
