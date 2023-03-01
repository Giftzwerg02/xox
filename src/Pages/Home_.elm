module Pages.Home_ exposing (Model, Msg, page)

import Colours exposing (..)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Gen.Params.Home_ exposing (Params)
import Html exposing (Html)
import Images exposing (..)
import Layout exposing (layout)
import Page
import Request
import Shared
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
    { counter : Int
    }


init : ( Model, Effect Msg )
init =
    ( { counter = 0 }, Effect.none )



-- UPDATE


type Msg
    = Add
    | Sub


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Add ->
            ( { model | counter = model.counter + 1 }, Effect.none )

        Sub ->
            ( { model | counter = model.counter - 1 }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Dashboard"
    , body =
        [ Layout.layout content
        ]
    }


content : Element msg
content =
    let
        title_text =
            [ "⛩️🌸🍥☯🍜"
            , "Welcome to the"
            , " OXO Dashboard!"
            , "⛩️🌸🍥☯🍜"
            ]

        title_el =
            title_text
                |> List.map (\txt -> el [ Font.center, width fill ] <| text txt)
    in
    row [ width fill, height fill, paddingXY 40 0, Font.size 48, Font.color color.white ] <|
        {- this is fucking fancy css shit -}
        [ column [ width (fill |> minimum 200 |> maximum 400), height shrink, alignLeft ]
            [ image [ width fill, height fill ] { src = oxo_pfp_src, description = "OXO Profilepicture" } ]
        , column [ width fill, alignRight ] title_el
        ]
