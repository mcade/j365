module Main exposing (..)

import Html exposing (div, text, Html, h2, a, li, ul, h1)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Html.App

import Components.JournalList as JournalList
import Components.JournalShow as JournalShow
import Journal

-- model

type alias Model =
    { journalListModel : JournalList.Model
    , currentView : Page
    }

initialModel : Model
initialModel =
    { journalListModel = JournalList.initialModel
    , currentView = RootView
    }

init : (Model, Cmd Msg)
init =
    ( initialModel, Cmd.none)


-- update

type Msg
    = JournalListMsg JournalList.Msg
    | UpdateView Page
    | JournalShowMsg JournalShow.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        JournalListMsg journalMsg ->
            case journalMsg of
                JournalList.RouteToNewPage page ->
                    case page of
                        JournalList.ShowView journal ->
                            ({ model | currentView = (JournalShowView journal) }, Cmd.none)
                        _ ->
                            (model, Cmd.none)
                _ ->
                    let (updatedModel, cmd) = JournalList.update journalMsg model.journalListModel
                    in ( { model | journalListModel = updatedModel }, Cmd.map JournalListMsg cmd )
        UpdateView page ->
            case page of
                JournalListView ->
                    ({ model | currentView = page }, Cmd.map JournalListMsg JournalList.fetchJournals)
                _ ->
                    ({ model | currentView = page }, Cmd.none)
        JournalShowMsg  journalMsg ->
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

type Page
    = RootView
    | JournalListView
    | JournalShowView Journal.Model

-- view

welcomeView : Html Msg
welcomeView =
    h2 [] [ text "Welcome to Elm Journals!" ]

journalListView : Model -> Html Msg
journalListView model =
    Html.App.map JournalListMsg (JournalList.view model.journalListModel)

journalShowView : Journal.Model -> Html Msg
journalShowView journal =
    Html.App.map JournalShowMsg (JournalShow.view journal)

pageView : Model -> Html Msg
pageView model =
    case model.currentView of
        RootView ->
            welcomeView
        JournalListView ->
            journalListView model
        JournalShowView journal ->
            journalShowView journal

header : Html Msg
header =
    div []
        [ h1 [] [ text "Elm Journals" ]
        , ul []
            [ li [] [ a [ href "#", onClick (UpdateView RootView) ] [ text "Home" ] ]
            , li [] [ a [ href "#articles", onClick (UpdateView JournalListView) ] [ text "Journals" ] ]
            ]
        ]

view : Model -> Html Msg
view model =
    div [ class "elm-app" ]
        [ header, pageView model ]


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
