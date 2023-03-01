module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Html)
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
    { title = ""
    , body =
        [ layout [ width fill, height fill ] <|
            column [ width fill, height fill ]
                [ header
                , content
                ]
        ]
    }


header : Element msg
header =
    row [ width fill, padding 20, spacing 20, Font.color color.blue ]
        [ logo
        , link [ alignRight ] { url = Route.toHref Route.Ping, label = text "Ping" }
        , link [ alignRight ] { url = Route.toHref Route.Ping, label = text "Songs" }
        , link [ alignRight ] { url = Route.toHref Route.Ping, label = text "Settings" }
        ]


content : Element msg
content =
    row [ centerX, centerY, paddingXY 40 0 ] <|
        {- this is fucking fancy css shit -}
        [ image [ width <| maximum 600 fill, height shrink] { src = "./assets/oxo_pfp.png", description = "OXO Profilepicture" }
        , paragraph
            [ Font.size 48, Font.center, Font.color color.white ]
            [ text "Sussy" ]
        ]


footer : Element msg
footer =
    row
        [ width fill
        , padding 10
        , Background.color color.lightBlue
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color color.blue
        ]
        [ logo
        , column [ alignRight, spacing 10 ]
            [ el [ alignRight ] <| text "Services"
            , el [ alignRight ] <| text "About"
            , el [ alignRight ] <| text "Contact"
            ]
        ]


logo : Element msg
logo =
    el
        [ width <| px 40
        , height <| px 40
        ]
    <|
        image [] { src = "./assets/oxo_pfp.png", description = "OXO Profilepicture" }


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    }
