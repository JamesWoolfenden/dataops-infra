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
  userdata_lin = <<EOF
#!/bin/bash
export HOMEDIR=/home/ubuntu/tableau
mkdir -p $HOMEDIR
cd $HOMEDIR
sudo chmod 777 $HOMEDIR
echo "" > ___BOOSTSTRAP_UNPACK_STARTED_
export PROJECT=${local.project_shortname}
${var.use_https == false ? "" : "export HTTPS_DOMAIN=${var.https_domain}"}
${join("\n",
  [for x in var.file_resources :
    substr(x, 0, 4) == "http"
    ? "curl ${split("::", x)[0]} > ${length(split("::", x)) == 1 ? basename(x) : split("::", x)[1]}"
    : "echo ${base64encode(file("${split("::", x)[0]}"))} | base64 --decode > ${length(split("::", x)) == 1 ? basename(x) : split("::", x)[1]}"
  ]
)}
echo "" > __BOOTSTRAP_UNPACK_COMPLETE_
echo "" > _BOOTSTRAP_SCRIPT_STARTED_
sudo chmod -R 777 $HOMEDIR
./bootstrap.sh
echo "" > _BOOTSTRAP_SCRIPT_COMPLETE_
EOF

userdata_win = <<EOF
<script>
set PROJECT=${local.project_shortname}
${var.use_https == false ? "" : "set HTTPS_DOMAIN=${var.https_domain}"}
${local.chocolatey_install_win}
set HOMEDIR=C:\Users\Administrator\tableau
choco install -y curl
mkdir %HOMEDIR% 2> NUL
cd %HOMEDIR%
echo "" > ___BOOSTSTRAP_STARTED_
${join("\n",
[for x in var.file_resources :
  substr(x, 0, 4) == "http"
  ? "curl ${x} > ${length(split("::", x)) == 1 ? basename(x) : split("::", x)[1]}"
  : "echo ${base64encode(file("${x}"))} > ${basename(x)}.b64 && certutil -decode ${basename(x)}.b64 ${length(split("::", x)) == 1 ? basename(x) : split("::", x)[1]} & del ${basename(x)}.b64"
]
)}
dism.exe /online /import-defaultappassociations:defaultapps.xml
echo "" > __BOOTSTRAP_COMPLETE_
echo "" > __USERDATA_SCRIPT_STARTED_
bootstrap.bat
cd %HOMEDIR%
echo "" > _USERDATA_SCRIPT_COMPLETE_
</script>
<persist>true</persist>
EOF
}
