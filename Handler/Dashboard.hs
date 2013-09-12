module Handler.Dashboard where

import Import

-- Robot name
data Name = Name Text

-- Add robot monadic form
addRobotForm :: Html -> MForm Handler (FormResult Name, Widget)
addRobotForm = renderDivs $ Name
    <$> areq textField (fieldSettingsLabel MsgRobotName) Nothing

-- Main Dashboard handler
getDashboardR :: Handler Html
getDashboardR = do 
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robots <- runDB $ selectList [RobotOwner ==. userId] []
    (addRobotWidget, enctype) <- generateFormPost addRobotForm
    defaultLayout $ do
        setTitle "Dashboard"
        $(widgetFile "dashboard")

