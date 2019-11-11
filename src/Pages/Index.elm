module Pages.Index exposing
    ( Model
    , Msg
    , page
    )

import Application.Page as Page
import Global
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Utils.Cmd


type alias Model =
    { color : String }


type Msg
    = GlobalMsg Global.Msg
    | SetColor String


page =
    Page.component
        { title = title
        , init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


title : Global.Model -> Model -> String
title global _ =
    global.favoriteColor


init : Global.Model -> () -> ( Model, Cmd Msg, Cmd Global.Msg )
init global _ =
    ( { color = global.favoriteColor }
    , Cmd.none
    , Cmd.none
    )


update : Global.Model -> Msg -> Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update _ msg model =
    case msg of
        GlobalMsg globalMsg ->
            ( model, Cmd.none, Utils.Cmd.send globalMsg )

        SetColor color ->
            ( { model | color = color }, Cmd.none, Cmd.none )


view : Global.Model -> Model -> Html Msg
view global model =
    div []
        [ h1 [] [ text "Homepage" ]
        , h3 [] [ text "Welcome to elm-spa!" ]
        , p []
            [ text "You should edit "
            , code [] [ text "src/Pages/Index.elm" ]
            , text " and see what happens!"
            ]
        , p []
            [ text "Favorite Color is set to "
            , text global.favoriteColor
            ]
        , p [] [ input [ placeholder "New Favorite Color", onInput SetColor ] [ text model.color ] ]
        , button [ onClick (GlobalMsg (Global.UpdateColor model.color)) ] [ text "Save" ]
        ]


subscriptions : Global.Model -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
