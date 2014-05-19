{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

import System.Environment(getArgs)
import System.IO(hSetBuffering)
import Network.Wai.Handler.Warp(defaultSettings, settingsPort, settingsHost)
import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World! :)|]

main :: IO ()
main = myWarp HelloWorld where
  myWarp app = do
    [host,port] <- getArgs
    hSetBuffering stdout LineBuffering
    putStrLn $ "Listening on host " ++ host ++ " port " ++ port

-- Use next line instead for warp 2.1.0+
--    let settings = setPort (read port) $ setHost host defaultSettings
    let settings = defaultSettings { settingsPort = (read port),
                                     settingsHost = Host host }
    appx <- toWaiApp app
    runSettings settings appx
