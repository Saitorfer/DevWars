port module GamePage exposing (..)

import Browser.Navigation
import Html exposing (button, div, img, text)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)
import List
import Router


type alias Attack =
    { name : String
    , damage : Int
    }


type alias Player =
    { language : String
    , languageNumber : Int
    , attackList : List Attack
    , hp : Int
    , image : String
    }


type alias Model =
    { player : Player
    , machine : Player
    , round : Int
    , winner : Maybe String
    , randomNumber : Int
    , navigationKey : Browser.Navigation.Key
    }


type Msg
    = MsgVictory
    | MsgPlayerAttack String
    | MsgMachineAttack
    | MsgRestart
    | GenerateRandomNumber
    | GotRandomNumber Int


initModel : Browser.Navigation.Key -> Model
initModel navigationKey =
    let
        initPlayer =
            { language = ""
            , attackList = []
            , hp = 0
            , languageNumber = 1
            , image = ""
            }
    in
    { player = initPlayer
    , machine = initPlayer
    , round = 1
    , winner = Nothing
    , randomNumber = 0
    , navigationKey = navigationKey
    }


initGame : Browser.Navigation.Key -> Model -> Int -> Model
initGame navigationKey model language =
    { player = initPlayers model language
    , machine = initPlayers model (randomNumber language)
    , round = 1
    , winner = Nothing
    , randomNumber = 0
    , navigationKey = navigationKey
    }



--init the player and machine parameters


initPlayers : Model -> Int -> Player
initPlayers _ language =
    case language of
        1 ->
            { language = "java", attackList = javaAttacks, hp = 100, languageNumber = language, image = "images/java.png" }

        2 ->
            { language = "typescript", attackList = tsAttacks, hp = 100, languageNumber = language, image = "images/typescript.png" }

        3 ->
            { language = "kotlin", attackList = kotlinAttacks, hp = 100, languageNumber = language, image = "images/kotlin.png" }

        4 ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = language, image = "images/elm.png" }

        5 ->
            { language = "c#", attackList = cAttacks, hp = 100, languageNumber = language, image = "images/c-sharp.png" }

        _ ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = language, image = "images/elm.png" }


view : Model -> Html.Html Msg
view model =
    Html.div [ class "square" ]
        [ case model.winner of
            Just _ ->
                viewWinner model

            Nothing ->
                viewCombat model.player model.machine
        ]



--all the views


viewAttackButton : Attack -> Html.Html Msg
viewAttackButton attack =
    button [ class "buttonGame", onClick (MsgPlayerAttack attack.name) ] [ text attack.name ]


viewCombat : Player -> Player -> Html.Html Msg
viewCombat player machine =
    let
        hpText1 =
            div [ class "hp-text" ] [ text <| "HP: " ++ String.fromInt player.hp ]

        hpText2 =
            div [ class "hp-text" ] [ text <| "HP: " ++ String.fromInt machine.hp ]

        combatElements =
            [ div [ class "image-container bottom-left-image" ]
                [ img [ src player.image, alt "Imagen 1" ] []
                , hpText1
                ]
            , div [ class "image-container top-right-image" ]
                [ img [ src machine.image, alt "Imagen 2" ] []
                , hpText2
                ]
            ]
    in
    div [ class "combat-container" ]
        (combatElements
            ++ [ div [ class "buttonGame-container" ]
                    (List.map viewAttackButton player.attackList)
               ]
        )


viewWinner : Model -> Html.Html Msg
viewWinner model =
    let
        winnerText =
            case model.winner of
                Just winner ->
                    div [] [ text ("The winner is: " ++ winner) ]

                Nothing ->
                    div [] []
    in
    div [ class "square" ]
        [ div [ class "centered-text" ] [ winnerText ]
        , div [ class "centered-button" ]
            [ button [ class "button-start", onClick MsgRestart ] [ text "Restart" ]
            ]
        ]



--update


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgVictory ->
            let
                newModel =
                    { model | winner = victory model.player model.machine }
            in
            ( newModel, Cmd.none )

        MsgMachineAttack ->
            let
                --if the machine hp = 0 then it dont attack
                newModel =
                    if model.machine.hp == 0 then
                        model

                    else
                        machineLogic model
            in
            update MsgVictory newModel

        MsgPlayerAttack attack ->
            let
                playerSelectedAttack =
                    stringToAttack model.player.attackList attack

                newModel =
                    playerLogic model playerSelectedAttack
            in
            update GenerateRandomNumber newModel

        MsgRestart ->
            ( model, Browser.Navigation.pushUrl model.navigationKey (Router.asPath Router.RouteSelectorPage) )

        GenerateRandomNumber ->
            ( model, generateRandomNumber () )

        GotRandomNumber number ->
            let
                _ =
                    Debug.log ("The number is: " ++ String.fromInt number)

                newModel =
                    { model | randomNumber = number }
            in
            update MsgMachineAttack newModel


subscriptions : Model -> Sub Msg
subscriptions _ =
    gotRandomNumber GotRandomNumber



--Ports


port generateRandomNumber : () -> Cmd msg


port gotRandomNumber : (Int -> msg) -> Sub msg


initGameCmd : Model -> Cmd Msg
initGameCmd _ =
    Cmd.none



--Check if the player or the machine has no more hp


victory : Player -> Player -> Maybe String
victory player machine =
    let
        hpPlayer =
            player.hp

        hpMachine =
            machine.hp
    in
    if hpPlayer == 0 then
        Just "machine"

    else if hpMachine == 0 then
        Just "player"

    else
        Nothing



--player logic


playerLogic : Model -> Attack -> Model
playerLogic model attack =
    let
        --damage hp of the player
        newMachineHp =
            takeDamage attack model.machine
    in
    --update the model of the player
    { model | machine = newMachineHp }


stringToAttack : List Attack -> String -> Attack
stringToAttack attackList str =
    let
        lowercaseStr =
            String.toLower str

        matchingAttacks =
            List.filter (\attack -> String.toLower attack.name == lowercaseStr) attackList
    in
    case matchingAttacks of
        [ attack ] ->
            attack

        _ ->
            { name = "Punch", damage = 5 }



--take damage function


takeDamage : Attack -> Player -> Player
takeDamage attack player =
    let
        damage =
            attack.damage

        hp =
            player.hp

        --using max hpCalculate never be under 0
        hpCalculate =
            max 0 (hp - damage)
    in
    { player | hp = hpCalculate }



--machine logic to make an attack and damage the player hp


machineLogic : Model -> Model
machineLogic model =
    let
        --determine the attack
        attackUsed =
            machineAttack model

        --damage hp of the player
        newPlayerHp =
            takeDamage attackUsed model.player
    in
    --update the model of the player
    { model | player = newPlayerHp }


machineAttack : Model -> Attack
machineAttack model =
    --getFirstAttack model
    let
        --the random Function give us a msg, not an Int so we need to traduce it
        randomNumberAttack =
            model.randomNumber

        attackList =
            model.machine.attackList

        _ =
            Debug.log ("The random attack is number: " ++ String.fromInt randomNumberAttack)
    in
    case List.drop randomNumberAttack attackList |> List.head of
        Just attack ->
            attack

        Nothing ->
            { name = "Punch", damage = 5 }



--not used now


getFirstAttack : Model -> Attack
getFirstAttack model =
    case List.head model.machine.attackList of
        Just attack ->
            attack

        Nothing ->
            { name = "Punch", damage = 5 }



--give an opponent


randomNumber : Int -> Int
randomNumber excludedNum =
    case excludedNum of
        1 ->
            4

        2 ->
            3

        3 ->
            5

        4 ->
            1

        5 ->
            2

        _ ->
            1



--attacks mocks


javaAttacks : List Attack
javaAttacks =
    [ { name = "Multi-thread abilities", damage = 5 }
    , { name = "Very Strong community", damage = 10 }
    , { name = "Can use Lambda", damage = 15 }
    , { name = "Minecraft use me!!!!", damage = 20 }
    ]


elmAttacks : List Attack
elmAttacks =
    [ { name = "First class citizenship", damage = 5 }
    , { name = "Immutable data structures", damage = 10 }
    , { name = "Pure functions everywhere", damage = 15 }
    , { name = "Friendliest error messages", damage = 20 }
    ]


kotlinAttacks : List Attack
kotlinAttacks =
    [ { name = "Can use Lambdas", damage = 5 }
    , { name = "Can use Functional Programming", damage = 10 }
    , { name = "Integrate in Android Studio", damage = 15 }
    , { name = "Java but better", damage = 20 }
    ]


cAttacks : List Attack
cAttacks =
    [ { name = "Microsoft", damage = 5 }
    , { name = "Best IDE ever", damage = 10 }
    , { name = "Integrate in Unity", damage = 15 }
    , { name = "Just-in-time compiler", damage = 20 }
    ]


tsAttacks : List Attack
tsAttacks =
    [ { name = "Super-used", damage = 5 }
    , { name = "Big community", damage = 10 }
    , { name = "Use Types", damage = 15 }
    , { name = "Rich set of tools", damage = 20 }
    ]
