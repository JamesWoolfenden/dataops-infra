/*
* Airflow is an open source platform to programmatically author, schedule and monitor workflows. More information here: [airflow.apache.org](https://airflow.apache.org/)
*
*/

locals {
  airflow_url = "http://${module.airflow_ecs_task.load_balancer_dns}:8080"
}
