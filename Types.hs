--Types for export, avoiding mutual importing
{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Types (Temperatures(..), Temperature(..)) where

import GHC.Generics
import Data.Aeson

data Temperatures = Temperatures  {temperatures :: [Temperature]}
	deriving (Show, Generic)

data Temperature = Temperature { date :: String, temperature :: Integer } 
	deriving (Show, Generic)

instance ToJSON Temperature 
instance FromJSON Temperature

instance ToJSON Temperatures 
instance FromJSON Temperatures 