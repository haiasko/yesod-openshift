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
    let settings = setPort (read port) $ setHost host defaultSettings
    runSettings settings $ toWaiApp app
