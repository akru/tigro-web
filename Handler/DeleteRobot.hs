module Handler.DeleteRobot where

import Import

getDeleteRobotR :: RobotId -> Handler ()
getDeleteRobotR robotId = do
    userId <- requireAuthId
    robot <- runDB $ get404 robotId

    if robotOwner robot == userId
        then
            runDB $ do
                deleteWhere [ContainerRobot ==. robotId]
                delete robotId
        else
            permissionDenied "Access denied"
    redirect DashboardR
