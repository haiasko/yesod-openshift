{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

import System.Environment
import Network.Wai.Handler.Warp
import Yesod.Default.Config (fromArgs)
import Yesod.Default.Main   (defaultMainLog)
import Settings             (parseExtra)
import Application          (makeApplication)

import           Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World! :)|]

main :: IO ()
main = defaultMainLog (fromArgs parseExtra) makeApplication
