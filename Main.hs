{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad 							(msum,)
import Happstack.Server			
import System.IO.Unsafe	
import Db
import Types
import Responses
import Manipulation
						  
--Start + handlers
main :: IO ()
main = simpleHTTP nullConf $ handlers

thePolicy :: BodyPolicy
thePolicy = (defaultBodyPolicy "/pol/" 0 10000 1000)

handlers :: ServerPart Response
handlers =
    do decodeBody thePolicy
       msum [ dir "get"  $ resultPageGet 
           	, dir "post" $ resultPagePost
			, dir "url"  $ resultPageURL
			, dir "max"  $ resultPageMax
			, dir "min"  $ resultPageMin
			, dir "abo"  $ resultPageAbo
			, dir "del" $ resultPageDel
			, dir "all" $ resultPageAll
			, dir "dall" $ resultPageDall
			, defaultHtml
         	   ]

