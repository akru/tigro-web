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

    if robotOwner robot == userId 
        then do
            _ <- liftIO $ system $ buildArchive ++ " " ++ anchor
            sendFile typeOctet $ tarball
        else permissionDenied "Access denied"
