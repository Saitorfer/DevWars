module GamePage exposing (..)

import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src)


type alias Model =
    { title : String
    }


type Msg
    = MsgDummy


view model =
    Html.div [ class "square" ]
        []


initModel : Model
initModel =
    { title = "Test"
    }


update msg model =
    case msg of
        MsgDummy ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
