output "app_service_name" {
  value = "${azurerm_app_service.dockerapp.name}"
}
 
output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.dockerapp.default_site_hostname}"
}