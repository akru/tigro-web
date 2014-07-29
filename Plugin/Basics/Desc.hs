{-# LANGUAGE OverloadedStrings #-}
module Plugin.Basics.Desc where

-- Custom imports
import Import
import Data.Aeson(encode, decode)
import Data.String.Conversions

-- Plugins
import Plugin.Basics.ImageView
import Plugin.Basics.KeyboardTeleop
import Plugin.Basics.Navigation

-- Plugin list
getBasicsPluginList :: [(Text, Text)]
getBasicsPluginList = [ descImageView, descKeyboardTeleop, descNavigation ]

-- Plugin default params in JSON
getDefaultParams :: Text -> Text
getDefaultParams name
    | name == "ImageView" = convertString $ encode defaultImageView
    | name == "KeyboardTeleop" = convertString $ encode defaultKeyboardTeleop
    | name == "Navigation" = convertString $ encode defaultNavigation
    | otherwise = ""

-- Plugin form by name
getBasicsForm :: Text -> Text -> Handler (Widget, Enctype)
getBasicsForm name params
    | name == "ImageView" =
        case decode json :: Maybe ImageView of
            Just plug -> generateFormPost $ getForm plug
            Nothing -> generateFormPost $ getForm defaultImageView
    | name == "KeyboardTeleop" =
        case decode json :: Maybe KeyboardTeleop of
            Just plug -> generateFormPost $ getForm plug
            Nothing -> generateFormPost $ getForm defaultKeyboardTeleop
    | name == "Navigation" =
        case decode json :: Maybe Navigation of
            Just plug -> generateFormPost $ getForm plug
            Nothing -> generateFormPost $ getForm defaultNavigation
    | otherwise = notFound
        where 
            json = convertString params

-- Plugin form handler by name
runBasicsForm :: Text -> Handler Text
runBasicsForm name
    | name == "ImageView" = do
        ((result, _), _) <- runFormPost $ getForm defaultImageView
        case result of
            FormSuccess params -> 
                return $ convertString $ encode params
            _ -> notFound
    | name == "KeyboardTeleop" = do
        ((result, _), _) <- runFormPost $ getForm defaultKeyboardTeleop
        case result of
            FormSuccess params -> 
                return $ convertString $ encode params
            _ -> notFound
    | name == "Navigation" = do
        ((result, _), _) <- runFormPost $ getForm defaultNavigation
        case result of
            FormSuccess params -> 
                return $ convertString $ encode params
            _ -> notFound
    | otherwise = notFound

-- Render plugin by name with params
renderBasics :: Text -> Text -> Widget
renderBasics name params
    | name == "ImageView" = do
        case decode json :: Maybe ImageView of
            Just plugin -> render plugin
            Nothing -> [whamlet||]
    | name == "KeyboardTeleop" = do
        case decode json :: Maybe KeyboardTeleop of
            Just plugin -> render plugin
            Nothing -> [whamlet||]
    | name == "Navigation" = do
        case decode json :: Maybe Navigation of
            Just plugin -> render plugin
            Nothing -> [whamlet||]
    | otherwise = [whamlet||]
        where 
            json = convertString params

