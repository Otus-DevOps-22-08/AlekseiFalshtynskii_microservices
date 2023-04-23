provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kubernetes_cluster" "k8s" {
  name       = "test-cluster"
  network_id = var.k8s_network_id
  master {
    version = var.k8s_version
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }
    public_ip = true
  }
  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  name       = "test-group"
  cluster_id = yandex_kubernetes_cluster.k8s.id

  version = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [var.subnet_id]
    }

    resources {
      memory        = 8
      cores         = 4
      core_fraction = 50
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
