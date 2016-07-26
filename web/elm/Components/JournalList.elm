module Components.JournalList exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List
import Journal
import Http
import Task
import Json.Decode as Json exposing ((:=))
import Debug

-- model
type alias Model =
    { journals : List Journal.Model }

initialModel : Model
initialModel =
    { journals = [] }

-- update
type Msg
    = NoOp
    | Fetch
    | FetchSucceed (List Journal.Model)
    | FetchFail Http.Error
    | RouteToNewPage SubPage

type SubPage
    = ListView
    | ShowView Journal.Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        Fetch ->
            (model, fetchJournals)
        FetchSucceed journalList ->
            (Model journalList, Cmd.none)
        FetchFail error ->
            case error of
                Http.UnexpectedPayload errorMessage ->
                    Debug.log errorMessage
                    (model, Cmd.none)
                _ ->
                    (model, Cmd.none)
        _ ->
            (model, Cmd.none)

journals : Model
journals =
    { journals =
          [ { title = "Journal 1", url = "http://google.com", postedBy = "Author", postedOn = "6/25/16" }
          , { title = "Journal 2", url = "http://google.com", postedBy = "Author 2", postedOn = "6/26" }
          , { title = "Journal 3", url = "http://google.com", postedBy = "Author 3", postedOn = "6/27" }
    ] }

-- HTTP calls

fetchJournals : Cmd Msg
fetchJournals =
    let
        url = "/api/journals"
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeJournalFetch url)

-- Fetch the journals out of the "data" key
decodeJournalFetch : Json.Decoder (List Journal.Model)
decodeJournalFetch =
    Json.at ["data"] decodeJournalList

-- Then decode the "data" key into a List of Journal.Models
decodeJournalList : Json.Decoder (List Journal.Model)
decodeJournalList =
    Json.list decodeJournalData

-- Finally, build the decoder for each individual Journal.Model
decodeJournalData : Json.Decoder Journal.Model
decodeJournalData =
    Json.object4 Journal.Model
        ("title" := Json.string)
        ("url" := Json.string)
        ("posted_by" := Json.string)
        ("posted_on" := Json.string)



--view

journalLink : Journal.Model -> Html Msg
journalLink journal =
    a
        [ href ("#journal/" ++ journal.title ++ "/show")
        , onClick (RouteToNewPage (ShowView journal))
        ]
        [ text " (Show)" ]

renderJournal : Journal.Model -> Html Msg
renderJournal journal =
    li [] [
         div [] [ Journal.view journal, journalLink journal ]
    ]

renderJournals : Model -> List (Html Msg)
renderJournals model =
    List.map renderJournal model.journals

view: Model -> Html Msg
view model =
    div [ class "journal-list" ]
        [ h2 [] [ text "Journal List" ]
        , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Journals" ]
        , ul [] (renderJournals model) ]
