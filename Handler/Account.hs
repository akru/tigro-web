module Handler.Account where

import Import

getAccountR :: Handler Html
getAccountR = do 
    defaultLayout $ do
        setTitle "Welcome to TIGRO!"
        $(widgetFile "homepage")
