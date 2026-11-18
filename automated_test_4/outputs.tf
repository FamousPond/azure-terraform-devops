output "web_public_ip" {
  value = module.lb.lb_ip
}

output "bastion_public_ip" {
  value = module.bastion.bastion_ip
}
