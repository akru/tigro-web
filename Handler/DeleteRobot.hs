module Handler.DeleteRobot where

import Import

getDeleteRobotR :: RobotId -> Handler ()
getDeleteRobotR robotId = do
    userId <- requireAuthId
    robot <- runDB $ get404 robotId

    when (robotOwner robot /= userId)
        $ permissionDenied "Access denied"
    
    runDB $ do
        deleteWhere [ContainerRobot ==. robotId]
        delete robotId
    redirect DashboardR
