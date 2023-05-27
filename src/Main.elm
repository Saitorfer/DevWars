module Main exposing (..)

import Browser
import Browser.Navigation
import GamePage
import Html
import Html.Attributes exposing (class)
import Router
import SelectorPage exposing (Msg(..))
import Url


type Msg
    = MsgUrlChanged Url.Url
    | MsgUrlRequested Browser.UrlRequest
    | MsgSelectorPage SelectorPage.Msg
    | MsgGamePage GamePage.Msg


type alias Model =
    { url : Url.Url
    , navigationKey : Browser.Navigation.Key
    , modelSelectorPage : SelectorPage.Model
    , modelGamePage : GamePage.Model
    }


initModel : Url.Url -> Browser.Navigation.Key -> Model
initModel url navigationKey =
    { url = url
    , navigationKey = navigationKey
    , modelSelectorPage = SelectorPage.initModel navigationKey
    , modelGamePage = GamePage.initModel
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
    ( initModel url navigationKey, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "DevWars"
    , body =
        [ viewHeader
        , viewPage model
        , viewFooter
        ]
    }



--this header is fix


viewHeader : Html.Html msg
viewHeader =
    Html.div [ class "header" ]
        [ Html.button [ class "header-buttons" ] [ Html.text "Restart Game" ]
        , Html.div [ class "header-title" ] [ Html.text "DevWars" ]
        ]



--this is the content the value change depend on the Page


viewPage : Model -> Html.Html Msg
viewPage model =
    let
        --un console.log
        _ =
            Debug.log "modelo actual" model
    in
    case Router.fromUrl model.url of
        Just Router.RouteSelectorPage ->
            Html.map MsgSelectorPage (SelectorPage.view model.modelSelectorPage)

        Just Router.RouteGamePage ->
            --actualizar en un let in el model
            let
                language =
                    converterLanguage <| model.modelSelectorPage.selectedLanguage

                newModelGame =
                    GamePage.initGame model.modelGamePage language
            in
            Html.map MsgGamePage (GamePage.view newModelGame)

        Nothing ->
            Html.text "Not found 404"



--this footer is fix


viewFooter : Html.Html msg
viewFooter =
    Html.div [ class "footer" ]
        [ viewLink "https://github.com/Saitorfer" "GitHub"
        , viewLink "https://twitter.com/saitorfer" "Twitter"
        , viewLink "https://www.youtube.com/@saitorfer" "YouTube"
        ]


viewLink : String -> String -> Html.Html msg
viewLink link text =
    Html.div
        [ class "footer-line" ]
        [ Html.a [ Html.Attributes.href link, Html.Attributes.target "_blank" ]
            [ Html.text text ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgUrlChanged url ->
            ( { model | url = url }, Cmd.none )

        MsgUrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.navigationKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        MsgSelectorPage msgSelectorPage ->
            let
                ( newSelectorPageModel, cmdSelectorPage ) =
                    SelectorPage.update msgSelectorPage model.modelSelectorPage
            in
            ( { model | modelSelectorPage = newSelectorPageModel }
            , Cmd.map MsgSelectorPage cmdSelectorPage
            )

        MsgGamePage msgGamePage ->
            let
                ( newGamePageModel, cmdGamePage ) =
                    GamePage.update msgGamePage model.modelGamePage
            in
            ( { model | modelGamePage = newGamePageModel }
            , Cmd.map MsgGamePage cmdGamePage
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map MsgSelectorPage (SelectorPage.subscriptions model.modelSelectorPage)
        , Sub.map MsgGamePage (GamePage.subscriptions model.modelGamePage)
        ]


onUrlChange : Url.Url -> Msg
onUrlChange url =
    MsgUrlChanged url


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest urlRequest =
    MsgUrlRequested urlRequest



--converter language to Int


converterLanguage : Maybe String -> Int
converterLanguage language =
    case language of
        Just "java" ->
            1

        Just "typescript" ->
            2

        Just "kotlin" ->
            3

        Just "elm" ->
            4

        Just "c-sharp" ->
            5

        _ ->
            4
