module Handler.ConfigTarball where

import Import
import System.Cmd
import qualified Data.Text as T

archiveDirectory :: String
archiveDirectory = "/home/akru/easy-rsa/archive/"

buildArchive :: String
buildArchive = "/home/akru/easy-rsa/build-config"

getConfigTarballR :: RobotId -> Handler Html
getConfigTarballR robotId = do
    userId <- requireAuthId
    robot <- runDB $ get404 robotId
    let anchor = T.unpack $ robotAnchor robot
        tarball = archiveDirectory ++ anchor ++ ".tgz"

    if robotOwner robot /= userId
        then
            permissionDenied "Access denied"
        else do
            _ <- liftIO $ system $ buildArchive ++ " " ++ anchor
            sendFile "appclication/x-tar" $ tarball
