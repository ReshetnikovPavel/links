resource "yandex_storage_bucket" "links" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "links.pavelresh.ru"
  max_size              = 1073741824
  default_storage_class = "standard"
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
  }
}

resource "yandex_storage_object" "website_files" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.links.bucket
  for_each      = fileset(var.upload_directory, "**/*.*")
  key           = replace(each.value, var.upload_directory, "")
  source        = "${var.upload_directory}${each.value}"
  source_hash   = filemd5("${var.upload_directory}${each.value}")
}


