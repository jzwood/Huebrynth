module Huebrynth exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Attribute, Html, button, div, text, ul, li)
import Html.Attributes exposing (style, class, tabindex)
import Html.Events exposing (on, keyCode, onInput)
import HuebrynthTypes exposing (..)
import Json.Decode as Json
import Level1 exposing (..)
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

type alias Player =
  { currentPosition:
    { x: Int
    , y: Int
    }
  , targetNodeId: Int
  , counter: Int
  }

type alias Model =
  { board: Board
  , edges: Edges
  , player: Player
  }

type Direction = Left | Right | Up | Down
type Msg = NoOp | KeyDown Int | Frame Float

pallette = { darkPurple = "#210b2cff"
  , eminence = "#55286fff"
  , wisteria = "#bc96e6ff"
  , pearlyPurple = "#ae759fff"
  , pinkLavender = "#d8b4e2ff"
  }

boxSize = 65
boxpx = String.fromInt boxSize ++ "px"

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
init flag = (
  { board = boardL1
  , edges = edgesL1
  , player =
    { currentPosition =
      { x = 0
      , y = 0
      }
    , targetNodeId = getStartNode boardL1 0
    , counter = 1
    }
  }, Cmd.none)


-- UPDATE

getCurrentNode : Player -> Board -> Maybe (Int, Int, Node)
getCurrentNode { currentPosition, targetNodeId } board =
  let
    indexedBoard = indexedMap (\y row -> indexedMap (\x node -> (x, y, node)) row) board |> concat
    maybeCurrentNodePos = find (\(x, y, Node id _) -> id == targetNodeId) indexedBoard
  in
    maybeCurrentNodePos

coordToNode : Int -> Int -> Board -> Maybe Node
coordToNode x y board =
  let
    maybeRow = getAt y board
  in
    case maybeRow of
      Nothing -> Nothing
      Just row -> getAt x row

getNextTargetNode : Player -> Board -> Direction -> Maybe Node
getNextTargetNode ({ currentPosition, targetNodeId} as player) board direction =
  case (getCurrentNode player board) of
    Nothing -> Nothing
    Just (x, y, _) ->
      case direction of
        Left -> coordToNode (x - 1) y board
        Up -> coordToNode x (y - 1) board
        Right -> coordToNode (x + 1) y board
        Down -> coordToNode x (y + 1) board

--lookupEdgeFromNodes : NodeId -> NodeId -> Edges -> Maybe Edge
canMoveToNode : NodeId -> NodeId -> Bool
canMoveToNode a b = True

isCounterMultipleOfLock : Int -> Lock -> Bool
isCounterMultipleOfLock counter lock = remainderBy lock counter == 0

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ board, edges, player } as model) =
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
              Just (Node nodeId _) ->
                let
                  targetNodeId = player.targetNodeId
                  counter = player.counter
                  maybeEdge = getEdgeFromNodeIds nodeId targetNodeId edges
                in
                  case maybeEdge of
                    Nothing -> (model, Cmd.none)
                    Just (Edge edgeId edgeType _ _) ->
                      case edgeType of
                        Open -> ({ model | player = { player | targetNodeId = nodeId }}, Cmd.none)
                        Gated lock -> if isCounterMultipleOfLock counter lock
                                        then
                                          ({ model | player = { player | targetNodeId = nodeId, counter = counter + 1 }}, Cmd.none)
                                        else
                                          (model, Cmd.none)
    Frame delta ->
      let
        maybeNodePos = getCurrentNode player board
        {x, y} = player.currentPosition
      in
        case maybeNodePos of
          Nothing -> (model, Cmd.none)
          Just (i, j, Node id _) ->
            ({ model | player = {
              player | currentPosition =
                { x = calcPos (i * (boxSize + 5)) x, y = calcPos (j * (boxSize + 5)) y} }}, Cmd.none)

-- VIEW

view : Model -> Html Msg
view { board, edges, player } =
  let
    width = 5
    height = boxSize
    viewEdge : Edge -> Html Msg
    viewEdge edge =
      let
          (i, j, isHorizontal)  = edgeToPosition board edge
          rotation = if isHorizontal then "0" else "90"
      in
        div [ style "position" "absolute"
            , style "background-color" "black"
            , style "top" (String.fromFloat (i * toFloat (height + width) + width / 2) ++ "px")
            , style "left" (String.fromFloat ((0.5 + j) * toFloat (height + width) - width / 2) ++ "px")
            , style "width" (String.fromInt width ++ "px")
            , style "height" (String.fromInt height ++ "px")
            , style "transform" ("rotateZ(" ++ rotation ++ "deg)")
            , style "transform-origin" "center"
            ] [ "(" ++ String.fromFloat i ++ "," ++ String.fromFloat j ++ ")" |> text ]

    viewNode : Node -> Html Msg
    viewNode (Node id state) = div [ style "width" boxpx
                               , style "height" boxpx
                               , style "background-color" "#FFFFFF"
                               , style "display" "flex"
                               , style "justify-content" "center"
                               , style "align-items" "center"
                               , style "border" "1px solid red"
                               , style "box-sizing" "border-box"
                               , style "margin" (String.fromFloat (width / 2) ++ "px")
                               , class "node"
                               ] [ (if state == End then "★" else "") |> text ]

    viewRow : List Node -> Html Msg
    viewRow rows =
      div [ style "display" "flex" ]
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
            (div [ style "width" boxpx
                , style "height" boxpx
                , style "background-color" "#000000"
                , style "color" "white"
                , style "position" "absolute"
                , style "display" "flex"
                , style "justify-content" "center"
                , style "align-items" "center"
                , style "font-family" "arial"
                , style "font-size" "20px"
                , style "transform" ("translateX(" ++ String.fromInt x  ++ "px) translateY(" ++ String.fromInt y ++ "px)")
                ] [
                  div [] [ String.fromInt player.counter |> text ]
                  ]
                :: List.map viewEdge edges
                ++ List.map viewRow board)
        ]

-- Utils
calcPos : Int -> Int -> Int
calcPos a b = toFloat (a + b) * 0.5 |> round

