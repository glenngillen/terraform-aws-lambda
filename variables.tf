variable "name" {}
variable "handler" {}
variable "runtime" {}
variable "layers" {
  default = []
}
variable "variables" {
  default = { }
}
variable "filename" {}
variable "source_code_hash" {}
variable "timeout" {
  default = 3
}
variable "memory_size" {
  default = 128
}
variable "tags" {
  default = {}
}