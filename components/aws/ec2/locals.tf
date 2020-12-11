locals {
  project_shortname = substr(var.name_prefix, 0, length(var.name_prefix) - 1)
  my_ip             = chomp(data.http.icanhazip.body)
  my_ip_cidr        = "${chomp(data.http.icanhazip.body)}/32"
  admin_cidr        = flatten([local.my_ip_cidr, var.admin_cidr])
  app_cidr          = length(var.app_cidr) == 0 ? local.admin_cidr : var.app_cidr
  pricing_regex = chomp(
    <<EOF
${var.environment.aws_region}\\\"\\X*${replace(var.instance_type, ".", "\\.")}\\X*prices\\X*USD:\\\"(\\X*)\\\"
EOF
  )
  # TODO: Detect EC2 Pricing
  # price_per_instance_hr    = (
  #   length(regexall(local.pricing_regex, data.http.ec2_base_pricing_js)) == 0 ? "n/a" :
  #   regex(local.pricing_regex, data.http.ec2_base_pricing_js)[0]
  # )
  chocolatey_install_win = <<EOF
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
EOF
}
