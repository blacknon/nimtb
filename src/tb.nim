# Copyright(c) 2023 Blacknon. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

import argparse
import hashes
import nre
import os
import sequtils
import sets
import strformat
import terminal

import std/parseopt

# local package
import ./common
import ./config
import ./tabulate
import ./myshlex

# command line parse
var p = newParser:
    # help text
    help("{prog}: columnate list transforme to human readble table format.")

    # flags
    flag("-v", "--version" , help="display version.", shortcircuit=true)
    flag("-t", "--table" , help="display markdown table mode.")
    flag("-l", "--header" , help="set header at 1st line.")
    flag("-n", "--number", help = "show row number.")
    flag("-q", "--quote", help = "treat elements enclosed in double quotation marks as one column.")

    # options
    # option("-T", "--table-format", choices=[], help="Define the table output format")
    option("-s", "--separator", default=some(" "),  help="Specify a set of characters to be used to delimited columns.")
    option("-L", "--left-align", help="Aligns the specified column to the left. ex) -L 1-3,7,10")
    option("-R", "--right-align", help="Aligns the specified column to the right. ex) -R 2-4,8,11")
    option("-C", "--center-align", help="Aligns the specified column to the center. ex) -C 3-5,9,12")
    # option("-o", "--output", help = "Output to this file")

    # args
    arg("file", nargs = -1, help = "Read from this files...")

    # run
    run:
        # text
        var text:string

        # get text.
        if isatty(stdin):
            # if file is not set pattern...
            if len(opts.file) == 0:
                # error: specify files.
                stderr.writeLine "Error: specify files."
                quit(1)

            for file in opts.file:
                if fileExists(file):
                    let fileData = readFile(file)

                    if len(text) == 0:
                        text = fileData
                    else:
                        let texts = [text, fileData]
                        text = texts.join("\n")

                else:
                    # error: File not exists
                    stderr.writeLine fmt"Error: File not exists at {file}."
                    quit(1)

        else:
            text = stdin.readAll()

        # split text, to lines
        var lines = text.splitLines()

        # strip last line.
        let maxIndex = lines.len() - 1
        if len(lines[maxIndex]) == 0:
            lines = lines[0..maxIndex-1]

        # check table output mode.
        var tableType = "plain"
        if opts.table:
            tableType = "markdown"

        # create table
        var table: seq[seq[string]] = @[]

        var columnCount: int
        var lineCount = 1
        var i = 0
        for line in lines:
            var row: seq[string]

            # add number column
            if opts.number:
                if opts.header and i == 0:
                    row.add("No.")
                else:
                    row.add(fmt("{lineCount}"))
                    lineCount += 1

            # split data
            # TODO: ダブルクォーテーションを考慮した処理を行うフラグを追加(コマンドラインのオプションとして)
            # TODO: ダブルクォーテーションを考慮した処理を行うフラグに応じてshelx_splitを使わせる(分岐追加)
            var line_seq: seq[string] = @[]
            if opts.quote:
                var dlm_chars = cast[seq[char]](opts.separator)
                line_seq = shlex_split(line, dlm_chars).words

            elif opts.separator == " " and not opts.quote:
                line_seq = line.splitWhitespace(-1)

            else:
                line_seq = line.split(opts.separator)
            row.add(line_seq)

            # add row
            table.add(row)

            if len(row) > columnCount:
                columnCount = len(row)

            # add count
            i += 1

        # check align options
        # left
        let leftAlignCheckData = getNumberFromRange(opts.left_align, columnCount, opts.number)
        if not leftAlignCheckData.status:
            stderr.writeLine "left-align error."
            stderr.writeLine leftAlignCheckData.message
            quit(1)

        # right
        var rightAlignCheckData = getNumberFromRange(opts.right_align, columnCount, opts.number)
        if not rightAlignCheckData.status:
            stderr.writeLine "right-align error."
            stderr.writeLine rightAlignCheckData.message
            quit(1)

        # center
        let centerAlignCheckData = getNumberFromRange(opts.center_align, columnCount, opts.number)
        if not centerAlignCheckData.status:
            stderr.writeLine "center-align error."
            stderr.writeLine centerAlignCheckData.message
            quit(1)

        # if print number, set this column right align.
        if opts.number:
            rightAlignCheckData.data.add(1)

        # print markdown table.
        echo outputTable(
            table,
            tableType=tableType,
            isHeader=opts.header,
            leftAlign=leftAlignCheckData.data,
            rightAlign=rightAlignCheckData.data,
            centerAlign=centerAlignCheckData.data
        )

# main
proc main() =
  # parse commandline
  var op = initOptParser()

  var cmdline: OrderedSet[string] = initOrderedSet[string]()
  while true:
    op.next()
    case op.kind
    of cmdEnd: break
    of cmdShortOption:
      if op.val == "":
        cmdline.incl("-" & op.key)
      else:
        cmdline.incl("-" & op.key)
        cmdline.incl(op.val)
    of cmdLongOption:
      if op.val == "":
        cmdline.incl("--" & op.key)
      else:
        cmdline.incl("--" & op.key)
        cmdline.incl(op.val)
    of cmdArgument:
      cmdline.incl(op.key)

  # echo toSeq(cmdline)

  try:
    # run program
    p.run(toSeq(cmdline))

  except ShortCircuit as e:
    if e.flag == "argparse_help":
        echo p.help
        quit(0)

    if e.flag == "version":
        echo pkgVersion
        quit(0)
  except UsageError:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)

# main
when isMainModule:
    main()
