module Pages.Home_ exposing (view)

import Html exposing (div, h1, img, main_, text)
import Html.Attributes exposing (class, src, style, width)
import View exposing (View)
import Html.Attributes exposing (align)
import Html.Attributes exposing (height)
import Html exposing (span)


view : View msg
view =
    { title = "test"
    , body =
        [ main_ [ class "container", style "margin" "auto" ]
            [ div
                [ ]
                [
                    h1 [  ] [ oxo_pfp, span [ style "margin-left" "30vw", style "text-align" "right"] [ text "OxO Homepage"] ]
                ]
            ]
        ]
    }


oxo_pfp : Html.Html msg
oxo_pfp =
    img
        [ src "assets/oxo_pfp.png"
        , style "vertical-align" "middle"
        , width 200
        , height 100
        ]
        []
