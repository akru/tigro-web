module Handler.Control where

import Import
import Control.Monad
import qualified Data.Text as T

rosConnect :: Robot -> Node -> Widget
rosConnect robot node =
    toWidget [julius|
        var host = #{toJSON $ nodeAddress node};
        var port = #{toJSON $ robotWsport robot};
        ros.connect('ws://' + host + ':' + port);|]

getControlR :: RobotId -> Handler Html
getControlR robotId = do
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robot <- runDB $ get404 robotId
    (Entity contId cont) <- runDB $ getBy404 $ UniqueContainerRobot robotId
    node <- case containerNode cont of
        Nothing -> notFound
        Just nodeId -> runDB $ get404 $ nodeId

    if robotOwner robot /= userId
        then
            permissionDenied "Access denied"
        else
            defaultLayout $ do
                setTitle "Control"
                addScriptRemote "//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"
                addScriptRemote "//cdn.robotwebtools.org/EaselJS/current/easeljs.min.js"
                addScriptRemote "//cdn.robotwebtools.org/EventEmitter2/current/eventemitter2.min.js"
                addScriptRemote "//cdn.robotwebtools.org/roslibjs/current/roslib.min.js"
                addScriptRemote "//cdn.robotwebtools.org/keyboardteleopjs/current/keyboardteleop.min.js"
                addScriptRemote "//cdn.robotwebtools.org/ros2djs/current/ros2d.min.js"
                addScript $ StaticR js_nav2d_js
                $(widgetFile "control")
                rosConnect robot node
