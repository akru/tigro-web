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
                addStylesheet $ StaticR css_button_css
                setTitle "Settings"
                $(widgetFile "settings")
