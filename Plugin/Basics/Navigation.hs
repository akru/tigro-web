{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Plugin.Basics.Navigation(
    Navigation, 
    defaultNavigation,
    descNavigation,
    parseJSON, 
    toJSON, 
    render, 
    getForm
) where

import Import
import Plugin.Core
import GHC.Generics
-- Templates imports
import Text.Julius
import Text.Hamlet
import Text.Cassius

-- Plugin data definition
data Navigation = Navigation {
    getTopic       :: Text
}
    deriving Generic

-- Default plugin settings
defaultNavigation :: Navigation
defaultNavigation = Navigation "/move_base"

-- Plugin description
descNavigation :: (Text, Text)
descNavigation = ("Navigation", "Simple navigation")

-- Plugin JSON decoder
instance FromJSON Navigation
instance ToJSON Navigation

-- Plugin interface
instance InterfacePlugin Navigation where
    -- Return HTML widget from input image
    render params = do
        map_view <- newIdent
        toWidget $(hamletFile   "Plugin/Basics/templates/navigation.hamlet")
        toWidget $(juliusFile   "Plugin/Basics/templates/navigation.julius")
        toWidget $(cassiusFile  "Plugin/Basics/templates/navigation.cassius")

    -- Retun HTML form for settings
    getForm params = renderBootstrap $ Navigation
        <$> areq textField      "topic"      (Just (getTopic params))

