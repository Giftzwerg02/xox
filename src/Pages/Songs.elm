module Pages.Songs exposing (Model, Msg, page)

import Browser
import Colours exposing (color)
import DnDList
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Gen.Params.Songs exposing (Params)
import Html exposing (article)
import Html.Attributes exposing (id)
import Layout
import Page
import Request
import Shared
import Url exposing (Protocol(..), Url)
import View exposing (View)
import Animation
import Ease


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { songs : List Song
    , songsDnd : DnDList.Model
    }


type alias Song =
    { id : Int
    , name : String
    , author : Author
    , duration : Int
    , link : Url
    }


type alias Author =
    { name : String
    , profile : Url
    }



-- SYSTEM


songDndListConfig : DnDList.Config Song
songDndListConfig =
    { beforeUpdate = \_ _ list -> list
    , movement = DnDList.Free
    , listen = DnDList.OnDrag
    , operation = DnDList.Rotate
    }


songDndListSystem : DnDList.System Song Msg
songDndListSystem =
    DnDList.create songDndListConfig SongListDnD


init : ( Model, Effect Msg )
init =
    ( { songs = [], songsDnd = songDndListSystem.model }, Effect.none )



-- UPDATE


type Msg
    = SongsUpdate
    | AddSong
    | SongListDnD DnDList.Msg


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SongsUpdate ->
            ( model, Effect.none )

        AddSong ->
            ( { model | songs = List.append model.songs [ newSong (List.length model.songs) ] }, Effect.none )

        SongListDnD dndMsg ->
            let
                ( dnd, songs ) =
                    songDndListSystem.update dndMsg model.songsDnd model.songs
            in
            ( { model | songsDnd = dnd, songs = songs }
            , songDndListSystem.commands dnd |> Effect.fromCmd
            )


newSong : Int -> Song
newSong id =
    { id = id
    , name = "Never Gonna Give You Up"
    , duration = 69
    , link =
        Url.fromString "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
            |> Maybe.withDefault
                { protocol = Https
                , host = "www.youtube.com"
                , port_ = Just 443
                , path = "watch"
                , query = Just "v=dQw4w9WgXcQ"
                , fragment = Nothing
                }
    , author = newAuthor
    }


newAuthor : Author
newAuthor =
    { name = "Rick Astley"
    , profile =
        Url.fromString "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
            |> Maybe.withDefault
                { protocol = Https
                , host = "www.youtube.com"
                , port_ = Just 443
                , path = "watch"
                , query = Just "v=dQw4w9WgXcQ"
                , fragment = Nothing
                }
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    songDndListSystem.subscriptions model.songsDnd



-- VIEW


view : Model -> View Msg
view model =
    { title = "Songs"
    , body =
        [ Layout.layout (content model)
        ]
    }


content : Model -> Element Msg
content model =
    column [ width fill, height fill, Font.color color.white, padding 40 ]
        (model.songs
            |> List.indexedMap (songcardView model.songsDnd)
            |> List.map
                (\s ->
                    row
                        [ padding 5
                        , width fill
                        , inFront
                            (songcardGhostView model.songsDnd model.songs)
                        ]
                        [ s ]
                )
            |> List.append [ row [ paddingXY 0 10 ] [ addSongButton ] ]
        )


songCard : Song -> Element Msg
songCard song =
    row
        [ Background.color color.darkCharcoal
        , padding 20
        , width fill
        ]
        [ text <| "(" ++ String.fromInt song.id ++ ") "
        , link
            [ Font.color color.link, alignLeft ]
            { url = Url.toString song.link
            , label = text song.name
            }
        , link
            [ Font.color color.link, alignRight ]
            { url = Url.toString song.author.profile
            , label = text <| "By: " ++ song.author.name
            }
        ]


emptySongCard : Element Msg
emptySongCard =
    row
        [ Background.color color.darkCharcoal
        , padding 20
        , width fill
        ]
        []


songDndId : Song -> Attribute Msg
songDndId song =
    id (String.fromInt song.id) |> Element.htmlAttribute


type alias DnDEvent msg =
    Int -> String -> List (Html.Attribute msg)


songDndEvent : DnDEvent msg -> Song -> Int -> List (Attribute msg)
songDndEvent event song idx =
    event idx (String.fromInt song.id) |> List.map Element.htmlAttribute


songDndAttributes : DnDEvent msg -> Song -> Int -> List (Attribute Msg)
songDndAttributes event song idx =
    songDndId song :: songDndEvent songDndListSystem.dropEvents song idx


songcardView : DnDList.Model -> Int -> Song -> Element Msg
songcardView dnd idx song =
    case songDndListSystem.info dnd of
        Just { dragIndex } ->
            if dragIndex /= idx then
                el
                    ( width fill ::
                         songDndAttributes songDndListSystem.dropEvents song idx
                    )
                    (songCard song)

            else
                el
                    [ songDndId song, width fill ]
                    emptySongCard

        Nothing ->
            row
                ([ Background.color color.darkCharcoal
                 , padding 20
                 , width fill
                 , id (String.fromInt song.id) |> Element.htmlAttribute
                 ]
                    ++ (songDndListSystem.dragEvents idx (String.fromInt song.id) |> List.map Element.htmlAttribute)
                )
                [ text <| "(" ++ String.fromInt song.id ++ ") "
                , link
                    [ Font.color color.link, alignLeft ]
                    { url = Url.toString song.link
                    , label = text song.name
                    }
                , link
                    [ Font.color color.link, alignRight ]
                    { url = Url.toString song.author.profile
                    , label = text <| "By: " ++ song.author.name
                    }
                ]


songcardGhostView : DnDList.Model -> List Song -> Element Msg
songcardGhostView dnd songs =
    let
        maybeSong : Maybe Song
        maybeSong =
            songDndListSystem.info dnd
                |> Maybe.andThen (\{ dragIndex } -> songs |> List.drop dragIndex |> List.head)
    in
    case maybeSong of
        Just song ->
            el
                (songDndListSystem.ghostStyles dnd |> List.map Element.htmlAttribute)
                (songCard song)

        Nothing ->
            none


addSongButton : Element Msg
addSongButton =
    button
        [ width <| px 100
        , height <| px 50
        ]
        { onPress = Just AddSong
        , label = el [ centerX, centerY ] (text "Add Song")
        }
