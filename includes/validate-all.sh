#!/bin/bash

run_unix_cmd() {
  # $1 is the line number
  # $2 is the cmd to run
  # $3 is the expected exit code
  output=`$2 2>&1`
  exit_code=$?
  if [[ $exit_code -ne $3 ]]; then
    printf "failed (incorrect exit status code) on line $1.\n"
    printf "  - exit code: $exit_code (expected $3)\n"
    printf "  - command: $2\n"
    if [[ -z $output ]]; then
      printf "  - output: <none>\n\n"
    else
      printf "  - output: <starts on next line>\n$output\n\n"
    fi
    exit 1
  fi
}

DATE=`date +%Y-%m-%d`

# Validation of the "list-pagination" module

printf "Testing ietf-list-pagination.yang (pyang)..."
command="pyang -Werror --ietf --max-line-length=72 ietf-system-capabilities@2021-04-02.yang ../ietf-list-pagination\@*.yang"
run_unix_cmd $LINENO "$command" 0
command="pyang --canonical ietf-system-capabilities@2021-04-02.yang ../ietf-list-pagination\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-list-pagination.yang (yanglint)..."
command="yanglint ietf-datastores@2018-02-14.yang ietf-yang-library@2019-01-04.yang ietf-system-capabilities@2021-04-02.yang ../ietf-list-pagination\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# Validation of the example for the "list-pagination" module
printf "Testing ex-system-capabilities.xml..."
command="yanglint -m -s example-social@$DATE.yang ietf-datastores@2018-02-14.yang ietf-yang-library@2019-01-04.yang ietf-system-capabilities@2021-04-02.yang ../ietf-list-pagination@*.yang ex-system-capabilities.xml ex-yang-library@$DATE.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"



# Vector Tests

# validate the example module first
printf "Testing example-social.yang (pyang)..."
command="pyang --lint --max-line-length=69 -p ../ example-social\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing example-social.yang (yanglint)..."
command="yanglint example-social\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# now validate the vector tests
printf "Testing ex-data-set.json..."
command="yanglint -s -m example-social\@*.yang ex-data-set.json"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

#printf "Testing ex-data-set.xml..."
#command="yanglint -s -m example-social\@*.yang ex-data-set.xml"
##run_unix_cmd $LINENO "$command" 0
##printf "okay.\n"
#printf "DISABLED (https://github.com/CESNET/libyang/issues/1272).\n"


