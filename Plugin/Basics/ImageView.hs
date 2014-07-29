{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Plugin.Basics.ImageView(
    ImageView, 
    defaultImageView,
    descImageView,
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
data ImageView = ImageView {
    getTopic       :: Text
  , getWidth       :: Int
  , getHeight      :: Int
  , getTop         :: Text
  , getLeft        :: Text
  , getFullscreen  :: Bool
}
    deriving Generic

-- Default plugin settings
defaultImageView :: ImageView
defaultImageView = ImageView "/image_raw/compressed" 320 240 "auto" "auto" False

-- Plugin description
descImageView :: (Text, Text)
descImageView = ("ImageView", "Simple image viewer")

-- Plugin JSON decoder/encoder
instance FromJSON   ImageView
instance ToJSON     ImageView

-- Plugin interface
instance InterfacePlugin ImageView where
    -- Return HTML widget from input image
    render params = do 
        camera <- newIdent
        toWidget $(hamletFile   "Plugin/Basics/templates/image_view.hamlet")
        toWidget $(juliusFile   "Plugin/Basics/templates/image_view.julius")
        toWidget $(cassiusFile  "Plugin/Basics/templates/image_view.cassius")

    -- Retun HTML form for settings
    getForm params = renderBootstrap $ ImageView
        <$> areq textField      "topic"      (Just (getTopic params))
        <*> areq intField       "width"      (Just (getWidth params))
        <*> areq intField       "height"     (Just (getHeight params))
        <*> areq textField      "top"        (Just (getTop params))
        <*> areq textField      "left"       (Just (getLeft params))
        <*> areq checkBoxField  "fullscreen" (Just (getFullscreen params))

