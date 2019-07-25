#!/usr/bin/env bash

# Helper to run most used functionalities

docker_message() {
    echo "To check the content of the docker run: docker logs -f $1"
    echo "NOTE: You can check all containers running using: docker ps"
}

execute_esbmc_docker() {
    docker_id=`docker run -d --user $UID --rm -it -v $(pwd):/home/esbmc/esbmc_src:Z \
           -e http_proxy=$http_proxy \
           -e https_proxy=$https_proxy \
           rafaelsamenezes/esbmc-cmake:latest $1`
    docker_message $docker_id
}

execute_esbmc_docker_privileged() {
    echo ""
    echo "Type the quantity of memory available (in GB), followed by [ENTER]:"
    read memory_limit

    echo "Type the quantity of threads to be used, followed by [ENTER]:"
    read threads

    docker_id=`docker run -d \
           -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
           -e http_proxy=$http_proxy \
           -e https_proxy=$https_proxy \
           --privileged --rm -it -v $(pwd):/home/esbmc/esbmc_src:Z \
           --memory="${memory_limit}g" --memory-swap="${memory_limit}g" \
           rafaelsamenezes/esbmc-cmake:latest $1 $((memory_limit / threads)) $threads`
    docker_message $docker_id
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
		exit 0;;

            "Floats")
                execute_esbmc_docker /home/esbmc/docker-scripts/regression-floats.sh
		exit 0;;

	    "Quit") exit 0;;

	    *) echo "Invalid Option :(";;
	esac
    done
    echo "When finished it will create a summary.log in the regression directory"
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
