module Handler.Settings where

import Import
import Handler.AddPlugin

getSettingsR :: RobotId -> Handler Html
getSettingsR robotId = do 
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robot <- runDB $ get404 robotId
    plugins <- runDB $ selectList [PluginRobot ==. robotId] [Asc PluginType]
    (addPluginWidget, enctype) <- generateFormPost addPluginForm

    if robotOwner robot /= userId
        then
            permissionDenied "Access denied"
        else do
            defaultLayout $ do
                addStylesheet $ StaticR css_button_css
                addStylesheetRemote "//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"
                addScriptRemote "//code.jquery.com/jquery-1.9.1.js"
                addScriptRemote "//code.jquery.com/ui/1.10.3/jquery-ui.js"
                setTitle "Settings"
                $(widgetFile "settings")
