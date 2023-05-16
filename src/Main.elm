module Main exposing (..)
import Browser


type Msg
    = MsgUrlChanged Url.Url 
    | MsgUrlRequested Browser.UrlRequest
    | MsgSelectorPage 
    | MsgGamePage

type alias Model {
     url : Url.Url
    , navigationKey : Browser.Navigation.Key
    , modelSelectorPage : SelectorPage.Model
    , modelGame : GamePage.Model
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

init : () -> Url.Url -> Navigation.Key -> ( model, Cmd msg )
init _  url navigationKey= 
    (initModel url navigationKey, Cmd.none)

