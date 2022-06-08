# Package

version       = "0.2.0"
author        = "blacknon"
description   = "columnate list transforme to human readble table format."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["tb"]


# Dependencies

requires "nim >= 1.6.4"
requires "argparse == 3.0.0"
requires "eastasianwidth >= 1.1.0"
