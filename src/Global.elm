module Global exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Credentials exposing (Credentials)
import Generated.Route exposing (Route)


type alias Flags =
    ()


type alias Model =
    { favoriteColor : String
    , credentials : Credentials
    }


type Msg
    = UpdateColor String
    | SetUsernamePassword String String
    | SetCredentials Credentials
    | NoUpdate


init : { navigate : Route -> Cmd msg } -> Flags -> ( Model, Cmd Msg, Cmd msg )
init _ _ =
    ( { favoriteColor = "Red"
      , credentials = Credentials.empty "http://localhost:8080/api/v1"
      }
    , Cmd.none
    , Cmd.none
    )


update : { navigate : Route -> Cmd msg } -> Msg -> Model -> ( Model, Cmd Msg, Cmd msg )
update app msg model =
    case msg of
        UpdateColor color ->
            ( { model | favoriteColor = color }, Cmd.none, Cmd.none )

        SetUsernamePassword username password ->
            let
                credentials1 =
                    Credentials.setUsername username model.credentials

                credentials2 =
                    Credentials.setPassword password credentials1
            in
            ( { model | credentials = credentials2 }
            , Cmd.none
            , Cmd.none
            )

        SetCredentials credentials ->
            ( { model | credentials = credentials }
            , Cmd.none
            , Cmd.none
            )

        NoUpdate ->
            ( model, Cmd.none, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
