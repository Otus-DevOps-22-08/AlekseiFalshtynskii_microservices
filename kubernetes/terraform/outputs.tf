output "k8s_external_v4_endpoint" {
  value = yandex_kubernetes_cluster.k8s.master.0.external_v4_endpoint
}
