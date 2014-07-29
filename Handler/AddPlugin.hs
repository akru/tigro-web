module Handler.AddPlugin where

import Import
import Plugin.Basics.Desc

-- Plugin type according to name
data PluginName = PluginName Text

-- Add plugin monadic form
addPluginForm :: Form PluginName
addPluginForm = renderBootstrap $ PluginName
    <$> areq (selectField plugins) "" Nothing
        where plugins = optionsPairs $ revPairs getBasicsPluginList 
              revPairs = map (\(a, b) -> (b, a))

-- Add plugin form handler
postAddPluginR :: RobotId -> Handler ()
postAddPluginR robotId = do
    _ <- requireAuthId
    ((result, _), _) <- runFormPost addPluginForm
    _ <- case result of
        FormSuccess (PluginName name) ->
            runDB $ insert $ Plugin robotId name $ getDefaultParams name
        _ -> notFound 
    redirect $ SettingsR robotId
