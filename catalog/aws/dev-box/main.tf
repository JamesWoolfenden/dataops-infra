/*
* The `dev-box` catalog module deploys an ECS-backed container which can be used to remotely test
* or develop using the native cloud environment. Applicable use cases include:
*
* * Debugging network firewall and routing rules
* * Debugging components which can only be run from whitelisted IP ranges
* * Offloading heavy processing from the developer's local laptop
* * Mitigating network relability issues when working from WiFi or home networks
*
*/

data "aws_availability_zones" "az_list" {}
