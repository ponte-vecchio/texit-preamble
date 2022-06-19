#!/bin/sh

# Make a new TeX preamble file called "p_out.tex" 
# with the contents of each file in the argument

AUTHOR="LEOTHELION"
VERSION_YEAR="$(date +%Y)"
VERSION_MONTH="$(date +%m)"
VERSION_ABC="F"

# Touch file, or remove then create
if [[ -f "p_out.tex" ]]; then
    rm p_out.tex && touch p_out.tex
else
    touch p_out.tex
fi

# Header
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n%      ORIGINAL AUTHOR:  $AUTHOR\n%   VERSION (YYYY.MMA):  $VERSION_YEAR.$VERSION_MONTH$VERSION_ABC\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n" >> p_out.tex

# Shortcuts
printf '%s\n%s\n%s\n%s\n\n' \
    "% SHORTCUTS" \
    "\\edef\\tmp{\\catcode\`@\\the\\catcode\`@ \\space}\\makeatletter" \
    "\\let\\exaf\\expandafter" \
    "\\let\\ifpkg\\@ifpackageloaded" >> p_out.tex

# Append all args (Not Elegant but works)
for hook in "$@"; do
    if [[ -f "$hook.tex" ]]; then
        printf '%s\n' "% $hook.tex" | tr a-z A-Z >> p_out.tex
        cat "$hook.tex" >> p_out.tex && echo "\n" >> p_out.tex
    fi
done

# Footer
printf '%s\n%s\n%s'\
    "\\everymath\\exaf{\\the\\everymath\\color{fg}}" \
    "\\AtBeginDocument{\\randomTheme\\pagecolor{bg}}" \
    "\\begingroup \\def\\begin#1{\\endgroup \\begin{#1}\\color{fg}}" >> p_out.tex