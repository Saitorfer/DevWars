module Router exposing (..)

import Url
import Url.Parser


type Route
    = RouteSelectorPage
    | RouteGamePage


selectorPageParser : Url.Parser.Parser a a
selectorPageParser =
    Url.Parser.top


gameParser : Url.Parser.Parser a a
gameParser =
    Url.Parser.s "game"


routerParser : Url.Parser.Parser (Route -> c) c
routerParser =
    Url.Parser.oneOf
        [ Url.Parser.map RouteSelectorPage selectorPageParser
        , Url.Parser.map RouteGamePage gameParser
        ]


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    Url.Parser.parse routerParser url


asPath : Route -> String
asPath route =
    case route of
        RouteSelectorPage ->
            "/"

        RouteGamePage ->
            "/game"
