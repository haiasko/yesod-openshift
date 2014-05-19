{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

import System.Environment(getArgs)
import System.IO(hSetBuffering, stdout, BufferMode(..))
import System.Process(readProcess)
import Network.Wai.Handler.Warp(
   defaultSettings,
   settingsPort,  settingsHost,
   HostPreference(..),
   runSettings
   )
import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = do
-- NOTE: exception handling missing here 
    packages <- readProcess "ghc-pkg" ["list", "--simple-output"] []
    defaultLayout [whamlet|
Welcome to Haskell Cloud! The following packages are pre-installed:
<br> 
<ul>
  $forall pkg <- words packages
    <li>#{pkg}
|]

main :: IO ()
main = myWarp HelloWorld where
  myWarp app = do
    [host,port] <- getArgs
    hSetBuffering stdout LineBuffering
    putStrLn $ "Listening on host " ++ host ++ " port " ++ port

-- Use next line instead for warp 2.1.0+ (must fix the import too)
--  let settings = setPort (read port) $ setHost host defaultSettings
    let settings = defaultSettings { settingsPort = (read port),
                                     settingsHost = Host host }
    appx <- toWaiApp app
    runSettings settings appx
