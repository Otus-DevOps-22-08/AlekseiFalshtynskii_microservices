output "external_ip_address_nodes" {
  value = yandex_compute_instance.nodes.*.network_interface.0.nat_ip_address
}
