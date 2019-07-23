#!/usr/bin/env bash

# Helper to run most used functionalities

execute_esbmc_docker() {
    docker run --user $UID --rm -it -v $(pwd):/home/esbmc/esbmc_src:Z \
           rafaelsamenezes/esbmc-cmake:latest $1
}

execute_esbmc_docker_privileged() {
    echo ""
    echo "Type the quantity of memory available (in GB), followed by [ENTER]:"
    read memory_limit

    echo "Type the quantity of threads to be used, followed by [ENTER]:"
    read threads
    docker run  \
           -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
           --privileged --rm -it -v $(pwd):/home/esbmc/esbmc_src:Z \
           --memory="${memory_limit}g" --memory-swap="${memory_limit}g" \
           rafaelsamenezes/esbmc-cmake:latest $1 $((memory_limit / threads)) $threads
}

parse_test_output() {
    echo ''
    echo '##############################'
    echo '# SUMMARY - Results          #'
    echo '##############################'

    success_ok=`cat $1 | grep '\^VERIFICATION SUCCESSFUL\$ \[OK\]' | wc -l`
    success_failed=`cat $1 | grep '\^VERIFICATION SUCCESSFUL\$ \[FAILED\]' | wc -l`
    failed_ok=`cat $1 | grep '\^VERIFICATION FAILED\$ \[OK\]' | wc -l`
    failed_failed=`cat $1 | grep '\^VERIFICATION FAILED\$ \[FAILED\]' | wc -l`
    echo "# Success OK: $success_ok"
    echo "# Success FAILED: $success_failed"
    echo "# Failed OK: $failed_ok"
    echo "# Failed FAILED: $failed_failed"
}

build_options() {
    echo ""
    echo "Ok. Which solver do you want to use?"
    solver_options=("Boolector" "Z3" "Yices" "MathSat" "CVC4" "All" "Quit")
    select solver_selected in "${solver_options[@]}"
    do
	case $solver_selected in
	    "All")
                execute_esbmc_docker /home/esbmc/docker-scripts/build-all-static-python.sh
		exit 0;;

	    "Quit")
		exit 0;;

	    *)
		echo "Not implemented yet! For now, use (All) :(";;
	esac
    done
}

regression_options() {
    echo ""
    echo "Ok. Which regression do you want to use?"
    solver_options=("ESBMC" "Floats" "Quit")
    select solver_selected in "${solver_options[@]}"
    do
	case $solver_selected in
	    "ESBMC")
                execute_esbmc_docker /home/esbmc/docker-scripts/regression-esbmc.sh
                parse_test_output ./regression/esbmc/tests.log
		exit 0;;

            "Floats")
                execute_esbmc_docker /home/esbmc/docker-scripts/regression-floats.sh
                parse_test_output ./regression/floats/tests.log
		exit 0;;

	    "Quit") exit 0;;

	    *) echo "Invalid Option :(";;
	esac
    done
}

benchexec_options() {
    echo ""
    echo "Ok. Which benchmark do you want to run?"
    solver_options=("TestComp'19" "Quit")
    select solver_selected in "${solver_options[@]}"
    do
	case $solver_selected in
	    "TestComp'19")
                execute_esbmc_docker_privileged /home/esbmc/docker-scripts/test-comp-19.sh
		exit 0;;

	    "Quit") exit 0;;

	    *) echo "Invalid Option :(";;
	esac
    done
}

echo "This script will help you manage ESBMC build and testing using Docker"
echo ""
echo "Be SURE that you are executing this script from esbmc folder (it contains the README.md)"

PS3='Please enter your choice: '
options=("Build (Static+Python)" "Regression" "Benchexec" "Bash" "Quit")

echo ""
echo "Which mode do you want to run?"

select opt in "${options[@]}"
do
    case $opt in
	"Build (Static+Python)")
	    build_options
            break;;

        "Regression")
	    regression_options
            break;;

        "Benchexec")
            benchexec_options
            break;;

        "Bash")
            execute_esbmc_docker_privileged /bin/bash
            break;;

        "Quit")
            break;;

        *) echo "Not implemented yet! :(";;
    esac
done
