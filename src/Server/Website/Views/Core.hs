{-# LANGUAGE OverloadedStrings #-}

module Server.Website.Views.Core
( includeUniversalStylesheets
, includeInternalStylesheet
, includeExternalStylesheet
, includeCourseStylesheet
, includeUniversalScripts
, includeInternalScript
, includeExternalScript
, includeDictionaryScript
, TopbarCategory (..)
, displayTopbar
, displayFooter
) where

import Core
import Server.Core
import Language.Lojban.Core
import qualified Data.Text as T
import qualified Text.Blaze as B
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

-- * Stylesheets
includeUniversalStylesheets :: H.Html
includeUniversalStylesheets = do
    -- TODO: consider removing
    includeInternalStylesheet "bootstrap.min.css"
    includeExternalStylesheet "https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"
    includeExternalStylesheet "https://fonts.googleapis.com/icon?family=Material+Icons"

includeInternalStylesheet :: String -> H.Html
includeInternalStylesheet = includeExternalStylesheet . ("/static/style/"++)

includeExternalStylesheet :: String -> H.Html
includeExternalStylesheet src =
    H.link
      B.! A.href (H.stringValue src)
      B.! A.rel "stylesheet"

includeInlineStylesheet :: String -> H.Html
includeInlineStylesheet code =
    H.style B.! A.type_ (H.stringValue "text/css") $
        H.toHtml code

includeCourseStylesheet :: Course -> H.Html
includeCourseStylesheet course = includeInlineStylesheet code where
    style = courseStyle course
    courseColor1 = case (courseStyleColor1 style) of
        Just color ->"--course-color1: " ++ color ++ ";"
        Nothing -> ""
    courseIcon = case (courseStyleIconUrl style) of
        Just url -> "--course-icon: url(" ++ url ++ ");"
        Nothing -> ""
    code = concat
        [ ":root {"
        , courseColor1
        , courseIcon
        , "}"
        ]

-- * Scripts
includeUniversalScripts :: H.Html
includeUniversalScripts = do
    includeInternalScript "vendors.js"

includeInternalScript :: String -> H.Html
includeInternalScript = includeExternalScript . ("/static/scripts/"++)

includeExternalScript :: String -> H.Html
includeExternalScript src =
    H.script ""
      B.! A.type_ "text/javascript"
      B.! A.src (H.stringValue src)

includeDictionaryScript :: Dictionary -> H.Html
includeDictionaryScript dictionary = includeInternalScript $ T.unpack $ "dictionaries/" `T.append` (dictIdentifier dictionary) `T.append` ".js"

-- * Topbar
data TopbarCategory = TopbarHome | TopbarCourses | TopbarDecks | TopbarResources deriving (Enum, Eq)

displayTopbar :: Maybe UserIdentity -> TopbarCategory -> H.Html
displayTopbar userIdentityMaybe topbarCategory = do
    H.div B.! A.class_ (H.stringValue "topbar") $ do
        H.div B.! A.class_ "logo" $ do
            H.a (H.toHtml ("lojban" :: String))
                B.! A.href (H.stringValue "/")
        displayTopbarMenu topbarCategory
        displayUserProfile userIdentityMaybe

displayUserProfile :: Maybe UserIdentity -> H.Html
displayUserProfile userIdentityMaybe =
    case userIdentityMaybe of
        Nothing -> do
            H.div B.! A.class_ "user-signin" $ do
                H.a (H.toHtml ("sign in" :: String))
                    B.! A.href (H.stringValue "/oauth2/google/login")
        Just userIdentity -> do
            let pictureUrl = userPictureUrl userIdentity
            H.div B.! A.class_ "user-profile" $ do
                H.a B.! A.href (H.stringValue "/oauth2/google/logout") $ do
                    H.img B.! A.class_ "picture" B.! A.src (H.textValue pictureUrl)

displayTopbarMenu :: TopbarCategory -> H.Html
displayTopbarMenu topbarCategory = do
    H.ul $ do
        displayTopbarMenuItem (topbarCategory == TopbarCourses) "Courses" "/courses/"
        displayTopbarMenuItem (topbarCategory == TopbarDecks) "Decks" "/decks/"
        displayTopbarMenuItem (topbarCategory == TopbarResources) "Resources" "/resources/"

displayTopbarMenuItem :: Bool -> String -> String -> H.Html
displayTopbarMenuItem selected text url = do
    let selectedClass = if selected then "selected" else ""
    H.li $ do
        H.a (H.toHtml text)
            B.! A.href (H.stringValue url)
            B.! A.class_ selectedClass

displayFooter :: H.Html
displayFooter = do
    H.div B.! A.class_ (H.textValue "footer") $ do
        H.div B.! A.class_ (H.textValue "links") $ do
            H.a B.! A.href (H.textValue "/about") $ H.toHtml ("About" :: T.Text)
            H.a B.! A.href (H.textValue "https://github.com/jqueiroz/lojban-tool") $ H.toHtml ("Contribute" :: T.Text)
