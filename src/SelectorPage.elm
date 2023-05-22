module SelectorPage exposing (..)

import Browser.Navigation
import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)
import Router


type Msg
    = MsgSelectLanguage String
    | MsgStartGame
    | MsgValidateGameStart
    | MsgErrorLanguage


type alias Model =
    { selectedLanguage : Maybe String
    , navigationKey : Browser.Navigation.Key
    , error : String
    }


initModel navigationKey =
    { selectedLanguage = Nothing
    , navigationKey = navigationKey
    , error = ""
    }


view : Model -> Html.Html Msg
view model =
    div [ class "square" ]
        [ div [ class "button-container" ]
            [ viewButton model "elm"
            , viewButton model "java"
            , viewButton model "c-sharp"
            , viewButton model "kotlin"
            , viewButton model "typescript"
            ]
        , div [ class "button-start-container" ]
            [ button [ class "button-start", onClick MsgValidateGameStart ] [ text "Start" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgSelectLanguage language ->
            ( { model | selectedLanguage = Just language }, Cmd.none )

        MsgStartGame ->
            ( model, Browser.Navigation.pushUrl model.navigationKey (Router.asPath Router.RouteGamePage) )

        MsgValidateGameStart ->
            --The MsgStartGame give us the (model,cmd) | recursividad
            if isNotNull model then
                update MsgStartGame model

            else
                update MsgErrorLanguage model

        MsgErrorLanguage ->
            ( { model | error = "Please select a Language to play" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewButton : Model -> String -> Html.Html Msg
viewButton model language =
    let
        buttonClass =
            if isSelected model language then
                "selected-button"

            else
                "button"
    in
    button [ class buttonClass, onClick (MsgSelectLanguage language) ]
        [ img [ src ("images/" ++ language ++ ".png"), alt ("Imagen " ++ language) ] []
        , text language
        ]


isSelected model language =
    case model.selectedLanguage of
        Just selected ->
            selected == language

        Nothing ->
            False


isNotNull model =
    case model.selectedLanguage of
        Just language ->
            True

        Nothing ->
            False
