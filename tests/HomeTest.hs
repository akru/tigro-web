{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport
import qualified Data.List as L

homeSpecs :: Spec
homeSpecs =
    ydescribe "These are some example tests" $ do

        yit "loads the index and checks it looks right" $ do
            get HomeR
            statusIs 200

        -- This is a simple example of using a database access in a test.  The
        -- test will succeed for a fresh scaffolded site with an empty database,
        -- but will fail on an existing database with a non-empty user table.
        yit "leaves the user table empty" $ do
            get HomeR
            statusIs 200
            users <- runDB $ selectList ([] :: [Filter User]) []
            assertEqual "user table empty" 0 $ L.length users
