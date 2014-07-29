{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Plugin.Basics.KeyboardTeleop(
    KeyboardTeleop, 
    defaultKeyboardTeleop,
    descKeyboardTeleop,
    parseJSON, 
    toJSON, 
    render, 
    getForm
) where

import Import
import Plugin.Core
import GHC.Generics

-- Plugin data definition
data KeyboardTeleop = KeyboardTeleop {
    getTopic       :: Text
  , getScale       :: Double
}
    deriving Generic

-- Default plugin settings
defaultKeyboardTeleop :: KeyboardTeleop
defaultKeyboardTeleop = KeyboardTeleop "/cmd_vel" 0.1

-- Plugin description
descKeyboardTeleop :: (Text, Text)
descKeyboardTeleop = ("KeyboardTeleop", "WSAD keyboard teleop")

-- Plugin JSON decoder/encoder
instance FromJSON   KeyboardTeleop
instance ToJSON     KeyboardTeleop

-- Plugin interface
instance InterfacePlugin KeyboardTeleop where
    -- Return HTML widget from input image
    render params = toWidget [julius|
        ros.on('connection', function() {
            var teleop = new KEYBOARDTELEOP.Teleop({
                ros : ros,
                topic : #{toJSON $ getTopic params}
            });
            teleop.scale = (#{toJSON $ getScale params});
            console.log("KeyboardTeleop initialized");
        });|]

    -- Retun HTML form for settings
    getForm params = renderBootstrap $ KeyboardTeleop
        <$> areq textField      "topic"      (Just (getTopic params))
        <*> areq doubleField    "scale"      (Just (getScale params))

