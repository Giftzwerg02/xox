module Layout exposing (..)

import Colours exposing (..)
import Element
import Element.Font
import Gen.Route as Route exposing (Route)
import Images exposing (..)


layout content =
    Element.layout [ Element.width Element.fill, Element.height Element.fill ] <|
        Element.column [ Element.width Element.fill, Element.height Element.fill ]
            [ header
            , content
            ]


header : Element.Element msg
header =
    Element.row [ Element.width Element.fill, Element.padding 20, Element.spacing 20, Element.Font.color color.blue ]
        [ logo
        , Element.link [ Element.alignRight ] { url = Route.toHref Route.Ping, label = Element.text "Ping" }
        , Element.link [ Element.alignRight ] { url = Route.toHref Route.Songs, label = Element.text "Songs" }
        , Element.link [ Element.alignRight ] { url = Route.toHref Route.Home_, label = Element.text "Home" }
        ]


logo : Element.Element msg
logo =
    Element.el
        [ Element.width <| Element.px 40
        , Element.height <| Element.px 40
        ]
    <|
        Element.image [] { src = oxo_pfp_src, description = "OXO Profilepicture" }
