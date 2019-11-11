# Elm Propeller

This is the most basic showcase of how Global aka Shared State works. In `Global.elm` we
define global state which is passed to Pages if we define a page as `Page.component`
(full-blown page, that can view and update global state).

In `Global.elm` we need to define how Global Model is updated and we allow only those
update calls. With this, we prevent other modules to change global state. For example,
we can't do something like

```elm
SetColor color -> ( { global | favoriteColor = color }, Cmd.none, Cmd.none )
```

in e.g. `Index.elm` because it doesn't match the return type which is
`Model, Cmd Msg, Cmd Global.Msg` and in this case, it would be
`Global.Model, Cmd Msg, Cmd Global.Msg`.

The message type `GlobalMsg Global.Msg` is introduced in every submodule which needs to
update the state. This makes the update functions both smaller and more easily extensible.

Additional resources on Shared State:
- [Shared State in Elm](https://www.curry-software.com/en/blog/elm_shared_state/)
- [Elm Shared State example](https://github.com/ohanhi/elm-shared-state)

This project was generated from [`elm-spa init`](https://github.com/ryannhg/elm-spa).

## Opaque type

> Opaque types are types that hide their internal implementation details within a module.

An even more advanced technique is to use [opaque type](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2). In e.g. `Credentials.elm` you define
opaque type which means you cannot access e.g. `credentials.token` directly from e.g.
`Global.elm` even if you have it stored in your Shared State. What you need to do is
to define a way to update the credentials by calling `Credentials` exposed functions
in `Global.elm` like this:

```elm
update : { navigate : Route -> Cmd msg } -> Msg -> Model -> ( Model, Cmd Msg, Cmd msg )
update app msg model =
    case msg of
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
          ...
```
This way you encapsulate `Credentials` module and you can easily move it around your
projects without fearing that some other code will mess up its functionality.

## How does it work?

Run it with `npm run dev` and navigate to the index page. Your Favorite Color is set to
Red by default and if you change it to e.g. "Green" it will be stored to the Global Model
aka Shared State. As a result you can navigate to different pages and you won't lose this
information.

The second functionality is to show how API login works with this technique. For this 
you need an actual server that has the following API:

```yaml
  /user/login:
    post:
      summary: Existing user login
      description: Login for existing user
      tags:
        - User and Authentication
      operationId: Login
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                password:
                  type: string
                  format: password
              required:
                - email
                - password
        description: Credentials to use
        required: true
      responses:
        "200":
          type: object
          properties:
            email:
              type: string
            token:
              type: string
            username:
              type: string
            distinct_id:
              type: string
          required:
            - email
            - token
            - username
            - distinct_id
        "401":
          description: Unauthorized
        "500":
          type: object
          properties:
            errors:
              type: array
              items:
                type: string
          required:
            - errors
```

Navigate to the Sign In page and enter username and password. If the login is successful
the page title will change to the username (i.e. `global.credentials.email`). Again, if
you navigate to e.g. index page and then back your credentials won't be lost.

Shared State will be lost if you reload the page. To overcome this you need to store the
state to your browser storage or cookies via ports.
See: https://github.com/rtfeldman/elm-spa-example/blob/master/src/Api.elm#L98-L120 and
https://github.com/rtfeldman/elm-spa-example/blob/master/index.html#L29-L39

## Local development

1. `npm install`

1. `npm run dev`


## Project structure

```elm
src/
  Components/         -- reusable bits of UI
  Layouts/            -- views that render pages
  Pages/              -- where pages live
  Credentials.elm     -- Credentials opaque type definition
  Global.elm          -- info shared across pages
  Main.elm            -- entrypoint to app
```
