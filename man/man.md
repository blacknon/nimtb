% tb(1) Version 0.1.0 |

NAME
====

**tb** - columnate list transforme to human readble table format.

SYNOPSIS
========

| **tb** \[*options*] \[*files*]

DESCRIPTION
===========

**tb** outputs the contents of a file or standard input to a table like the *column* command.
You can also output the result as a Markdown format table.

Flags
-----

-h, --help

:   Prints help information


-t, --table

:   display markdown table mode.


-l, --header

:   set header at 1st line.


Options
-------

-s, --separator=SEPARATOR

:   Specify a set of characters to be used to delimited columns. (default: ` ` ).

-L, --left-align=LEFT_ALIGN

:   Aligns the specified column to the left. ex) -L 1-3,7,10

-R, --right-align=RIGHT_ALIGN

:   Aligns the specified column to the right. ex) -R 2-4,8,11

-C, --center-align=CENTER_ALIGN

:   Aligns the specified column to the center. ex) -C 3-5,9,12

BUGS
====

See GitHub Issues: <https://github.com/blacknon/nimtb/issues>

AUTHOR
======

Blacknon <blacknon@orebibou.com>
