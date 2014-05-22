{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

import System.Environment(getArgs)
import System.IO(hSetBuffering, stdout, BufferMode(..))
import System.Process(readProcess)
import Data.List(sort)
import Data.String(fromString)
import Network.Wai.Handler.Warp
import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = do
-- NOTE: exception handling missing here 
    packages <- liftIO $ readProcess "ghc-pkg" ["list", "--simple-output"] []
    defaultLayout [whamlet|
Welcome to <a href=https://github.com/accursoft/Haskell-Cloud">Haskell Cloud</a>! The following packages are pre-installed:
<ul>
  $forall pkg <- sort $ words packages
    <li>#{pkg}
|]

main :: IO ()
main = myWarp HelloWorld where
  myWarp app = do
    [host,port] <- getArgs
    hSetBuffering stdout LineBuffering
    putStrLn $ "Listening on host " ++ host ++ " port " ++ port

    let settings = setPort (read port) $ setHost (fromString host) defaultSettings
-- for versions of warp before 2.1.0 (which export the Host constructor)
--    let settings = defaultSettings { settingsPort = (read port),
--                                     settingsHost = Host host }
    appx <- toWaiApp app
    runSettings settings appx

