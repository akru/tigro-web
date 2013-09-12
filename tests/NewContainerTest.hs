module NewContainerTest (newContainerSpecs) where

import TestImport
import System.Random
import System.IO.Unsafe
import qualified Data.Text as T
import Control.Applicative(pure, (<$>), (<*>))

anchorLen = 8

genAnchor :: IO String
genAnchor = take anchorLen <$> randomRs ('a', 'z') <$> newStdGen

newContainerSpecs :: Spec 
newContainerSpecs = 
    ydescribe "These are user, robot and container creation tests." $ do
        yit "Try to create in database" $ do 
            runDB $ do
                userId <- insert $ 
                    let name = T.pack $ unsafePerformIO genAnchor in
                        User name Nothing
                robotId <- insert $ 
                    let anchor = T.pack "testclt" in -- $ unsafePerformIO genAnchor in --
                        Robot (T.pack "myRobot") anchor userId Nothing Nothing Nothing 
                contId <- insert $ Container robotId Nothing Nothing
                insert $ NewContainer contId
            get HomeR
            statusIs 200
