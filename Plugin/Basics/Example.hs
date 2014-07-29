{-# LANGUAGE OverloadedStrings #-}
module Plugin.Basics.ExamplePlugin(ExamplePlugin, parseJSON, render) where

-- Imports
import Import(Widget, whamlet)
import Control.Applicative ((<$>), (<*>))
import Data.Aeson ((.:), (.:?), decode, FromJSON(..), Value(..))
import Plugin.Core(InterfacePlugin, render)

-- Plugin data definition
data ExamplePlugin = ExamplePlugin {
    getTopic       :: String
}

-- Plugin JSON-params parser
instance FromJSON ExamplePlugin where
    parseJSON (Object v) = 
        ExamplePlugin               <$>
        (v .: "topic")

-- Plugin widget render
instance InterfacePlugin ExamplePlugin where
    render param = [whamlet|#{getTopic param}|]

