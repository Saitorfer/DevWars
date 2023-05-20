module SelectorPage exposing (..)

import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src)


type Msg
    = MsgSelectLanguage
    | MsgStartGame


type alias Model =
    { selectedLanguage : Maybe String
    }


initModel =
    { selectedLanguage = Nothing
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
            [ button [ class "button-start" ] [ text "Start" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd.Cmd Msg )
update msg model =
    case msg of
        MsgSelectLanguage ->
            ( model, Cmd.none )

        MsgStartGame ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
