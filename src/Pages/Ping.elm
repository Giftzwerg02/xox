module Pages.Ping exposing (Model, Msg, page)

import Colours exposing (color)
import Element exposing (..)
import Element.Font as Font
import Gen.Params.Ping exposing (Params)
import Http
import Json.Decode exposing (field, string)
import Layout
import Page
import Request
import Shared
import Task
import Time
import View exposing (View)


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
    { pingStart : Maybe Time.Posix
    , pingEnd : Maybe Time.Posix
    , requestStatus : RequestStatus
    , pingResult : Maybe PingResult
    }


type RequestStatus
    = Loading
    | Success
    | Failure Http.Error


init : ( Model, Cmd Msg )
init =
    ( { pingStart = Nothing, pingEnd = Nothing, requestStatus = Loading, pingResult = Nothing }
    , Task.perform PingStartMsg Time.now
    )


ping_req =
    Http.get
        { url = "http://localhost:8080/ping"
        , expect = Http.expectJson GotPing pingDecoder
        }


type alias PingResult =
    { status : String }


pingDecoder : Json.Decode.Decoder PingResult
pingDecoder =
    Json.Decode.map PingResult (field "status" string)



-- UPDATE


type Msg
    = GotPing (Result Http.Error PingResult)
    | PingStartMsg Time.Posix
    | PingEndMsg Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PingStartMsg time ->
            ( { model | pingStart = Just time }
            , ping_req
            )

        GotPing result ->
            case result of
                Ok pingResult ->
                    ( { model | requestStatus = Success, pingResult = Just pingResult }
                    , Task.perform PingEndMsg Time.now
                    )

                Err error ->
                    ( { model | requestStatus = Failure error }
                    , Cmd.none
                    )

        PingEndMsg time ->
            ( { model | pingEnd = Just time }
            , Cmd.none
            )



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


content : Model -> Element msg
content model =
    row [ Font.color color.white ]
        [ case model.requestStatus of
            Loading ->
                text "Loading..."

            Failure error ->
                showError error

            Success ->
                let
                    start =
                        model.pingStart |> Maybe.map Time.posixToMillis |> Maybe.withDefault 0

                    end =
                        model.pingEnd |> Maybe.map Time.posixToMillis |> Maybe.withDefault 0

                    time =
                        end - start
                in
                column []
                    [ row [] [ text <| "Millis: " ++ String.fromInt time ]
                    , row [] [ text <| "Message: " ++ (model.pingResult |> Maybe.map (\pr -> pr.status) |> Maybe.withDefault "no msg") ]
                    ]
        ]


showError : Http.Error -> Element msg
showError error =
    text <| Debug.toString error
