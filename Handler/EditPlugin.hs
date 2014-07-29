module Handler.EditPlugin(getEditPluginR, postEditPluginR) where

import Import
import Plugin.Basics.Desc

getEditPluginR :: PluginId -> Handler Html
getEditPluginR pluginId = do
    userId <- requireAuthId
    plugin <- runDB $ get404 pluginId
    robot <- runDB $ get404 $ pluginRobot plugin

    when (robotOwner robot /= userId)
        $ permissionDenied "Acces denied"

    (pluginForm, enctype) <- 
        getBasicsForm (pluginType plugin) (pluginParams plugin)
    
    defaultLayout $ 
        [whamlet|
<form action=@{EditPluginR pluginId} enctype=#{enctype} method="POST">
    ^{pluginForm}
    <input type="submit" value="Ok">
|]
    

postEditPluginR :: PluginId -> Handler ()
postEditPluginR pluginId = do
    userId <- requireAuthId
    plugin <- runDB $ get404 pluginId
    robot <- runDB $ get404 $ pluginRobot plugin

    when (robotOwner robot /= userId)
        $ permissionDenied "Acces denied"

    params <- runBasicsForm $ pluginType plugin
    _ <- runDB $ update pluginId [PluginParams =. params]
    redirect $ SettingsR $ pluginRobot plugin

