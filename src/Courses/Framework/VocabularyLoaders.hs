{-# LANGUAGE OverloadedStrings #-}

-- | This module provides utilities for loading translations from files.
module Courses.Framework.VocabularyLoaders
( loadVocabularyFromYamlCode
) where

import Core
import qualified Data.Map as M
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Yaml as Y

-- | Loads translations from yaml code.
loadVocabularyFromYamlCode :: T.Text -> Vocabulary
loadVocabularyFromYamlCode yamlCode = loadVocabularyFromYamlData yamlData where
    yamlData :: M.Map T.Text [T.Text]
    Right yamlData = Y.decodeEither $ TE.encodeUtf8 yamlCode

-- | Loads translations from yaml data.
loadVocabularyFromYamlData :: M.Map T.Text [T.Text] -> Vocabulary
loadVocabularyFromYamlData yamlData = Vocabulary brivlaList cmavoList cmevlaList where
    brivlaList = M.findWithDefault [] "brivla" yamlData
    cmavoList = M.findWithDefault [] "cmavo" yamlData
    cmevlaList = M.findWithDefault [] "cmevla" yamlData
