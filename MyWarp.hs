{-# LANGUAGE OverloadedStrings #-}

module MyWarp (
  myWarp
) where

import System.Environment

import Network.Wai.Handler.Warp

import Yesod

myWarp app = do
    [host,port] <- getArgs
    putStrLn $ "Listening on host " ++ host ++ " port " ++ show port

-- This requires warp 2.1.0 and we have 2.0.4
--    let settings = setPort (read port) $ setHost host defaultSettings
    let settings = defaultSettings { settingsPort = (read port),
                                     settingsHost = Host host }
    runSettings settings $ toWaiApp app
