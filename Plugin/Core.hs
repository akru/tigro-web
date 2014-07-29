module Plugin.Core(InterfacePlugin, render, getForm) where

import Import(Widget, Form)

class InterfacePlugin a where
    render :: a -> Widget
    getForm :: a -> Form a

