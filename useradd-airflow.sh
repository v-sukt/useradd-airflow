#!/bin/bash
# useradd-airflow.sh : add user to airflow webserver login 
# For simple password authentication - auth_backend = airflow.contrib.auth.backends.password_auth
# A small script to add the user via CLI. This adds new users DB

# Requires :
#    - airflow initdb already done (airflow.cfg at proper place and AIRFLOW_HOME correctly exported) 
#    - used as airflow user (change in $USER if required, if airflow being executed as different user)

useradd() {

python3.4 <<-user_add &>/dev/null
import airflow
from airflow import models, settings
from airflow.contrib.auth.backends.password_auth import PasswordUser
user = PasswordUser(models.User())
user.username = "$1"
user.email = "$2"
user.password = "$3"
session = settings.Session()
session.add(user)
session.commit()
user_add

return $?

}

# Checks if being executed by correct user
if [ $USER != "airflow" ];then
        echo -e "ERROR!!\nExecute script as airflow user"
        exit 3
fi

# show the correct syntax of the code
if [ $# -eq 0 ]; then
        echo -e "Usage\n\t$0 <user> <email> <password> \n\t$0 -p and enter values on commandline"
        exit 1
fi

# execute if 3 arguments ae received - all values as parameters
if [ $# -eq 3 ]; then
        echo -e "\n+++++++++++++++++++++++++++"
        useradd $1 $2 $3 && echo -e "\nSuccess...!!"    || echo "Failure..."
        echo -e "\n+++++++++++++++++++++++++++"
        exit
fi

# For -p if all input is provided by user
if [ "$1" == "-p" ]; then
        echo "+++++++++++++++++++++++++++"
        echo "Please enter the new user details"
        read -p "Username: " username
        read -p "Email ID: " email
        read -p "Password: " -s password
        useradd $username $email $password && echo -e "\nSuccess...!!"  || echo "Failure..."
        echo -e "\n+++++++++++++++++++++++++++"
fi
