module Handler.Settings where

import Import

getSettingsR :: RobotId -> Handler Html
getSettingsR robotId = do 
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robot <- runDB $ get404 robotId

    if robotOwner robot /= userId
        then
            permissionDenied "Access denied"
        else do
            defaultLayout $ do
                setTitle "Settings"
                $(widgetFile "settings")
