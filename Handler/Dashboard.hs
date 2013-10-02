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
        addStylesheet $ StaticR css_button_css
        addStylesheetRemote "//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"
        addScriptRemote "//code.jquery.com/jquery-1.9.1.js"
        addScriptRemote "//code.jquery.com/ui/1.10.3/jquery-ui.js"
        $(widgetFile "dashboard")

