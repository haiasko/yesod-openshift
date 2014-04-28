import Control.Monad
import Control.Exception
import Data.Char
import System.IO
import System.IO.Error
import Network
import Network.BSD
import Network.Socket
import System.Environment
import System.Process

main = do sock <- bracketOnError
                     (getProtocolNumber "tcp" >>= socket AF_INET Stream)
                     close
                     (\sock -> do setSocketOption sock ReuseAddr 1
                                  [host,port] <- getArgs
                                  inet <- inet_addr host
                                  bindSocket sock $ SockAddrInet (fromIntegral $ read port) inet
                                  listen sock maxListenQueue
                                  return sock
                     )
          packages <- readProcess "ghc-pkg" ["list", "--simple-output"] []
          let response = "HTTP/1.1 200 OK\r\n\r\nWelcome to Haskell Cloud! The following packages are pre-installed:\n\n" ++ unlines (words packages)
          forever $ do (handle,_,_) <- Network.accept sock
                       read <- liftM (any (null . dropWhile isSpace) . lines) $ hGetContents handle
                       when read $ void $ tryIOError $ hPutStr handle response
                       hClose handle
