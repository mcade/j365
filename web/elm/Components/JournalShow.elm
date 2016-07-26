module Components.JournalShow exposing (..)

import Journal
import Html exposing (..)
import Html.Attributes exposing (href)

type Msg = NoOp

view : Journal.Model -> Html Msg
view model =
    div []
        [ h3 [] [ text model.title ]
        , a [ href model.url ] [ text ("URL: " ++ model.url) ]
        , br [] []
        , span [] [ text ("Posted by: " ++ model.postedBy ++ " On: " ++ model.postedOn) ]
        ]
