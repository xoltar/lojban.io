{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

-- | This module defines documents pertaining to the course, such as lesson materials and lesson plans.
module Study.Courses.English.Grammar.Crash.Documents where

import Study.Framework.DocumentBuilders (buildDocumentFromMarkdownCode)
import Data.FileEmbed (embedStringFile)
import qualified Text.Pandoc as P

-- * Lesson contents
-- | Lecture for the corresponding lesson.
lecture01 :: P.Pandoc
Right lecture01 = buildDocumentFromMarkdownCode $(embedStringFile "resources/courses/english/grammar/crash/lectures/01.md")

-- * Lesson contents
-- | Lecture for the corresponding lesson.
lecture02 :: P.Pandoc
Right lecture02 = buildDocumentFromMarkdownCode $(embedStringFile "resources/courses/english/grammar/crash/lectures/02.md")

-- * Lesson contents
-- | Lecture for the corresponding lesson.
lecture03 :: P.Pandoc
Right lecture03 = buildDocumentFromMarkdownCode $(embedStringFile "resources/courses/english/grammar/crash/lectures/03.md")
