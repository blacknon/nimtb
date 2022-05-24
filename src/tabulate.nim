# Copyright(c) 2022 Blacknon. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

import strutils
import strformat
import sequtils
from eastasianwidth import stringWidth

type TableType = object
    # ヘッダーの1行目のバーを表示するかどうか
    isOutputFisrtHeaderBar: bool

    # ヘッダーと内容を区切るバーを表示するかどうか
    isOutputSecondHeaderBar: bool

    # 表の最後にバーを表示するかどうか
    isOutputBottomBar: bool

    # 表の両サイドに表示する縦棒を表示するかどうか
    isOutputBothSideVerticalBar: bool

    # 縦枠の文字(`|`とか)
    verticalBarChar: string

    # 横枠の文字(`-`とか)
    horizontalBarChar: string

    # 横枠でAlignを表現する文字(`:`とか)
    horizontalBarAlignChar: string

    # 縦横の結合ポイントに使用する文字
    pointChar: string

const
    PlainTable = TableType(
        isOutputFisrtHeaderBar: false,
        isOutputSecondHeaderBar: false,
        isOutputBottomBar: false,
        isOutputBothSideVerticalBar: false,
        verticalBarChar: "",
        horizontalBarChar: "",
        horizontalBarAlignChar: "",
        pointChar: ""
    )

    MarkdownTable = TableType(
        isOutputFisrtHeaderBar: false,
        isOutputSecondHeaderBar: true,
        isOutputBottomBar: false,
        isOutputBothSideVerticalBar: true,
        verticalBarChar: "|",
        horizontalBarChar: "-",
        horizontalBarAlignChar: ":",
        pointChar: "|"
    )

proc calcColumnWidth(rows: openArray[seq[string]], verticalBarChar: string, padding: int = 1): seq[int] =
    # Calculation the size of each column from cell width.
    result = repeat(0, rows[0].len)
    for cols in rows:
        for i in 0..<cols.len:
            # get cell width
            var cellWidth = cols[i].stringWidth

            # add verticalBar size
            cellWidth = cellWidth + len(verticalBarChar)

            # add padding size
            cellWidth = cellWidth + (padding * 2)

            if i > result.len - 1:
                result.add(0)

            # check and update column width
            if cellWidth > result[i]:
                result[i] = cellWidth

proc setTableType(tableType: string): TableType =
    case tableType
    of "markdown":
        return MarkdownTable
    of "plain":
        return PlainTable

proc outputTable*(
        rows: openArray[seq[string]],
        tableType: string = "markdown",
        isHeader: bool = false,
        leftAlign: seq[int] = @[],
        rightAlign: seq[int] = @[],
        centerAlign: seq[int] = @[],
        padding: int = 1
        ) : string =
    # set table type.
    let tableTypeInfo = setTableType(tableType)

    # TODO: tableのフォーマット方式いかんで縦棒の有効・向こうを指定する
    let columnWidth: seq[int] = calcColumnWidth(rows, verticalBarChar=tableTypeInfo.verticalBarChar, padding=padding)

    var horizontalBar: seq[string] = @[tableTypeInfo.pointChar]
    for i in 0..<columnWidth.len:
        # Get column number for use with align.
        let columnNum = i + 1

        var columnBar: string
        if columnNum in leftAlign:
            columnBar = tableTypeInfo.horizontalBarAlignChar
            columnBar = columnBar & repeat(tableTypeInfo.horizontalBarChar, columnWidth[i] - 1).join("")
        elif columnNum in rightAlign:
            columnBar = repeat(tableTypeInfo.horizontalBarChar, columnWidth[i] - 1).join("")
            columnBar = columnBar & tableTypeInfo.horizontalBarAlignChar
        elif columnNum in centerAlign:
            columnBar = tableTypeInfo.horizontalBarAlignChar
            columnBar = columnBar & repeat(tableTypeInfo.horizontalBarChar, columnWidth[i] - 2).join("")
            columnBar = columnBar & tableTypeInfo.horizontalBarAlignChar
        else:
            columnBar = tableTypeInfo.horizontalBarAlignChar
            columnBar = columnBar & repeat(tableTypeInfo.horizontalBarChar, columnWidth[i] - 1).join("")

        # add columnBar to horizontalBar
        horizontalBar.add(columnBar)

        # add pointChar
        horizontalBar.add(tableTypeInfo.pointChar)

    let horizontalBarText = horizontalBar.join("")

    # create template table
    var tmpTable: seq[string]

    # print FisrtHeaderBar
    if isHeader and tableTypeInfo.isOutputFisrtHeaderBar:
        tmpTable.add( horizontalBarText )

    # １行ずつ出力する
    var rowNum = 0
    for cols in rows:
        var newCols: seq[string] = @[""]
        for i in 0..<columnWidth.len:
            # Get column number for use with align.
            let columnNum = i + 1

            # padding text.
            let paddingText = repeat(" ", padding)
            let cellWidth = columnWidth[i]

            var cellTextData: string
            if cols.len > i:
                cellTextData = cols[i]
            else:
                cellTextData = ""

            # set cellText
            var cellText: string
            if columnNum in leftAlign:
                cellText = alignLeft(cellTextData, cellWidth - (padding * 2))
            elif columnNum in rightAlign:
                cellText = align(cellTextData, cellWidth - (padding * 2))
            elif columnNum in centerAlign:
                cellText = center(cellTextData, cellWidth - (padding * 2))
            else:
                cellText = alignLeft(cellTextData, cellWidth - (padding * 2))

            # write cell
            newCols.add (fmt"{paddingText}{cellText}{paddingText}")

        newCols.add("")
        tmpTable.add(newCols.join(tableTypeInfo.verticalBarChar))

        # if SecondHeaderBar
        if rowNum == 0 and isHeader and tableTypeInfo.isOutputSecondHeaderBar:
            tmpTable.add( horizontalBarText )

        rowNum += 1

    # print BottomBar
    if tableTypeInfo.isOutputBottomBar:
        tmpTable.add( horizontalBarText )

    # create result
    result = tmpTable.join("\n")
