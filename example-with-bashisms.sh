#!/bin/sh

# Two bashisms on the next line:
#   alternative test command ([[ foo ]] should be [ foo ])
#   should be 'b = a'
if [[ $# == 0 ]]; do
  echo foo
done
