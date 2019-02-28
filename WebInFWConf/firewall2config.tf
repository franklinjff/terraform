resource "panos_general_settings" "fw2" {
  provider    = "panos.fw2"
  hostname    = "WebFW2"
  dns_primary = "10.0.0.2"
}

resource "panos_management_profile" "imp_allow_pinga2" {
  provider = "panos.fw2"
  name     = "Allow ping"
  ping     = true
}

resource "panos_ethernet_interface" "eth1_1a2" {
  provider           = "panos.fw2"
  name               = "ethernet1/1"
  vsys               = "vsys1"
  mode               = "layer3"
  comment            = "External interface"
  enable_dhcp        = true
  management_profile = "${panos_management_profile.imp_allow_pinga2.name}"
}

resource "panos_ethernet_interface" "eth1_2a2" {
  provider    = "panos.fw2"
  name        = "ethernet1/2"
  vsys        = "vsys1"
  mode        = "layer3"
  comment     = "Web interface"
  enable_dhcp = true
}

resource "panos_zone" "zone_untrusta2" {
  provider   = "panos.fw2"
  name       = "UNTRUST"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.eth1_1.name}"]
}

resource "panos_zone" "zone_trusta2" {
  provider   = "panos.fw2"
  name       = "TRUST"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.eth1_2.name}"]
}

resource "panos_service_object" "so_22a2" {
  provider         = "panos.fw2"
  name             = "service-tcp-22"
  protocol         = "tcp"
  destination_port = "22"
}

resource "panos_service_object" "so_221a2" {
  provider         = "panos.fw2"
  name             = "service-tcp-221"
  protocol         = "tcp"
  destination_port = "221"
}

resource "panos_service_object" "so_222a2" {
  provider         = "panos.fw2"
  name             = "service-tcp-222"
  protocol         = "tcp"
  destination_port = "222"
}

resource "panos_service_object" "so_81a2" {
  provider         = "panos.fw2"
  name             = "service-http-81"
  protocol         = "tcp"
  destination_port = "81"
}

resource "panos_address_object" "intNLB2" {
  provider    = "panos.fw2"
  name        = "AWS-Int-NLB"
  type        = "fqdn"
  value       = "${var.int-nlb-fqdn}"
  description = "AWS Int NLB Address"
}

resource "panos_security_policies" "security_policiesa2" {
  provider = "panos.fw2"

  rule {
    name                  = "SSH inbound"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["ssh", "ping"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "SSH 221-222 inbound"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["ssh", "ping"]
    services              = ["${panos_service_object.so_221.name}", "${panos_service_object.so_222.name}"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Allow all ping"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = ["any"]
    applications          = ["ping"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Web browsing"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}", "${panos_zone.zone_untrust.name}"]
    destination_addresses = ["any"]
    applications          = ["web-browsing"]
    services              = ["service-http", "${panos_service_object.so_81.name}"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Allow all outbound"
    source_zones          = ["${panos_zone.zone_trust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_untrust.name}"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Permit Health Checks"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["elb-healthchecker"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}

resource "panos_nat_policy" "nat1a2" {
  provider              = "panos.fw2"
  name                  = "Web1 SSH"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "${panos_service_object.so_221.name}"
  source_addresses      = ["any"]
  destination_addresses = ["${var.untrust-ipaddress-fw2}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "static"
  dat_address           = "${var.WebSrv1_IP}"
  dat_port              = "22"
}

resource "panos_nat_policy" "nat2a2" {
  provider              = "panos.fw2"
  name                  = "Web2 SSH"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "${panos_service_object.so_222.name}"
  source_addresses      = ["any"]
  destination_addresses = ["${var.untrust-ipaddress-fw2}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "static"
  dat_address           = "${var.WebSrv2_IP}"
  dat_port              = "22"
}

resource "panos_nat_policy" "nat3a2" {
  provider              = "panos.fw2"
  name                  = "Webserver1 NAT"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "service-http"
  source_addresses      = ["any"]
  destination_addresses = ["${var.untrust-ipaddress-fw2}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "dynamic"
  dat_address           = "AWS-Int-NLB"
  dat_port              = "80"
}

resource "panos_virtual_router" "vr1a2" {
  provider   = "panos.fw2"
  name       = "default"
  interfaces = ["${panos_ethernet_interface.eth1_1a2.name}", "${panos_ethernet_interface.eth1_2a2.name}"]
}
