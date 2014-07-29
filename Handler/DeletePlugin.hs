module Handler.DeletePlugin where

import Import

getDeletePluginR :: PluginId -> Handler ()
getDeletePluginR pluginId = do
    userId <- requireAuthId
    plugin <- runDB $ get404 pluginId
    robot <- runDB $ get404 $ pluginRobot plugin

    when (robotOwner robot /= userId)
        $ permissionDenied "Access denied"
    
    runDB $ delete pluginId
    redirect $ SettingsR $ pluginRobot plugin
