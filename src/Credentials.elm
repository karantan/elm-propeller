module Credentials exposing
    ( Credentials
    , empty
    , getUsername
    , hasToken
    , sendAuthenticationRequest
    , setPassword
    , setToken
    , setUsername
    )

{-| Secure wrapper for user credentials

The goal of this module is to make it very difficult to accidentally leak
sensitive user information: e-mail address, password or authentication token.
This is an implementation of the exit gatekeeper technique described here:
<https://incrementalelm.com/articles/exit-gatekeepers>

-}

import Html exposing (Html)
import Http
import Json.Decode
import Json.Encode
import Url.Builder


{-| Opaque type for credentials (username, password and token).

**Warning**: Do not ever expose the constructor!

Here is how it works. There is a `Credentials` type that has one constructor
(also called `Credentials`). The constructor will take a data structure
containing actual credentials. The most important trick is that the type is
exposed (so you can annotate your code in other modules with it) but not the
constructor. This pattern is called opaque type and you can read about it here
<https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2>.

That way the only place where the raw data can be accessed is this module (when
the code is compiled in production; in development you can use `Debug.toString`
and then parse the string).

-}
type Credentials
    = Credentials
        { username : String
        , password : String
        , token : Maybe String
        , apiURL : String
        , distinctId : Maybe String
        }



-- CREATE
-- Create an empty `Credentials` value


empty : String -> Credentials
empty apiURL =
    Credentials
        { username = ""
        , password = ""
        , token = Nothing
        , apiURL = apiURL
        , distinctId = Nothing
        }



-- UPDATE


setUsername : String -> Credentials -> Credentials
setUsername value (Credentials credentials) =
    Credentials { credentials | username = value }


setPassword : String -> Credentials -> Credentials
setPassword value (Credentials credentials) =
    Credentials { credentials | password = value }


setToken : String -> Credentials -> Credentials
setToken value (Credentials credentials) =
    Credentials { credentials | token = Just value }


hasToken : Credentials -> Bool
hasToken (Credentials credentials) =
    case credentials.token of
        Nothing ->
            False

        Just _ ->
            True


getUsername : Credentials -> String
getUsername (Credentials credentials) =
    credentials.username


sendAuthenticationRequest : (Result Http.Error Credentials -> msg) -> Credentials -> Cmd msg
sendAuthenticationRequest callback (Credentials credentials) =
    let
        credentialsDecoder : Json.Decode.Decoder Credentials
        credentialsDecoder =
            Json.Decode.map2
                (\token id ->
                    { credentials
                        | token = Just token
                        , distinctId = Just id
                    }
                )
                (Json.Decode.field "token" Json.Decode.string)
                (Json.Decode.field "distinct_id" Json.Decode.string)
                |> Json.Decode.map Credentials

        body =
            [ ( "email"
              , credentials.username |> Json.Encode.string
              )
            , ( "password"
              , credentials.password |> Json.Encode.string
              )
            ]
                |> Json.Encode.object
                |> Http.jsonBody

        url =
            Url.Builder.crossOrigin credentials.apiURL
                [ "user", "login" ]
                []
    in
    Http.request
        { method = "POST"
        , headers = []
        , url = url
        , body = body
        , expect =
            Http.expectJson callback credentialsDecoder
        , timeout = Just 30000
        , tracker = Nothing
        }
