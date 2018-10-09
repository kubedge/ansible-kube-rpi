#!/bin/bash
echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
echo "$(tput setaf 2)================= Running yamllint on yml File ================$(tput setaf 9)"
echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
find . -name '*.yml' -print -exec  yamllint -d '{extends: relaxed, rules: {line-length: {max: 120}}}' {} \;
echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
echo "$(tput setaf 2)================= Running yamllint on yaml File ===============$(tput setaf 9)"
echo "$(tput setaf 2)===============================================================$(tput setaf 9)"
find . -name '*.yaml' -print -exec  yamllint -d '{extends: relaxed, rules: {line-length: {max: 120}}}' {} \;

