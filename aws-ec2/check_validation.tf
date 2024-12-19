check "health_check_http_AAP_8080" {
  data "http" "apache2_1_AAP" {
    url = "http://${aws_eip_association.eip_assoc1.public_ip}:8080"
  }

  assert {
    condition = data.http.apache2_1_AAP.status_code == 200
    error_message = "${data.http.apache2_1_AAP.url} returned an unhealthy status code"
  }
}