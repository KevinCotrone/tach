{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE UndecidableInstances #-}
module Tach.Class.Bounds where

import           Control.Applicative
import           Data.Either         ()
import           Data.Function
import           Data.List
import qualified Data.Sequence       as S
import qualified Data.Foldable as F
import Data.Monoid
import Data.Bifunctor
import Data.Bifoldable

class Bound a where
  bounds :: a -> (Int, Int)

instance Bound () where
    bounds _ = (0,0)

instance (Bound a) => Bound [a] where
  bounds xs =  F.foldl (\old x -> (updateBounds old) $ (bounds x)) (-1,-1) xs
    where updateBounds :: (Int,Int) -> (Int, Int) -> (Int, Int)
          updateBounds bs = (updateOlder bs) . (updateYounger bs)
          updateOlder :: (Int,Int) -> (Int,Int) -> (Int, Int)
          updateOlder a@(_,b) c@(_,d) = if b > d then a else c
          updateYounger :: (Int, Int) -> (Int, Int) -> (Int, Int)
          updateYounger a@(b,_) c@(d,_) = if b < d then a else c