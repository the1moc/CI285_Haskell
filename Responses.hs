{-# LANGUAGE OverloadedStrings #-}

module Responses where

import Control.Monad 								(msum, forM_)
import Happstack.Server
import Text.Blaze.Html5       			 			as H hiding (map, object)
import qualified Text.Blaze.Html5.Attributes 		as H hiding (dir, label, title, form, object)						
import System.IO.Unsafe	
import Data.Aeson
import Data.ByteString.Lazy.Char8					(pack, unpack)
import Db
import Types
import Manipulation

defaultHtml :: ServerPart Response
defaultHtml =
	ok $ toResponse $
		html $ do 
			H.head $ do
				title "Happstack Server"
				h1  "Temperatures Information"
			H.body $ do
				b $ h2 "Querying the database"							
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/all" $ do
					H.label " List all Temperatures: " >> input ! H.type_ "submit"
											 ! H.name "x"
											 ! H.size "10"
			
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/max" $ do
					H.label " Get Max Temperature: "  >> input ! H.type_ "submit"
											 ! H.name "x"
											 ! H.size "10"
				
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/min" $ do
					H.label " Get Min Temperature: "  >> input ! H.type_ "submit"
											 ! H.name "x"
											 ! H.size "10"
		
				form ! H.enctype "multipart/form-data"
					! H.method "GET"
					! H.action "/get" $ do
					H.label "Query database by date: " >> input ! H.type_ "text"
											 ! H.name "date"
											 ! H.size "10"
					input ! H.type_ "submit"
							! H.name "upload"
				
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/abo" $ do
					H.label " Get temperatures above x: " >> input ! H.type_ "text"
											 ! H.name "x"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"
							
				b $ h2 "Inserting into Database"	
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/post" $ do
					H.label "Insert into database - Date: " >> input ! H.type_ "text"
											 ! H.name "date"
											 ! H.size "10"
					H.label "  Temp: " >> input ! H.type_ "text"
											 ! H.name "temp"
											 ! H.size "10"
					input ! H.type_ "submit"
							! H.name "upload"
							
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/url" $ do
					H.label "Insert JSON Data from URL: " >> input ! H.type_ "text"
											 ! H.name "url"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"
						  
				b $ h2 "Deleting from Database"	
		
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/del" $ do
					H.label "Delete entry - Date: " >> input ! H.type_ "text"
											 ! H.name "del"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"

				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/dall" $ do
					b $ H.label "Delete ALL Data: " >> input ! H.type_ "submit"
													! H.name "x"
													! H.size "10"
					

						  
--------------------------------------------------------------------------------------------------------------------------------
--Result pages
--Date temprature request as HTML
resultPageGet :: ServerPart Response
resultPageGet = 
	do method GET
	   date <- look "date"
	   ok $ toResponse $ 
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $  convert $ unsafePerformIO $ queryDb date

--Inserting information as HTML				
resultPagePost :: ServerPart Response
resultPagePost = 
	do method POST
	   date <- look "date"
	   temp <- look "temp"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ unsafePerformIO $ insertDb date (read temp)
				
				
--Result Page Delete				
resultPageDel :: ServerPart Response
resultPageDel = 
	do method POST
	   date <- look "del"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ unsafePerformIO $ delDb date

--URL input result page			
resultPageURL :: ServerPart Response
resultPageURL = 
	do method POST
	   url <- look "url"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ convertJSON url
				p "done"

				
--Max request result page
resultPageMax :: ServerPart Response
resultPageMax = 
	do method POST
	   x <- look "x"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ convert $ unsafePerformIO $ maxDb
				
--Min request result page
resultPageMin :: ServerPart Response
resultPageMin = 
	do method POST
	   x <- look "x"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ convert $ unsafePerformIO $ minDb
				
--Inserting information as HTML				
resultPageAbo :: ServerPart Response
resultPageAbo = 
	do method POST
	   x <- look "x"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				ul $ forM_  (convertList $ unsafePerformIO $ aboDb (read x)) (li . toHtml)
				
resultPageAll :: ServerPart Response
resultPageAll = 
	do method POST
	   x <- look "x"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				ul $ forM_  (convertList $ unsafePerformIO $ allDb (read x)) (li . toHtml)
				
resultPageDall :: ServerPart Response
resultPageDall = 
	do method POST
	   x <- look "x"
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ unsafePerformIO $ delAllDb (read x)