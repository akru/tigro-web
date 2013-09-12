module Handler.Settings where

import Import

getSettingsR :: RobotId -> Handler Html
getSettingsR robotId = do 
    userId <- requireAuthId
    user <- runDB $ get404 userId
    defaultLayout $ do
        setTitle "Settings"
        $(widgetFile "settings")
