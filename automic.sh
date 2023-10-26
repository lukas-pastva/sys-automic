#!/bin/bash

AUTOMIC_API_BASE_URL="https://automic-api-endpoint"
YAML_FILE="environments.yaml"

# Functions to extract data from the YAML file using yq
get_projects() {
  yq e '.projects[].name' "$YAML_FILE"
}

get_project_variable() {
  local project_name="$1"
  local variable="$2"
  yq e ".projects[] | select(.name == \"$project_name\") | .variables.$variable" "$YAML_FILE"
}

# Functions for interacting with the Automic API
check_environment_exists() {
  local project_name="$1"
  # This curl command should check if the environment exists and return an appropriate exit code
  # The exact curl command and URL will depend on the Automic API's capabilities
  curl -X GET "$AUTOMIC_API_BASE_URL/environment/$project_name" &> /dev/null
}

insert_environment() {
  local data="$1"
  curl -X POST "$AUTOMIC_API_BASE_URL/environment" -H "Content-Type: application/json" -d "$data"
}

update_environment() {
  local id="$1"
  local data="$2"
  curl -X PUT "$AUTOMIC_API_BASE_URL/environment/$id" -H "Content-Type: application/json" -d "$data"
}

# Main function to manage environments
manage_environments() {
  for project in $(get_projects); do
    echo "Project: $project"

    if check_environment_exists "$project"; then
      echo "Environment for $project exists. Updating..."
      # Build your data JSON structure for the update here
      # Then call the update_environment function
      # update_environment "ID_HERE" "{...}"  # Adapt this line accordingly
    else
      echo "Environment for $project does not exist. Inserting..."
      # Build your data JSON structure for the insert here
      # Then call the insert_environment function
      # insert_environment "{...}"  # Adapt this line accordingly
    fi
  done
}

# Entry point of the script
manage_environments
