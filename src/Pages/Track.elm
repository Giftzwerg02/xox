module Pages.Track exposing (Model, Msg, page)

import Colours exposing (color)
import Gen.Params.Track exposing (Params)
import Http
import Layout
import Page
import Request
import Shared
import Json.Decode exposing (field, string)
import View exposing (View)
import Element exposing (..)
import Element.Font as Font


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { track : Maybe Track }


type alias Track =
    { title : String }


trackDecoder : Json.Decode.Decoder Track
trackDecoder =
    Json.Decode.map Track (field "title" string)


init : ( Model, Cmd Msg )
init =
    ( { track = Nothing }
    , Http.get
        { url = "http://localhost:8080/queue"
        , expect = Http.expectJson GotTrack trackDecoder
        }
    )



-- UPDATE


type Msg
    = GotTrack (Result Http.Error Track)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTrack result ->
            case result of
                Ok track ->
                    ( { model | track = Just track }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Track"
    , body =
        [ Layout.layout (content model)
        ]
    }


content : Model -> Element msg
content model =
    let
        t =
            model.track
                |> Maybe.map (\t_ -> t_.title)
                |> Maybe.withDefault "no track found :("
    in
    row [ Font.color color.white ]
        [ text t ]
