module Huebrynth exposing (..)


import Graph exposing (Graph)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main = Browser.sandbox {
    init = init,
    update = update,
    view = view
  }



-- MODEL


type alias Model = Int


myGraph : Graph String Int
myGraph =
    Graph.empty
        |> Graph.addVertex "foo"
        |> Graph.addEdge "foo" "bar" 100
        |> Graph.addEdge "foo" "baz" 200
        |> Graph.addEdge "bar" "baz" 300



init : Model
init =
  0



-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
