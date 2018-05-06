#!/bin/bash
files=( './SimonSays.rb' './Gemfile' './bin/vimall.sh' )
files_find="$( find ./src -name '*.rb' )"
vim +'source ./vimrc' ${files[@]} ${files_find[@]}
