module Handler.Dashboard where

import Import
import Handler.AddRobot

-- Main Dashboard handler
getDashboardR :: Handler Html
getDashboardR = do 
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robots <- runDB $ selectList [RobotOwner ==. userId] [Asc RobotName]
    (addRobotWidget, enctype) <- generateFormPost addRobotForm
    defaultLayout $ do
        setTitle "Dashboard"
        addStylesheet $ StaticR css_button_css
        $(widgetFile "dashboard")

