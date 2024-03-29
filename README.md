nimtb
===

nimtb - columnate list transforme to human readble table format.

## install

```bash
git clone https://github.com/blacknon/nimtb
cd nimtb
nimble install
```

## usage

```shell
$ # show help
$ tb --help
tb: columnate list transforme to human readble table format.

Usage:
   [options] [file ...]

Arguments:
  [file ...]       Read from this files...

Options:
  -h, --help
  -t, --table                display markdown table mode.
  -l, --header               set header at 1st line.
  -n, --number               show row number.
  -q, --quote                Treat elements enclosed in double quotation marks as one column.
  -s, --separator=SEPARATOR  Specify a set of characters to be used to delimited columns. (default:  )
  -L, --left-align=LEFT_ALIGN
                             Aligns the specified column to the left. ex) -L 1-3,7,10
  -R, --right-align=RIGHT_ALIGN
                             Aligns the specified column to the right. ex) -R 2-4,8,11
  -C, --center-align=CENTER_ALIGN
                             Aligns the specified column to the center. ex) -C 3-5,9,12

$ # show table like `column -t`
$ seq 1 10 991 | xargs -n10 | tb
 1    11   21   31   41   51   61   71   81   91
 101  111  121  131  141  151  161  171  181  191
 201  211  221  231  241  251  261  271  281  291
 301  311  321  331  341  351  361  371  381  391
 401  411  421  431  441  451  461  471  481  491
 501  511  521  531  541  551  561  571  581  591
 601  611  621  631  641  651  661  671  681  691
 701  711  721  731  741  751  761  771  781  791
 801  811  821  831  841  851  861  871  881  891
 901  911  921  931  941  951  961  971  981  991

$ # show markdown table
$ seq 1 10 991 | xargs -n10 | tb -lt
| 1    | 11   | 21   | 31   | 41   | 51   | 61   | 71   | 81   | 91   |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 101  | 111  | 121  | 131  | 141  | 151  | 161  | 171  | 181  | 191  |
| 201  | 211  | 221  | 231  | 241  | 251  | 261  | 271  | 281  | 291  |
| 301  | 311  | 321  | 331  | 341  | 351  | 361  | 371  | 381  | 391  |
| 401  | 411  | 421  | 431  | 441  | 451  | 461  | 471  | 481  | 491  |
| 501  | 511  | 521  | 531  | 541  | 551  | 561  | 571  | 581  | 591  |
| 601  | 611  | 621  | 631  | 641  | 651  | 661  | 671  | 681  | 691  |
| 701  | 711  | 721  | 731  | 741  | 751  | 761  | 771  | 781  | 791  |
| 801  | 811  | 821  | 831  | 841  | 851  | 861  | 871  | 881  | 891  |
| 901  | 911  | 921  | 931  | 941  | 951  | 961  | 971  | 981  | 991  |

$ # right align
$ seq 1 10 991 | xargs -n10 | tb -lt -R 3-5
| 1    | 11   |   21 |   31 |   41 | 51   | 61   | 71   | 81   | 91   |
| :--- | :--- | ---: | ---: | ---: | :--- | :--- | :--- | :--- | :--- |
| 101  | 111  |  121 |  131 |  141 | 151  | 161  | 171  | 181  | 191  |
| 201  | 211  |  221 |  231 |  241 | 251  | 261  | 271  | 281  | 291  |
| 301  | 311  |  321 |  331 |  341 | 351  | 361  | 371  | 381  | 391  |
| 401  | 411  |  421 |  431 |  441 | 451  | 461  | 471  | 481  | 491  |
| 501  | 511  |  521 |  531 |  541 | 551  | 561  | 571  | 581  | 591  |
| 601  | 611  |  621 |  631 |  641 | 651  | 661  | 671  | 681  | 691  |
| 701  | 711  |  721 |  731 |  741 | 751  | 761  | 771  | 781  | 791  |
| 801  | 811  |  821 |  831 |  841 | 851  | 861  | 871  | 881  | 891  |
| 901  | 911  |  921 |  931 |  941 | 951  | 961  | 971  | 981  | 991  |
```
