#!/usr/bin/env python3
import os, sys, re

input = sys.stdin
output = sys.stdout
nargs = len(sys.argv)

if nargs > 1:
    input = open(sys.argv[1])
if nargs > 2:
    output = open(sys.argv[2], 'w')

def match_callback(match):
    print('OK'+match.group(0))
    return match.group(0) \
      .replace(r'\#', '#') \
      .replace(r'\$', '$') \
      .replace(r'\%', '%') \
      .replace(r'\&', '&') \
      .replace(r'\{', '{') \
      .replace(r'\}', '}') \
      .replace(r'\_', '_') \
      .replace(r'\^{}', '^') \
      .replace(r'\~{}', '~') \
      .replace(r'\textless{}', '<') \
      .replace(r'\textless', '<') \
      .replace(r'\textgreater{}', '>') \
      .replace(r'\textgreater', '>') \
      .replace(r'\textbar{}', '|') \
      .replace(r'\textbar', '|') \
      .replace(r'\textbackslash{}', '\\') \
      .replace(r'\textbackslash', '\\') \
      .replace(r'$$', '$')

for s in input.readlines(  ):
    step1 = re.sub(r'\\\$.*\\\$', match_callback, s)
    step2 = re.sub(r'\\\$\\\$.*\\\$\\\$', match_callback, step1)
    output.write(step2)

output.close(  )
input.close(  )
