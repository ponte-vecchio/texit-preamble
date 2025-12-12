#!/bin/bash

# Make a new TeX preamble file
# with the contents of each (or all) preamble module hook in the argument

AUTHOR="LEOTHELION"
VERSION_YEAR="$(date +%Y)"
VERSION_MONTH="$(date +%m)"
OUTPUT_NAME="preamble.tex"
TEST=0

# Check if the first argument is "test"
if [ "$1" = "test" ]; then
    OUTPUT_NAME="preamble_check.tex"
    TEST=1
fi

# Touch file, or remove then create
if [[ -f "$OUTPUT_NAME" ]]; then
    rm $OUTPUT_NAME && touch $OUTPUT_NAME
else
    touch $OUTPUT_NAME
fi

# Header
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n%      ORIGINAL AUTHOR:  $AUTHOR\n%   VERSION (YYYY.MMA):  $VERSION_YEAR.$VERSION_MONTH\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n" >> $OUTPUT_NAME

# Load Class if "Test"
if [ $TEST -eq 1 ]; then
    printf '%s\n' "\\documentclass[preview,margin=10pt]{standalone}"  >> $OUTPUT_NAME
fi

# Shortcuts
printf '%s\n%s\n%s\n%s\n\n' \
    "% SHORTCUTS" \
    "\\edef\\tmp{\\catcode\`@\\the\\catcode\`@ \\space}\\makeatletter" \
    "\\let\\exaf\\expandafter" \
    "\\let\\ifpkg\\@ifpackageloaded" >> $OUTPUT_NAME

# Append Hooks to output file
ALL_HOOKS=("aaa" "fonts" "math" "typ" "llipsum" "demobox" "chemistry" "texit" "colourscheme" "colorprofile" "fonttable" "draw" "zzz")
if [[ $1 == "all" || TEST -eq 1 ]]; then
    for hook in "${ALL_HOOKS[@]}"; do
        printf '%s\n' "% $hook" | tr a-z A-Z >> $OUTPUT_NAME
        cat "$hook.sty" >> $OUTPUT_NAME && echo "\n" >> $OUTPUT_NAME
    done
else
# Append all args (Not Elegant but works)
    for hook in "$@"; do
        if [[ -f "$hook.sty" || -f "$hook.tex" ]]; then
            printf '%s\n' "% $hook" | tr a-z A-Z >> $OUTPUT_NAME
            cat "$hook.sty" >> $OUTPUT_NAME && echo "\n" >> $OUTPUT_NAME
        fi
    done
fi

# Footer
printf '\n%s\n'\
    "\\makeatother" >> $OUTPUT_NAME

# Insert test command
if [ $TEST -eq 1 ]; then
    printf '%s\n' "\\begin{document}" >> $OUTPUT_NAME
    printf '%s\n' "$2" >> $OUTPUT_NAME
    printf '%s\n' "\\end{document}" >> $OUTPUT_NAME
fi

# Exit if non-test, or begin testing
if [ $TEST -eq 0 ]; then
    printf '%s\n' "Preamble generated."
    exit 0
else
    # pdflatex only
    printf '%s\n' "Checking TeXit compatibility (pdfLaTeX)"
    timeout 10 latexmk -pdf $OUTPUT_NAME > /dev/null && echo "Preamble Check Passed" && latexmk -C > /dev/null && rm $OUTPUT_NAME && exit 0 || echo "Preamble Check Failed" && exit 1
fi
