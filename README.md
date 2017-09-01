# airflow-useradd
create user for airflow webUI
bash wrapper for the script addition commands

  * add new user for web UI password authentication
  ```[webserver]
  authenticate = True
  auth_backend = airflow.contrib.auth.backends.password_auth 
  ```
  Automates the commands for adding new user for Airflow WebUI
