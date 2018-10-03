data "google_compute_zones" "available" {
  region = "${var.region}"
  status = "UP"
}

resource "google_compute_address" "instances" {
  count = "${var.count}"
  name  = "${var.name_prefix}-${count.index}"
}

resource "google_compute_disk" "instances" {
  count = "${var.count}"

  name = "${var.name_prefix}-${count.index+1}"
  type = "${var.disk_type}"
  size = "${var.disk_size}"
  zone = "${data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)]}"

  image = "${var.disk_image}"
}

resource "google_compute_instance" "instances" {
  count = "${var.count}"

  name         = "${var.name_prefix}-${count.index+1}"
  zone         = "${data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)]}"
  machine_type = "${var.machine_type}"

  boot_disk = {
    source      = "${google_compute_disk.instances.*.name[count.index]}"
    auto_delete = false
  }

  metadata {
    user-data = "${replace(replace(var.user_data, "$$ZONE", data.google_compute_zones.available.names[count.index]), "$$REGION", var.region)}"
  }

  metadata_startup_script = "${var.startup_script}"

  network_interface = {
    subnetwork = "${var.subnetwork}"

    access_config = {
      nat_ip = "${google_compute_address.instances.*.address[count.index]}"
    }
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }
}
