module Pages.SignIn exposing
    ( Model
    , Msg
    , page
    )

import Application.Page as Page
import Credentials exposing (Credentials)
import Generated.Route as Route
import Global
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events
import Http
import Utils.Cmd


type alias Model =
    { username : String
    , password : String
    }


type Msg
    = Updated Field String
    | GlobalMsg Global.Msg
    | AuthenticationResponse (Result Http.Error Credentials)
    | LoginFormSubmitted


type Field
    = Username
    | Password


page =
    Page.component
        { title = title
        , init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


title : Global.Model -> Model -> String
title global _ =
    if Credentials.hasToken global.credentials then
        Credentials.getUsername global.credentials

    else
        "Sign In"


init : Global.Model -> () -> ( Model, Cmd Msg, Cmd Global.Msg )
init _ _ =
    ( { username = ""
      , password = ""
      }
    , Cmd.none
    , Cmd.none
    )


update : Global.Model -> Msg -> Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update global msg model =
    case msg of
        Updated Username username ->
            ( { model | username = username }
            , Cmd.none
            , Cmd.none
            )

        Updated Password password ->
            ( { model | password = password }
            , Cmd.none
            , Cmd.none
            )

        GlobalMsg globalMsg ->
            ( model, Cmd.none, Utils.Cmd.send globalMsg )

        LoginFormSubmitted ->
            ( model
            , global.credentials
                |> Credentials.sendAuthenticationRequest AuthenticationResponse
            , Cmd.none
            )

        AuthenticationResponse (Err error) ->
            ( model
            , Cmd.none
            , Cmd.none
            )

        AuthenticationResponse (Ok credentials) ->
            ( model
            , Cmd.none
            , Utils.Cmd.send (Global.SetCredentials credentials)
            )


subscriptions : Global.Model -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


view : Global.Model -> Model -> Html Msg
view _ model =
    div []
        [ h1 [] [ text "Sign in" ]
        , Html.form
            [ Events.onSubmit LoginFormSubmitted ]
            [ viewInput
                { label = "Username"
                , value = model.username
                , onInput = Updated Username
                , type_ = "text"
                }
            , viewInput
                { label = "Password"
                , value = model.password
                , onInput = Updated Password
                , type_ = "password"
                }
            , button [ Events.onClick (GlobalMsg (Global.SetUsernamePassword model.username model.password)) ] [ text "Sign in" ]
            ]
        ]


viewInput :
    { label : String
    , value : String
    , onInput : String -> msg
    , type_ : String
    }
    -> Html msg
viewInput config =
    label
        [ Attr.style "display" "flex"
        , Attr.style "flex-direction" "column"
        , Attr.style "align-items" "flex-start"
        , Attr.style "margin" "1rem 0"
        ]
        [ span [] [ text config.label ]
        , input
            [ Attr.type_ config.type_
            , Events.onInput config.onInput
            , Attr.value config.value
            ]
            []
        ]
