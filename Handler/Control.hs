module Handler.Control where

import Import
import Plugin.Basics.Desc

-- TODO: Read this settings from config file
connectProtocol :: String
connectProtocol = "ws"

rosConnect :: Robot -> Node -> Widget
rosConnect robot node =
    toWidget [julius|
        var ros = new ROSLIB.Ros();
        var host = #{toJSON $ nodeAddress node};
        var port = #{toJSON $ robotWsport robot};
        var proto = #{toJSON $ connectProtocol};
        ros.connect(proto + '://' + host + ':' + port);|]

-- Control page handler
getControlR :: RobotId -> Handler Html
getControlR robotId = do
    userId <- requireAuthId
    user <- runDB $ get404 userId
    robot <- runDB $ get404 robotId
    (Entity contId cont) <- runDB $ getBy404 $ UniqueContainerRobot robotId
    node <- case containerNode cont of
        Nothing -> notFound
        Just nodeId -> runDB $ get404 $ nodeId
    
    plugList <- runDB $ selectList [PluginRobot ==. robotId] []
    let p2widget = \(Entity _ plugin) -> renderBasics (pluginType plugin) (pluginParams plugin)
    pluginWidgets <- return $ map p2widget plugList

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
                addScript $ StaticR js_fullscreenify_js
                rosConnect robot node
                $(widgetFile "control")
