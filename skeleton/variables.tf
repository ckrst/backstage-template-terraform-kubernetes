variable "kube_config_path" {
  default = "kube_config"
}

variable "kube_config_context" {
  default = "microk8s"
}

variable "kube_config_context_cluster" {
  default = "microk8s-cluster"
}

variable "app_name" {
  default = "hello-world"
  description = "Prefix for everything, subdomain, etc..."
}

variable "app_image" {
  default = "nginx"
}

variable "app_port" {
  default = "80"
}

variable "my_domain" {
  default = "mydomain.local"
}

variable "enable_ingress" {
  default = true
}

variable "app_service_type" {
  default = "ClusterIP"
}

variable "backstage_config_path" {
  default = "skeleton/config/app-config.yaml"
}

# DATABASE
variable "postgres_host" {
  default = "localhost"
}

variable "postgres_port" {
  default = "5432"
}

variable "postgres_user" {
  default = "postgres"
}

variable "postgres_password" {
  default = "mypass"
}
  