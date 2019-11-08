module Global exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Generated.Route exposing (Route)


type alias Flags =
    ()


type alias Model =
    { user : String
    , email : String
    }


type Msg
    = UpdateUser String
    | UpdateEmail String
    | NoUpdate


init : { navigate : Route -> Cmd msg } -> Flags -> ( Model, Cmd Msg, Cmd msg )
init _ _ =
    ( { user = "Joe"
      , email = "joe@foo.com"
      }
    , Cmd.none
    , Cmd.none
    )


update : { navigate : Route -> Cmd msg } -> Msg -> Model -> ( Model, Cmd Msg, Cmd msg )
update _ msg model =
    case msg of
        UpdateUser username ->
            ( { model | user = username }, Cmd.none, Cmd.none )

        UpdateEmail email ->
            ( { model | email = email }, Cmd.none, Cmd.none )

        NoUpdate ->
            ( model, Cmd.none, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
