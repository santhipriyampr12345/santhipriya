#!/bin/bash



# Execution format:

if [[ $# < 3 ]];then

echo "Minimum 3 arguments expected **** 1 - servers seperated by , **** 2 - command to be executed on the server **** 3 - authenticated_user"

echo "execution format **** ./servers.sh '192.168.1.1,192.168.1.2' 'df -h' 'ravikm' ****"

exit 1;

fi

servers=$1

command=$2

user=$3



node=$(echo $servers | tr "," "\n")



for n in $node

do

echo

echo "Authenticating into server $n using SSH and executing command: '$command'"

if(ssh $user@$n exit 2>/dev/null);then

#executing given command and making standard error redirected to /dev/null to avoid ambiguous output



    echo "Connection to server $n successful"



    #Executing the command in a separate IF condition because there may be commands that pass on one server and may fail on other

    if(ssh $user@$n $command 2>/dev/null);then

        echo "command executed successfully on server $n"

    else

        echo "Command execution failed on server $n"

        exit 1;

    fi

else

    echo "Connection to server $n failed. Please ensure the list of all servers are authorized to be accessed by this user. Exiting further execution."

    exit 1;

fi

echo

done
