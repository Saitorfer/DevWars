module Main exposing (..)

import Browser
import Browser.Navigation
import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src, style)
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
    , body = [ viewHeader, viewContent, viewFooter ]
    }



--this header is fix


viewHeader =
    Html.div [ class "header" ]
        [ Html.button [ class "header-buttons" ] [ Html.text "Restart Game" ]
        , Html.div [ class "header-title" ] [ Html.text "DevWars" ]
        ]



--this is the content the value change depend on the Page


viewContent =
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
        ]



--this footer is fix


viewFooter =
    Html.div [ class "footer" ]
        [ Html.div [ class "footer-line" ] [ Html.a [ Html.Attributes.href "https://github.com" ] [ Html.text "GitHub" ] ]
        , Html.div [ class "footer-line" ] [ Html.a [ Html.Attributes.href "https://twitter.com" ] [ Html.text "Twitter" ] ]
        , Html.div [ class "footer-line" ] [ Html.a [ Html.Attributes.href "https://youtube.com" ] [ Html.text "YouTube" ] ]
        ]


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
