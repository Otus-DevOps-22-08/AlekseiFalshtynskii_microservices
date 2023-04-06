output "external_ip_address_master" {
  value = module.master.external_ip_address_master
}

output "external_ip_address_nodes" {
  value = module.nodes.external_ip_address_nodes
}
