#!/bin/bash

# Fast fail the script on failures.
set -ev

dartanalyzer --fatal-warnings lib test example

pub run build_runner test -- -p vm,firefox,chrome
pub run test -p vm,firefox,chrome