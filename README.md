# Elm Propeller

This is the most basic showcase of how Global aka Shared State works. In `Global.elm` we
define global state which is passed to Pages if we define a page as `Page.component`
(full-blown page, that can view and update global state).

In `Global.elm` we need to define how Global Model is updated and we allow only those
update calls. With this, we prevent other modules to change global state. For example,
we can't do something like

```
SetUsername username -> ( { global | user = username }, Cmd.none, Cmd.none )
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

## local development

1. `npm install`

1. `npm run dev`


## project structure

```elm
src/
  Components/  -- reusable bits of UI
  Layouts/     -- views that render pages
  Pages/       -- where pages live
  Global.elm   -- info shared across pages
  Main.elm     -- entrypoint to app
```
