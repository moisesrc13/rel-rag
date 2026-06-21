resource "google_bigquery_dataset" "products_embedding_dataset" {
  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }
  access {
    role          = "OWNER"
    user_by_email = "mromo@relant.com.mx"
  }
  access {
    role          = "READER"
    special_group = "projectReaders"
  }
  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }
  dataset_id                 = "products_embedding_dataset"
  delete_contents_on_destroy = false
  labels = {
    managed-by-cnrm = "true"
  }
  location              = "US"
  max_time_travel_hours = "168"
  project               = "relant-rag-494516"
}
# terraform import google_bigquery_dataset.products_embedding_dataset projects/relant-rag-494516/datasets/products_embedding_dataset
resource "google_bigquery_table" "pdf_embeddings" {
  dataset_id = "products_embedding_dataset"
  labels = {
    managed-by-cnrm = "true"
  }
  project  = "relant-rag-494516"
  schema   = "[{\"name\":\"uri\",\"type\":\"STRING\"},{\"name\":\"content\",\"type\":\"STRING\"},{\"mode\":\"REPEATED\",\"name\":\"embedding\",\"type\":\"FLOAT\"}]"
  table_id = "pdf_embeddings"
}
# terraform import google_bigquery_table.pdf_embeddings projects/relant-rag-494516/datasets/products_embedding_dataset/tables/pdf_embeddings
resource "google_sql_database_instance" "free_trial_first_project" {
  database_version    = "MYSQL_8_4"
  instance_type       = "CLOUD_SQL_INSTANCE"
  maintenance_version = "MYSQL_8_4_8.R20260320.00_07"
  name                = "free-trial-first-project"
  project             = "relant-rag-494516"
  region              = "us-central1"
  settings {
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    backup_configuration {
      backup_retention_settings {
        retained_backups = 15
        retention_unit   = "COUNT"
      }
      start_time                     = "12:00"
      transaction_log_retention_days = 14
    }
    connector_enforcement = "NOT_REQUIRED"
    data_cache_config {
      data_cache_enabled = true
    }
    database_flags {
      name  = "cloudsql_iam_authentication"
      value = "on"
    }
    disk_autoresize       = false
    disk_autoresize_limit = 0
    disk_size             = 100
    disk_type             = "PD_SSD"
    edition               = "ENTERPRISE_PLUS"
    ip_configuration {
      ipv4_enabled = true
    }
    location_preference {
      zone = "us-central1-b"
    }
    pricing_plan = "PER_USE"
    tier         = "db-perf-optimized-N-8"
    user_labels = {
      managed-by-cnrm = "true"
    }
  }
}
# terraform import google_sql_database_instance.free_trial_first_project projects/relant-rag-494516/instances/free-trial-first-project
resource "google_project" "relant_rag_494516" {
  auto_create_network = true
  billing_account     = "017037-DC443C-3F0A23"
  labels = {
    managed-by-cnrm = "true"
  }
  name       = "relant-rag"
  org_id     = "334301084028"
  project_id = "relant-rag-494516"
}
# terraform import google_project.relant_rag_494516 projects/relant-rag-494516
resource "google_bigquery_table" "pdf_object_table" {
  dataset_id = "products_embedding_dataset"
  external_data_configuration {
    autodetect      = true
    connection_id   = "relant-rag-494516.us.relant-rag-connection-vertex"
    object_metadata = "SIMPLE"
    source_uris     = ["gs://relant-rag-files/*.pdf"]
  }
  labels = {
    managed-by-cnrm = "true"
  }
  project  = "relant-rag-494516"
  schema   = "[{\"mode\":\"NULLABLE\",\"name\":\"uri\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"generation\",\"type\":\"INTEGER\"},{\"mode\":\"NULLABLE\",\"name\":\"content_type\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"size\",\"type\":\"INTEGER\"},{\"mode\":\"NULLABLE\",\"name\":\"md5_hash\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"updated\",\"type\":\"TIMESTAMP\"},{\"fields\":[{\"mode\":\"NULLABLE\",\"name\":\"name\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"value\",\"type\":\"STRING\"}],\"mode\":\"REPEATED\",\"name\":\"metadata\",\"type\":\"RECORD\"},{\"fields\":[{\"mode\":\"NULLABLE\",\"name\":\"uri\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"version\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"authorizer\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"details\",\"type\":\"JSON\"}],\"mode\":\"NULLABLE\",\"name\":\"ref\",\"type\":\"RECORD\"}]"
  table_id = "pdf_object_table"
}
# terraform import google_bigquery_table.pdf_object_table projects/relant-rag-494516/datasets/products_embedding_dataset/tables/pdf_object_table
resource "google_document_ai_processor" "6f4007f7d9ecb3cd" {
  display_name = "relant-ocr-processor"
  location     = "us"
  project      = "36330710924"
  type         = "OCR_PROCESSOR"
}
# terraform import google_document_ai_processor.6f4007f7d9ecb3cd projects/36330710924/locations/us/processors/6f4007f7d9ecb3cd
resource "google_project_service" "aiplatform_googleapis_com" {
  project = "36330710924"
  service = "aiplatform.googleapis.com"
}
# terraform import google_project_service.aiplatform_googleapis_com 36330710924/aiplatform.googleapis.com
resource "google_project_service" "analyticshub_googleapis_com" {
  project = "36330710924"
  service = "analyticshub.googleapis.com"
}
# terraform import google_project_service.analyticshub_googleapis_com 36330710924/analyticshub.googleapis.com
resource "google_document_ai_processor" "ed2f33fe418aeaf1" {
  display_name = "relant-ocr-layout-processor"
  location     = "us"
  project      = "36330710924"
  type         = "LAYOUT_PARSER_PROCESSOR"
}
# terraform import google_document_ai_processor.ed2f33fe418aeaf1 projects/36330710924/locations/us/processors/ed2f33fe418aeaf1
resource "google_project_service" "bigquerymigration_googleapis_com" {
  project = "36330710924"
  service = "bigquerymigration.googleapis.com"
}
# terraform import google_project_service.bigquerymigration_googleapis_com 36330710924/bigquerymigration.googleapis.com
resource "google_project_service" "cloudasset_googleapis_com" {
  project = "36330710924"
  service = "cloudasset.googleapis.com"
}
# terraform import google_project_service.cloudasset_googleapis_com 36330710924/cloudasset.googleapis.com
resource "google_project_service" "bigqueryreservation_googleapis_com" {
  project = "36330710924"
  service = "bigqueryreservation.googleapis.com"
}
# terraform import google_project_service.bigqueryreservation_googleapis_com 36330710924/bigqueryreservation.googleapis.com
resource "google_project_service" "bigquery_googleapis_com" {
  project = "36330710924"
  service = "bigquery.googleapis.com"
}
# terraform import google_project_service.bigquery_googleapis_com 36330710924/bigquery.googleapis.com
resource "google_service_account" "relant_rag_service_account" {
  account_id   = "relant-rag-service-account"
  display_name = "relant-rag-service-account"
  project      = "relant-rag-494516"
}
# terraform import google_service_account.relant_rag_service_account projects/relant-rag-494516/serviceAccounts/relant-rag-service-account@relant-rag-494516.iam.gserviceaccount.com
resource "google_project_service" "bigqueryconnection_googleapis_com" {
  project = "36330710924"
  service = "bigqueryconnection.googleapis.com"
}
# terraform import google_project_service.bigqueryconnection_googleapis_com 36330710924/bigqueryconnection.googleapis.com
resource "google_project_service" "dataplex_googleapis_com" {
  project = "36330710924"
  service = "dataplex.googleapis.com"
}
# terraform import google_project_service.dataplex_googleapis_com 36330710924/dataplex.googleapis.com
resource "google_project_service" "storage_api_googleapis_com" {
  project = "36330710924"
  service = "storage-api.googleapis.com"
}
# terraform import google_project_service.storage_api_googleapis_com 36330710924/storage-api.googleapis.com
resource "google_project_service" "cloudapis_googleapis_com" {
  project = "36330710924"
  service = "cloudapis.googleapis.com"
}
# terraform import google_project_service.cloudapis_googleapis_com 36330710924/cloudapis.googleapis.com
resource "google_project_service" "documentai_googleapis_com" {
  project = "36330710924"
  service = "documentai.googleapis.com"
}
# terraform import google_project_service.documentai_googleapis_com 36330710924/documentai.googleapis.com
resource "google_project_service" "storage_googleapis_com" {
  project = "36330710924"
  service = "storage.googleapis.com"
}
# terraform import google_project_service.storage_googleapis_com 36330710924/storage.googleapis.com
resource "google_project_service" "bigquerydatapolicy_googleapis_com" {
  project = "36330710924"
  service = "bigquerydatapolicy.googleapis.com"
}
# terraform import google_project_service.bigquerydatapolicy_googleapis_com 36330710924/bigquerydatapolicy.googleapis.com
resource "google_storage_bucket" "36330710924_679445768_us_import_custom" {
  force_destroy = false
  labels = {
    goog-drz-discoveryengine-pcr-location = "us"
    managed-by-cnrm                       = "true"
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 3
      with_state = "ANY"
    }
  }
  location                 = "US"
  name                     = "36330710924_679445768_us_import_custom"
  project                  = "relant-rag-494516"
  public_access_prevention = "inherited"
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
  storage_class = "STANDARD"
}
# terraform import google_storage_bucket.36330710924_679445768_us_import_custom 36330710924_679445768_us_import_custom
resource "google_project_service" "datastore_googleapis_com" {
  project = "36330710924"
  service = "datastore.googleapis.com"
}
# terraform import google_project_service.datastore_googleapis_com 36330710924/datastore.googleapis.com
resource "google_project_service" "monitoring_googleapis_com" {
  project = "36330710924"
  service = "monitoring.googleapis.com"
}
# terraform import google_project_service.monitoring_googleapis_com 36330710924/monitoring.googleapis.com
resource "google_storage_bucket" "relant_rag_files" {
  force_destroy = false
  labels = {
    managed-by-cnrm = "true"
  }
  location                 = "US"
  name                     = "relant-rag-files"
  project                  = "relant-rag-494516"
  public_access_prevention = "enforced"
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
# terraform import google_storage_bucket.relant_rag_files relant-rag-files
resource "google_logging_project_sink" "a_required" {
  destination            = "logging.googleapis.com/projects/relant-rag-494516/locations/global/buckets/_Required"
  filter                 = "LOG_ID(\"cloudaudit.googleapis.com/activity\") OR LOG_ID(\"externalaudit.googleapis.com/activity\") OR LOG_ID(\"cloudaudit.googleapis.com/system_event\") OR LOG_ID(\"externalaudit.googleapis.com/system_event\") OR LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") OR LOG_ID(\"externalaudit.googleapis.com/access_transparency\")"
  name                   = "_Required"
  project                = "36330710924"
  unique_writer_identity = true
}
# terraform import google_logging_project_sink.a_required 36330710924###_Required
resource "google_project_service" "bigquerystorage_googleapis_com" {
  project = "36330710924"
  service = "bigquerystorage.googleapis.com"
}
# terraform import google_project_service.bigquerystorage_googleapis_com 36330710924/bigquerystorage.googleapis.com
resource "google_project_service" "logging_googleapis_com" {
  project = "36330710924"
  service = "logging.googleapis.com"
}
# terraform import google_project_service.logging_googleapis_com 36330710924/logging.googleapis.com
resource "google_project_service" "bigquerydatatransfer_googleapis_com" {
  project = "36330710924"
  service = "bigquerydatatransfer.googleapis.com"
}
# terraform import google_project_service.bigquerydatatransfer_googleapis_com 36330710924/bigquerydatatransfer.googleapis.com
resource "google_project_service" "servicemanagement_googleapis_com" {
  project = "36330710924"
  service = "servicemanagement.googleapis.com"
}
# terraform import google_project_service.servicemanagement_googleapis_com 36330710924/servicemanagement.googleapis.com
resource "google_project_service" "privilegedaccessmanager_googleapis_com" {
  project = "36330710924"
  service = "privilegedaccessmanager.googleapis.com"
}
# terraform import google_project_service.privilegedaccessmanager_googleapis_com 36330710924/privilegedaccessmanager.googleapis.com
resource "google_logging_project_sink" "a_default" {
  destination            = "logging.googleapis.com/projects/relant-rag-494516/locations/global/buckets/_Default"
  filter                 = "NOT LOG_ID(\"cloudaudit.googleapis.com/activity\") AND NOT LOG_ID(\"externalaudit.googleapis.com/activity\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"externalaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") AND NOT LOG_ID(\"externalaudit.googleapis.com/access_transparency\")"
  name                   = "_Default"
  project                = "36330710924"
  unique_writer_identity = true
}
# terraform import google_logging_project_sink.a_default 36330710924###_Default
resource "google_project_service" "telemetry_googleapis_com" {
  project = "36330710924"
  service = "telemetry.googleapis.com"
}
# terraform import google_project_service.telemetry_googleapis_com 36330710924/telemetry.googleapis.com
resource "google_project_service" "discoveryengine_googleapis_com" {
  project = "36330710924"
  service = "discoveryengine.googleapis.com"
}
# terraform import google_project_service.discoveryengine_googleapis_com 36330710924/discoveryengine.googleapis.com
resource "google_project_service" "sql_component_googleapis_com" {
  project = "36330710924"
  service = "sql-component.googleapis.com"
}
# terraform import google_project_service.sql_component_googleapis_com 36330710924/sql-component.googleapis.com
resource "google_project_service" "storage_component_googleapis_com" {
  project = "36330710924"
  service = "storage-component.googleapis.com"
}
# terraform import google_project_service.storage_component_googleapis_com 36330710924/storage-component.googleapis.com
resource "google_project_service" "drive_googleapis_com" {
  project = "36330710924"
  service = "drive.googleapis.com"
}
# terraform import google_project_service.drive_googleapis_com 36330710924/drive.googleapis.com
resource "google_project_service" "dataform_googleapis_com" {
  project = "36330710924"
  service = "dataform.googleapis.com"
}
# terraform import google_project_service.dataform_googleapis_com 36330710924/dataform.googleapis.com
resource "google_project_service" "cloudtrace_googleapis_com" {
  project = "36330710924"
  service = "cloudtrace.googleapis.com"
}
# terraform import google_project_service.cloudtrace_googleapis_com 36330710924/cloudtrace.googleapis.com
resource "google_project_service" "serviceusage_googleapis_com" {
  project = "36330710924"
  service = "serviceusage.googleapis.com"
}
# terraform import google_project_service.serviceusage_googleapis_com 36330710924/serviceusage.googleapis.com
resource "google_project_service" "sqladmin_googleapis_com" {
  project = "36330710924"
  service = "sqladmin.googleapis.com"
}
# terraform import google_project_service.sqladmin_googleapis_com 36330710924/sqladmin.googleapis.com
