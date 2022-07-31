module Purescriptify.Capability.Routing where

import Prelude
import Purescriptify.Data.Route (Route)
import Control.Monad.Trans.Class (lift)
import Halogen.Subscription as HS
import React.Halo (HaloM)
import React.Halo as Halo

class
  Monad m <=
  MonadRouting m where
  read :: m Route
  getEmitter :: m (HS.Emitter Route)
  navigate :: Route -> m Unit
  redirect :: Route -> m Unit
  reload :: m Unit

instance MonadRouting m => MonadRouting (HaloM props ctx state action m) where
  read = lift read
  reload = lift reload
  getEmitter = lift getEmitter
  navigate = lift <<< navigate
  redirect = lift <<< redirect

subscribe :: forall m props ctx state action. MonadRouting m => (Route -> action) -> HaloM props ctx state action m Unit
subscribe f = do
  emitter <- lift getEmitter
  void $ Halo.subscribe $ f <$> emitter