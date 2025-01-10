module "network" {
    source = "./modules/network"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    esky_availability_zone = var.esky_availability_zone
    static_private_nic_ip = var.static_private_nic_ip
}

module "compute" {
    source = "./modules/compute"
    instance_type = var.instance_type
    instance_key = var.instance_key
    public_nic_id = module.network.public-nic-ID
    private_nic_id = module.network.private-nic-ID

    depends_on = [ module.network ]
}