locals {
  public_ip_file       = "${path.module}/public_ip"
}

module "acm_common" {
  source            = "../../modules/acm"
  admin_user        = var.admin_user
  admin_passwd      = var.admin_passwd
  host_default_user = var.ssh_user
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
}

resource "null_resource" "get_my_public_ip" {
  provisioner "local-exec" {
    command = "curl -sSf https://checkip.amazonaws.com > ${local.public_ip_file}"
  }
}

data "local_file" "my_public_ip" {
  depends_on = [null_resource.get_my_public_ip]
  filename   = local.public_ip_file
}

data "azurerm_image" "example_image" {
  name                = var.image_name
  resource_group_name = data.azurerm_resource_group.example_group.name
}

data "azurerm_resource_group" "example_group" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.example_group.location
  resource_group_name = data.azurerm_resource_group.example_group.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = data.azurerm_resource_group.example_group.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "api-connectivity-manager-public-ip"
  location            = data.azurerm_resource_group.example_group.location
  resource_group_name = data.azurerm_resource_group.example_group.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "eth0" {
  name                = "eth0-nic"
  location            = data.azurerm_resource_group.example_group.location
  resource_group_name = data.azurerm_resource_group.example_group.name

  ip_configuration {
    name                          = "api-connectivity-manager-ip-configuration"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_security_group" "example_sec_group" {
  name                = "example-sec-group"
  location            = data.azurerm_resource_group.example_group.location
  resource_group_name = data.azurerm_resource_group.example_group.name
}

resource "azurerm_subnet_network_security_group_association" "example_subnet" {
  subnet_id                 = azurerm_subnet.example_subnet.id
  network_security_group_id = azurerm_network_security_group.example_sec_group.id
}

resource "azurerm_network_security_rule" "example_security_group_rule" {
  name                        = "allow_cidr_ranges"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = ["22", "443"]
  source_address_prefixes     = var.incoming_cidr_blocks != null ? concat(var.incoming_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name = data.azurerm_resource_group.example_group.name
  network_security_group_name = azurerm_network_security_group.example_sec_group.name
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "api-connectivity-manager-machine"
  location            = data.azurerm_resource_group.example_group.location
  resource_group_name = data.azurerm_resource_group.example_group.name
  size                = var.instance_type
  admin_username      = var.ssh_user
  network_interface_ids = [
      azurerm_network_interface.eth0.id
  ]
  source_image_id = data.azurerm_image.example_image.id

  user_data = base64encode(templatefile("${path.root}/../templates/startup.sh.tmpl", { base64 = module.acm_common.htpasswd_data.content_base64 }))

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(pathexpand(var.ssh_pub_key))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
