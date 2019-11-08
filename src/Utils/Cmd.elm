module Utils.Cmd exposing (send)

import Task

send : msg -> Cmd msg
send msg =
    Task.perform identity (Task.succeed msg)