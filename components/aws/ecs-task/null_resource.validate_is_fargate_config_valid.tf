resource "null_resource" "validate_is_fargate_config_valid" {
  count = (
    var.use_fargate == false ? 0 :
    # Check for invalid combinations of RAM and CPU for Fargate: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
    var.container_ram_gb >= 2 * var.container_num_cores &&
    var.container_ram_gb <= 8 * var.container_num_cores &&
    var.container_ram_gb <= 30 ? 0 # OK if this check passes
    : "error"




    # Force an error if check fails
  )
}
