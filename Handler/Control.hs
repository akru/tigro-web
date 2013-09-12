module Handler.Control where

import Import

getControlR :: RobotId -> Handler Html
getControlR r = do 
    defaultLayout $ do
        setTitle "Welcome to TIGRO!"
        $(widgetFile "homepage")
