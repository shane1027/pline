# pline
Unix command line tool designed to print a line or range of lines from a file or from STDIN.


Today I finally became fed up with the need to smash together multiple commands
in a Unix pipeline just to
print out a specific line in a file or stdin.  So I made a tool to do it
instead!  Much easier, and has all the options I needed, including working with
STDIN in pipes after being added to my $PATH environment variable.

```
Usage: pline -f "filename.txt" -l line_num
            ~or~
       pline -f "filename.txt" -r line_start,line_stop

    -f input file
    -l line number to print
    -r range of lines to print
    -e enumerate lines (line_number + \t)

    NOTE: using '-r' overrides '-l'
```


