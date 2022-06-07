# Copyright(c) 2022 Blacknon. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

import re
import sequtils
import strutils
import strformat

# object numRange
type numRange* = object
    status*: bool
    message*: string
    data*: seq[int]

# Since only [0-9,-] is allowed, false is returned if any other characters are included.
proc isNumberRange(text: string): bool =
    result = text.match(re"^[0-9,-]+$")

#
proc getNumberFromRange*(text: string, maxNum: int, isViewNumber: bool = false): numRange =
    # if blank, return result.status is true
    if len(text) == 0:
        result.status = true
        return

    # check is number range's
    let isNum = isNumberRange(text)
    if not isNum:
        result.status = false
        result.message = fmt"It is an invalid format. {text}"
        return result

    # split range
    var numRange = strutils.split(text, ",")

    for numElement in numRange:
        if "-" in numElement:
            # Unify overlapping hyphens
            var numElementProcessed = re.replace(numElement, re"-+", "-")

            # split `-`
            let numElementProcessedArray = numElementProcessed.split("-")

            # count check.
            if len(numElementProcessedArray) > 2:
                result.status = false
                result.message = fmt"It is an invalid format. {numElement}"
                return result

            # string to int.
            var startNum: int
            if numElementProcessedArray[0] != "":
                startNum = parseInt(numElementProcessedArray[0])
            else:
                startNum = 0

            var endNum: int
            if numElementProcessedArray[1] != "":
                endNum = parseInt(numElementProcessedArray[1])
            else:
                endNum = maxNum

            result.data.add(toSeq(startNum..endNum))
        else:
            if numElement == "":
                continue

            let numnumElementNum = parseInt(numElement)

            result.data.add(numnumElementNum)

    if isViewNumber and len(result.data) > 0:
        var tmpData: seq[int] = @[]
        for d in result.data:
            tmpData.add(d + 1)

        result.data = tmpData

    result.status = true
