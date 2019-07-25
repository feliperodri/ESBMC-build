#!/usr/bin/env bash

# Parse and create results file

parse_test_output() {
    echo ''
    echo '##############################' >> $2
    echo '# SUMMARY - Results          #' >> $2
    echo '##############################' >> $2

    success_ok=`cat $1 | grep '\^VERIFICATION SUCCESSFUL\$ \[OK\]' | wc -l`
    success_failed=`cat $1 | grep '\^VERIFICATION SUCCESSFUL\$ \[FAILED\]' | wc -l`
    failed_ok=`cat $1 | grep '\^VERIFICATION FAILED\$ \[OK\]' | wc -l`
    failed_failed=`cat $1 | grep '\^VERIFICATION FAILED\$ \[FAILED\]' | wc -l`
    echo "# Success OK: $success_ok"  >> $2
    echo "# Success FAILED: $success_failed" >> $2
    echo "# Failed OK: $failed_ok" >> $2
    echo "# Failed FAILED: $failed_failed" >> $2
}

make clean
make default

parse_test_output ./tests.log summary.log
