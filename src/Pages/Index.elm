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
    { username : String
    , email : String
    }


type Msg
    = GlobalMsg Global.Msg
    | SetUsername String
    | SetEmail String


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
    global.user


init : Global.Model -> () -> ( Model, Cmd Msg, Cmd Global.Msg )
init global _ =
    ( { username = global.user
      , email = global.email
      }
    , Cmd.none
    , Cmd.none
    )


update : Global.Model -> Msg -> Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update _ msg model =
    case msg of
        GlobalMsg globalMsg ->
            ( model, Cmd.none, Utils.Cmd.send globalMsg )

        SetEmail email ->
            ( { model | email = email }, Cmd.none, Cmd.none )

        SetUsername username ->
            ( { model | username = username }, Cmd.none, Cmd.none )


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
            [ text "username is set to "
            , text global.user
            ]
        , p [] [ input [ placeholder "New Username", onInput SetUsername ] [ text model.username ] ]
        , button [ onClick (GlobalMsg (Global.UpdateUser model.username)) ] [ text "Save Username" ]
        , p [] [ text "email is set to ", text global.email ]
        , p [] [ input [ placeholder "New Email", onInput SetEmail ] [ text model.email ] ]
        , button [ onClick (GlobalMsg (Global.UpdateEmail model.email)) ] [ text "Save Email" ]
        ]


subscriptions : Global.Model -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
