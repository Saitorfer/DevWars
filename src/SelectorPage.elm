module SelectorPage exposing (..)

import Browser.Navigation
import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)
import Router


type Msg
    = MsgSelectLanguage
    | MsgStartGame
    | MsgValidateGameStart


type alias Model =
    { selectedLanguage : Maybe String
    , navigationKey : Browser.Navigation.Key
    }


initModel navigationKey =
    { selectedLanguage = Nothing
    , navigationKey = navigationKey
    }


view model =
    Html.div [ class "square" ]
        [ div [ class "button-container" ]
            [ button []
                [ img [ src "images/elm.png", alt "Imagen 1" ] []
                , text "Elm"
                ]
            , button []
                [ img [ src "images/java.png", alt "Imagen 2" ] []
                , text "Java"
                ]
            , button []
                [ img [ src "images/c-sharp.png", alt "Imagen 3" ] []
                , text "C#"
                ]
            , button []
                [ img [ src "images/kotlin.png", alt "Imagen 4" ] []
                , text "Kotlin"
                ]
            , button []
                [ img [ src "images/typescript.png", alt "Imagen 5" ] []
                , text "TypeScript"
                ]
            ]
        , div [ class "button-start-container" ]
            [ button [ class "button-start", onClick MsgValidateGameStart ] [ text "Start" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgSelectLanguage ->
            ( model, Cmd.none )

        MsgStartGame ->
            ( model, Browser.Navigation.pushUrl model.navigationKey (Router.asPath Router.RouteGamePage) )

        MsgValidateGameStart ->
            --The MsgStartGame give us the (model,cmd)
            update MsgStartGame model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
