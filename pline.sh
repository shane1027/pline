#!/bin/sh

# print out a specific line or range of lines of the given input file

usage() {

echo
cat << EOF
Usage: pline -f "filename.txt" -l line_num
            ~or~
       pline -f "filename.txt" -r line_start,line_stop

    -f input file
    -l line number to print
    -r range of lines to print
    -e enumerate lines (line_number + \t)

    NOTE: using '-r' ovrerides '-l'

EOF

exit 0;

}


# separate the input range to two parameters, start and stop
get_range() {

    line_start=`echo "$LINERANGE" | awk -F , '{print $1}'`
    line_stop=`echo "$LINERANGE" | awk -F , '{print $2}'`

    if [ ${line_stop:-0} -lt ${line_start:-1} ]; then
        echo "Invalid range parameter!"
        exit 1
    fi

}


# print out the line according to first argument
print_line() {

    # if ENUM mode is on, prefix all lines with a number and tab
    if [ $ENUMERATE -eq 1 ]; then
        #OUTPUT=`cat "${FILE:-/dev/stdin}" | sed -n ""$1"p"`
        OUTPUT=`cat /tmp/pline.tmp | sed -n ""$1"p"`
        echo "$1    $OUTPUT"
    else
        cat /tmp/pline.tmp | sed -n ""$1"p"
    fi

}

# set defaults
LINE=1
RANGEMODE=0
ENUMERATE=0

# read in the command line arguments
if [ $# -eq 0 ]; then
    usage
fi

while [ $# -gt 0 ]; do
    case $1 in
        -f) FILE="$2"
            shift
            ;;
        -l) LINE="$2"
            shift
            ;;
        -r) LINERANGE="$2"
            RANGEMODE=1
            shift
            ;;
        -e) ENUMERATE=1
            ;;
        -h) usage
            ;;
        *) usage;;
    esac
    shift
done


# check to make sure the file exists
# this syntax makes the default of FILE to be STDIN
if [ -e ${FILE:-/dev/stdin} ]; then
    # create a temp file to address stdin multiple times
    cat > /tmp/pline.tmp
    FILE=pline.tmp
    # check to see if range mode is enabled
    if [ $RANGEMODE -eq 1 ]; then
        get_range
        # for loop of printing lines form line_start to line_stop
        for num in $(seq $line_start $line_stop)
        do
            print_line $num
        done
    else
        # otherwise just print one line
        print_line $LINE
    fi
    # clean up .tmp file
    rm /tmp/pline.tmp
else
    echo "File does not exist!"
    exit 1
fi
