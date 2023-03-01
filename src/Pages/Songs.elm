module Pages.Songs exposing (Model, Msg, page)

import Colours exposing (color)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Gen.Params.Songs exposing (Params)
import Html exposing (article)
import Layout
import Page
import Request
import Shared
import Url exposing (Protocol(..), Url)
import View exposing (View)


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
    }


type alias Song =
    { name : String
    , author : Author
    , duration : Int
    , link : Url
    }


type alias Author =
    { name : String
    , profile : Url
    }


init : ( Model, Effect Msg )
init =
    ( { songs = [] }, Effect.none )



-- UPDATE


type Msg
    = SongsUpdate
    | AddSong


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SongsUpdate ->
            ( model, Effect.none )

        AddSong ->
            ( { model | songs = List.append model.songs [ newSong ] }, Effect.none )


newSong : Song
newSong =
    { name = "Never Gonna Give You Up"
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
    Sub.none



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
            |> List.map songcard
            |> List.map (\s -> row [ padding 5, width fill ] [ s ])
            |> List.append [ row [ paddingXY 0 10 ] [ addSongButton ] ]
        )


songcard : Song -> Element Msg
songcard song =
    row
        [ Background.color color.darkCharcoal
        , padding 20
        , width fill
        ]
        [ link
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


addSongButton : Element Msg
addSongButton =
    button
        [ width <| px 100
        , height <| px 50
        ]
        { onPress = Just AddSong
        , label = el [ centerX, centerY ] (text "Add Song")
        }
