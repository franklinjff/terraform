data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "WebCIDR_TrustBlock1" {}
variable "WebCIDR_TrustBlock2" {}
variable "WebCIDR_UntrustBlock1" {}
variable "WebCIDR_UntrustBlock2" {}
variable "WebCIDR_MGMT1" {}
variable "WebCIDR_MGMT2" {}
variable "WebSRV1_AZ1_Trust" {}
variable "WebSRV2_AZ2_Trust" {}
variable "FW1_Untrust_IP" {}
variable "FW1_Trust_IP" {}
variable "FW1_mgmt_IP" {}
variable "FW2_Untrust_IP" {}
variable "FW2_Trust_IP" {}
variable "FW2_mgmt_IP" {}
variable "MasterS3Bucket" {}
variable "VPCName" {}
variable "VPCCIDR" {}
variable "ServerKeyName" {}
variable "StackName" {}

variable "PANFWRegionMap" {
  type = "map"

  #VMSeries 8.1 Bundle 2 Paygo 
  default = {
    "us-east-1"      = "ami-bffd3cc2"
    "us-east-2"      = "ami-9ef3c5fb"
    "us-west-1"      = "ami-854551e5"
    "us-west-2"      = "ami-9a29b8e2"
    "eu-west-1"      = "ami-1fb1ff66"
    "eu-west-2"      = "ami-c4688fa3"
    "ap-northeast-1" = "ami-75652e13"
    "ap-northeast-2" = "ami-a8bf13c6"
    "ap-southeast-1" = "ami-36bdec4a"
    "ap-southeast-2" = "ami-add013cf"
    "eu-central-1"   = "ami-1ebdd571"
    "sa-east-1"      = "ami-d80653b4"
    "ca-central-1"   = "ami-57048333"
    "ap-south-1"     = "ami-ee80d981"
  }
}

variable "WebServerRegionMap" {
  type = "map"

  default = {
    "us-east-1"      = "ami-065c9a4762c4f787e"
    "us-east-2"      = "ami-0444e91f56f79d021"
    "us-west-2"      = "ami-04b2b09887d4690bf"
    "us-west-1"      = "ami-0d1c4f9551a9fc202"
    "eu-west-1"      = "ami-a10897d6"
    "eu-central-1"   = "ami-a8221fb5"
    "ap-northeast-1" = "ami-cbf90ecb"
    "ap-southeast-1" = "ami-68d8e93a"
    "ap-southeast-2" = "ami-fd9cecc7"
    "sa-east-1"      = "ami-b52890a8"
    "cn-north-1"     = "ami-f239abcb"
  }
}

variable "UbuntuRegionMap" {
  type = "map"

  #Ubuntu Server 14.04 LTS (HVM)
  default = {
    "us-east-1"      = "ami-065c9a4762c4f787e"
    "us-east-2"      = "ami-0444e91f56f79d021"
    "us-west-1"      = "ami-0d1c4f9551a9fc202"
    "us-west-2"      = "ami-04b2b09887d4690bf"
    "eu-west-1"      = "ami-0cb24a4facc52bcf2"
    "eu-west-2"      = "ami-09f492b3362c7076d"
    "ap-northeast-1" = "ami-0df6eb3e7347fbd0c"
    "ap-northeast-2" = "ami-02c80391342e66874"
    "ap-southeast-1" = "ami-05f2539de34a6c7d2"
    "ap-southeast-2" = "ami-0ff4a8cdaadf626fd"
    "eu-central-1"   = "ami-0b84f6d2e5198bcd2"
    "sa-east-1"      = "ami-08f8981c2b55e1b30"
    "ca-central-1"   = "ami-0db8ab280248b9241"
    "ap-south-1"     = "ami-0a05f07249c9d50bc"
  }
}
