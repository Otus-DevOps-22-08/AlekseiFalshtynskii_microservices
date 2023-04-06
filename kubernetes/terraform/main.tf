provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "master" {
  source                   = "./master"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  private_key_path         = var.private_key_path
  public_key_path          = var.public_key_path
  image_id                 = var.image_id
  subnet_id                = var.subnet_id
}

module "nodes" {
  source                   = "./nodes"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  private_key_path         = var.private_key_path
  public_key_path          = var.public_key_path
  image_id                 = var.image_id
  subnet_id                = var.subnet_id
}
