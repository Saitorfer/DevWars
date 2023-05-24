module GamePage exposing (..)

import Html exposing (button, div, img, main_, text)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)
import List exposing (filter, indexedMap)


type alias Attack =
    { name : String
    , damage : Int
    }


type alias Player =
    { language : String
    , languageNumber : Int
    , attackList : List Attack
    , hp : Int
    }


type alias Model =
    { player : Player
    , machine : Player
    , round : Int
    , winner : Maybe String
    }


type Msg
    = MsgVictory
    | MsgPlayerAttack String
    | MsgMachineAttack
    | MsgRestart
    | MsgInitGame


initModel : Model
initModel =
    { player = { language = "", attackList = [], hp = 0, languageNumber = 1 }
    , machine = { language = "", attackList = [], hp = 0, languageNumber = 1 }
    , round = 1
    , winner = Nothing
    }


initGame : Model -> Model
initGame model =
    { player = initPlayer model
    , machine = initMachine model
    , round = 1
    , winner = Nothing
    }


initPlayer : Model -> Player
initPlayer model =
    let
        language =
            model.player.languageNumber
    in
    case language of
        1 ->
            { language = "java", attackList = javaAttacks, hp = 100, languageNumber = language }

        2 ->
            { language = "typescript", attackList = tsAttacks, hp = 100, languageNumber = language }

        3 ->
            { language = "kotlin", attackList = kotlinAttacks, hp = 100, languageNumber = language }

        4 ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = language }

        5 ->
            { language = "c#", attackList = cAttacks, hp = 100, languageNumber = language }

        _ ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = language }


initMachine model =
    let
        --generate a number between 1 and 5 but exclude the number of the player
        number =
            randomNumber model.player.languageNumber
    in
    case number of
        1 ->
            { language = "java", attackList = javaAttacks, hp = 100, languageNumber = number }

        2 ->
            { language = "typescript", attackList = tsAttacks, hp = 100, languageNumber = number }

        3 ->
            { language = "kotlin", attackList = kotlinAttacks, hp = 100, languageNumber = number }

        4 ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = number }

        5 ->
            { language = "c#", attackList = cAttacks, hp = 100, languageNumber = number }

        _ ->
            { language = "elm", attackList = elmAttacks, hp = 100, languageNumber = number }


view : Model -> Html.Html Msg
view model =
    Html.div [ class "square" ]
        [ case model.winner of
            Just _ ->
                viewWinner model

            Nothing ->
                viewCombat model.player
        ]



--all the viewa


viewAttackButton : Attack -> Html.Html Msg
viewAttackButton attack =
    button [ class "buttonGame" ] [ text attack.name ]


viewCombat : Player -> Html.Html Msg
viewCombat player =
    div [ class "buttonGame-container" ]
        (List.map viewAttackButton player.attackList)


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
            update MsgMachineAttack newModel

        MsgRestart ->
            ( model, Cmd.none )

        MsgInitGame ->
            ( initGame model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


initGameCmd : Model -> Cmd Msg
initGameCmd model =
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
        Just "player"

    else if hpMachine == 0 then
        Just "machine"

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
    getFirstAttack model


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



--attacks


javaAttacks : List Attack
javaAttacks =
    [ { name = "Multi-thread abilities", damage = 5 }
    , { name = "Very Strong community", damage = 10 }
    , { name = "Can use Lambda", damage = 15 }
    , { name = "Minecraft use me!!!!", damage = 20 }
    ]


elmAttacks : List Attack
elmAttacks =
    [ { name = "Punch", damage = 5 }
    , { name = "Kick", damage = 10 }
    , { name = "Fireball", damage = 15 }
    , { name = "Fireball", damage = 20 }
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
