module Manipulation where
	
import qualified Network.HTTP					as NW (simpleHTTP, getResponseBody, getRequest) 
import Types
import Db
import Data.Aeson
import Data.ByteString.Lazy.Char8					(pack, unpack)
import System.IO.Unsafe	

convertList :: [Temperature] -> [String]
convertList (x:xs) = (getDate x ++ " -- " ++ (show $ getTemp x) ++ "°C") : convertList xs
convertList [] = []

convert :: [Temperature] -> String
convert (x:xs) = getDate x ++ "  -- " ++ (show $ getTemp x) ++ "°C"
convert [] = ""
-----------------------------------------------------------------------------------------------
getJson :: String -> IO String
getJson x = NW.simpleHTTP (NW.getRequest x) >>= fmap (take 1000) . NW.getResponseBody

getDate :: Temperature -> String
getDate (Temperature d _) = d

getTemp :: Temperature -> Integer
getTemp (Temperature _ t) = t 

getList :: Temperatures -> [Temperature]
getList (Temperatures (x:xs)) = (x:xs)
getList (Temperatures []) = []
-----------------------------------------------------------------------------------------------
takeValues :: [Temperature] -> [(String, Integer)]
takeValues (x:xs) = (getDate x, getTemp x)  : takeValues xs	
takeValues [] = []			
				
processorExtract :: Maybe Temperatures -> [Temperature]
processorExtract json =
	case json of
		Just (Temperatures (x:xs))		-> (x:xs)
		Nothing 						-> []
		
convertJSON :: String -> String
convertJSON url = unlines $ map unsafePerformIO $ map jsonDb $
					takeValues $ processorExtract $ decode $ pack $ 
					unsafePerformIO $ getJson url
