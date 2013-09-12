module Handler.DeleteRobot where

import Import

getDeleteRobotR :: RobotId -> Handler ()
getDeleteRobotR robotId = do
    userId <- requireAuthId
    robot <- runDB $ get404 robotId

    if robotOwner robot /= userId
        then
            permissionDenied "Access denied"
        else
            runDB $ do
                deleteWhere [ContainerRobot ==. robotId]
                delete robotId
    redirect DashboardR
