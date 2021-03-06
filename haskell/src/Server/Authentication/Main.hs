{-# LANGUAGE OverloadedStrings #-}

module Server.Authentication.Main
( handleRoot
, readUserIdentityFromCookies
) where

import Control.Monad (msum)
import Happstack.Server
import Server.Core
import qualified Server.Authentication.Google as Google
import qualified Server.Authentication.OpenID as OpenID
import qualified Server.Authentication.Mock as Mock
import Server.Authentication.Utils (redirectToCurrentRefererIfAllowed)

handleRoot :: ServerConfiguration -> ServerResources -> ServerPart Response
handleRoot serverConfiguration serverResources = msum
    [ dir "google" $ Google.handleRoot serverConfiguration serverResources
    , dir "openid" $ OpenID.handleRoot serverConfiguration serverResources
    , dir "mock" $ Mock.handleRoot serverConfiguration serverResources
    , dir "logout" $ do
        Google.handleLogout serverConfiguration serverResources
        OpenID.handleLogout serverConfiguration serverResources
        Mock.handleLogout serverConfiguration serverResources
        redirectToCurrentRefererIfAllowed
    ]

readUserIdentityFromCookies :: ServerConfiguration -> ServerResources -> ServerPart (Maybe UserIdentity)
readUserIdentityFromCookies serverConfiguration serverResources = msum
    [ Google.readUserIdentityFromCookies serverConfiguration serverResources
    , OpenID.readUserIdentityFromCookies serverConfiguration serverResources
    , Mock.readUserIdentityFromCookies serverConfiguration serverResources
    , return Nothing ]
