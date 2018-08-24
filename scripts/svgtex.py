#!/usr/bin/env python3
import os, sys, re

input = sys.stdin
output = sys.stdout
nargs = len(sys.argv)

if nargs > 1:
    input = open(sys.argv[1])
if nargs > 2:
    output = open(sys.argv[2], 'w')

def escape_callback(match):
    return re.sub(r'(?<=[^\\])_', '\\_', match.group(0))

for s in input.readlines(  ):
    step1 = re.sub(r'\\begin\{tabular\}.*\\end\{tabular\}', escape_callback, s)
    step2 = re.sub(r'^\s*\\begin\{picture\}', r'  \\def\\svgwidth{\\columnwidth}\n  \\resizebox{\\columnwidth}{!}{%\n  \\centering%\n  \\begin{picture}', step1)
    step3 = re.sub(r'^\s*\\end\{picture\}%', r'  \\end{picture}%\n  }', step2)
    output.write(step3)

output.close(  )
input.close(  )
