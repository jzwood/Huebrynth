module InputExample exposing (..)
import Html exposing (text, div, input, Attribute)
import Browser
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json


main =
  Browser.sandbox
  { init =
    { savedText = ""
    , currentText = ""
    }
  , view = view
  , update = update
  }


view model =
  div []
  [ input [onKeyDown CustomKeyDown, onInput Input ] []
  , div [] [ text ("Input: " ++ model.savedText) ]
  ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)


type Msg
  = NoOp
  | CustomKeyDown Int
  | Input String


update msg model =
  case msg of

    NoOp ->
      model

    CustomKeyDown key ->
      if key == 13 then
        { model | savedText = model.currentText }
      else
        model

    Input text ->
      { model | currentText = text }
