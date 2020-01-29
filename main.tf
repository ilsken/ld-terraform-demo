# Configure the LaunchDarkly provider
provider "launchdarkly" {
  version     = "~> 1.0"
  access_token = var.launchdarkly_access_token
}

resource "launchdarkly_project" "demo" {
  key  = "demo"
  name = "Demo"

  tags = [
    "terraform",
  ]
}

resource "launchdarkly_environment" "staging" {
  name  = "Staging"
  key   = "staging"
  color = "23abf5"
  tags  = ["terraform"]

  project_key = launchdarkly_project.demo.key
}

resource "launchdarkly_feature_flag" "building_materials" {
  project_key = launchdarkly_project.demo.key
  key         = "building-materials"
  name        = "Building materials"
  description = "this is a multivariate flag with string variations."

  variation_type = "string"
  variations {
    value       = "straw"
    name        = "Straw"
    description = "Watch out for wind."
  }
  variations {
    value       = "sticks"
    name        = "Sticks"
    description = "Sturdier than straw"
  }
  variations {
    value       = "bricks"
    name        = "Bricks"
    description = "The strongest variation"
  }

  tags = [
    "example",
    "terraform",
    "multivariate",
    "building-materials",
  ]
}

resource "launchdarkly_custom_role" "allow_access_to_staging" {
  count = 0
  key         = "staging-access"
  name        = "${launchdarkly_project.demo.name} ${launchdarkly_environment.staging.name}"
  description = "Allow all Actions ${launchdarkly_project.demo.name} ${launchdarkly_environment.staging.name}"

  policy {
    effect    = "allow"
    resources = ["proj/${launchdarkly_project.demo.key}:env/${launchdarkly_environment.staging.key}"]
    actions   = ["*"]
  }
}

