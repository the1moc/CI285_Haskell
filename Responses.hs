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
				b $ h3 "Query the Database (Format: DD-MM-YYYY)"							
				form ! H.enctype "multipart/form-data"
					! H.method "GET"
					! H.action "/get" $ do
					H.label "Date: " >> input ! H.type_ "text"
											 ! H.name "date"
											 ! H.size "10"
					input ! H.type_ "submit"
							! H.name "upload"
				
				b $ h3 "Please use the form below to submit data to the database (Format: DD-MM-YYYY | 7)"
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/post" $ do
					H.label "Date: " >> input ! H.type_ "text"
											 ! H.name "date"
											 ! H.size "10"
					H.label "  Temp: " >> input ! H.type_ "text"
											 ! H.name "temp"
											 ! H.size "10"
					input ! H.type_ "submit"
							! H.name "upload"
							
				b $ h3 "Use the form below to get JSON Data and insert into the DB"
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/url" $ do
					H.label "URL: " >> input ! H.type_ "text"
											 ! H.name "url"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"
						  
				b $ h3 "Use the button below to list temperatures above x"
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/abo" $ do
					H.label " Get temperatures above: "
					H.label "x : " >> input ! H.type_ "text"
											 ! H.name "x"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"

					p $ br
						
				b $ h3 "Use the button below to list all the dates in the data"
				form ! H.enctype "multipart/form-data"
					! H.method "GET"
					! H.action "/all" $ do
					H.label " Get all Temperatures: "
					input ! H.type_ "Submit"
						  ! H.name "upload"

				b $ h3 "Use the button below to list the max temperature and date"
				form ! H.enctype "multipart/form-data"
					! H.method "GET"
					! H.action "/max" $ do
					H.label " Get max Temperature "
					input ! H.type_ "Submit"
						  ! H.name "upload"

				b $ h3 "Use the button below to list the min temperature and date"
				form ! H.enctype "multipart/form-data"
					! H.method "GET"
					! H.action "/min" $ do
					H.label " Get min Temperature "
					input ! H.type_ "Submit"
						  ! H.name "upload"

					p $ br
					
				b $ i $ h3 "Use this to remove a date row from the database *DELETES DATE*"
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/del" $ do
					H.label "Delete : " >> input ! H.type_ "text"
											 ! H.name "del"
											 ! H.size "10"
					input ! H.type_ "Submit"
						  ! H.name "upload"
						  
				b $ i $ h3 "Use this to remove *ALL* data from the database *DELETES DATE*"
				form ! H.enctype "multipart/form-data"
					! H.method "POST"
					! H.action "/delall" $ do
					H.label "DELETE ALL DATA : " 
					input ! H.type_ "Submit"
						  ! H.name "upload"
						  
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

				
--Simple requests result page
resultPageSingle :: String -> ServerPart Response
resultPageSingle x = 
	do method GET
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ x
				
--List input result page
resultPageList :: [String]-> ServerPart Response
resultPageList xs = 
	do method GET
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				ul $ forM_ xs (li . toHtml)
				
--Delete ALL data
resultPageDelAll :: ServerPart Response
resultPageDelAll = 
	do method POST
	   ok $ toResponse $
		 html $ do
			H.head $ do
				title "Happstack Server"
				h1 "Temperatures Information"
			H.body $ do
				p $ toHtml $ unsafePerformIO $ delAllDb

