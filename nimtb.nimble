import
  os

template thisModuleFile: string = instantiationInfo(fullPaths = true).filename

import src/config

# Package

version       = pkgVersion
author        = "blacknon"
description   = "columnate list transforme to human readble table format."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["tb"]


# Dependencies

requires "nim >= 1.6.4"
requires "argparse == 4.0.1"
requires "eastasianwidth >= 1.1.0"
