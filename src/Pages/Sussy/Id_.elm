module Pages.Sussy.Id_ exposing (page)

import Gen.Params.Sussy.Id_ exposing (Params)
import Html exposing (article, button, form, h1, input, main_, text)
import Html.Attributes exposing (class, placeholder)
import Page exposing (Page)
import Request
import Shared
import View exposing (View)
import Html.Attributes exposing (style)


type alias ParsedParams =
    { id : Int
    }


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = view { id = String.toInt req.params.id |> Maybe.withDefault 69 }
        }


view : ParsedParams -> View msg
view params =
    { title = "Lol: " ++ (params.id |> String.fromInt)
    , body = body
    }


body : List (Html.Html msg)
body =
    [ main_ [ class "container" ]
        [ article
            []
            [ h1 [ style "color" "red" ] [ text "my form" ]
            , my_form
            ]
        ]
    ]


my_form : Html.Html msg
my_form =
    form []
        [ input [ placeholder "one" ] []
        , input [ placeholder "two" ] []
        , button [] [ text "Click Me!" ]
        ]
