{-# LANGUAGE OverloadedStrings #-}

module Db  where

import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Types	

-------------------------------------------------------------------------------------------
instance FromRow Temperature where
	fromRow = Temperature <$> field <*> field
-------------------------------------------------------------------------------------------
queryDb :: String -> IO [Temperature]
queryDb dte = do
	conn <- open "finaldatabase.db"
	r <- query conn "SELECT * from Tempdata where date = ?"(Only (dte :: String)) :: IO [Temperature]
	close conn
	return r
	
insertDb :: String -> Integer -> IO (String)
insertDb dte tmp = do
	conn <- open "finaldatabase.db"
	execute conn "INSERT INTO Tempdata (date, temp) VALUES (?,?)" (dte :: String, tmp :: Integer)
	close conn
	return "Info has been inserted"

maxDb :: IO [Temperature]
maxDb = do
	conn <- open "finaldatabase.db"
	r <- query_ conn "SELECT date,MAX(Temp) FROM Tempdata" :: IO [Temperature]
	close conn
	return r

minDb :: IO [Temperature]
minDb = do
	conn <- open "finaldatabase.db"
	r <- query_ conn "SELECT date,MIN(Temp) FROM Tempdata" :: IO [Temperature]
	close conn
	return r

aboDb :: Integer -> IO [Temperature]
aboDb x = do
	conn <- open "finaldatabase.db"
	r <- query conn "SELECT date, temp FROM Tempdata WHERE temp > ?" (Only(x)) :: IO [Temperature]
	close conn
	return r
	
allDb :: IO [Temperature]
allDb = do
	conn <- open "finaldatabase.db"
	r <- query_ conn "SELECT * FROM Tempdata" :: IO [Temperature]
	close conn
	return r
	
jsonDb :: (String, Integer) -> IO String
jsonDb xs = do
	conn <- open "finaldatabase.db"
	execute conn "INSERT INTO Tempdata (date, temp) VALUES (?,?)" (fst xs, snd xs)
	close conn
	return "Done"
	
delDb :: String -> IO String
delDb dte = do
	conn <- open "finaldatabase.db"
	execute conn "DELETE FROM Tempdata where date = ?" (Only (dte))
	close conn
	return "If that data was in the database, it has been removed"
	
delAllDb :: IO String
delAllDb = do
	conn <- open "finaldatabase.db"
	execute_ conn "DELETE FROM Tempdata"
	close conn
	return "ALL DATA has been deleted"