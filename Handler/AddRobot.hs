module Handler.AddRobot where

import Import
import System.Random
import System.IO.Unsafe
import Handler.Dashboard
import qualified Data.Text as T

-- Robot anchor len
anchorLen :: Int
anchorLen = 8

-- Anchor generator
genAnchor :: IO String
genAnchor = take anchorLen <$> randomRs ('a', 'z') <$> newStdGen

-- Add new robot 
addRobot :: UserId -> Name -> Handler RobotId 
addRobot userId (Name name) = runDB $ do
    robotId <- insert $ 
        let anchor = T.pack (unsafePerformIO genAnchor)
            in Robot name anchor userId Nothing Nothing Nothing 
    contId <- insert $ Container robotId Nothing Nothing
    _ <- insert $ NewContainer contId
    return robotId

-- Add robot form handler
postAddRobotR :: Handler Html
postAddRobotR = do
    userId <- requireAuthId
    ((result, _), _) <- runFormPost addRobotForm
    case result of
        FormSuccess name -> do
            robotId <- addRobot userId name
            redirect $ SettingsR robotId
        _ -> defaultLayout [whamlet|<p>Invalid input, let's try again.|]
