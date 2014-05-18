{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

import System.Environment
import Network.Wai.Handler.Warp
import           Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World! :)|]

main :: IO ()
main = do 
{-

    [host,port] <- getArgs
    putStrLn $ "Listening on host " ++ host ++ " port " ++ show port

    let settings = defaultSettings { settingsPort = port,
                                     settingsHost = host }
    runSettings settings HelloWorld

-}

    defaultMain (fromArgs parseExtra) makeApplication