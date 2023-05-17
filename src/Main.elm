module Main exposing (..)

import Browser
import Browser.Navigation
import Html
import Url


type Msg
    = MsgDummy



--= MsgUrlChanged Url.Url
--| MsgUrlRequested Browser.UrlRequest
--| MsgSelectorPage
--| MsgGamePage


type alias Model =
    { title : String
    }



--url : Url.Url
--, navigationKey : Browser.Navigation.Key
--, modelSelectorPage : SelectorPage.Model
--, modelGame : GamePage.Model


initModel =
    { title = "Hello Navigation"
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navigationKey =
    ( initModel, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Test"
    , body = [ viewContent ]
    }


viewContent =
    Html.text "Test"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgDummy ->
            ( model, Cmd.none )


subscriptions : model -> Sub msg
subscriptions model =
    Sub.none


onUrlChange : Url.Url -> Msg
onUrlChange url =
    MsgDummy


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest urlRequest =
    MsgDummy
