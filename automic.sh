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
insert_environment() {
  local data="$1"
  curl -X POST "$AUTOMIC_API_BASE_URL/environment" -H "Content-Type: application/json" -d "$data"
}

update_environment() {
  local id="$1"
  local data="$2"
  curl -X PUT "$AUTOMIC_API_BASE_URL/environment/$id" -H "Content-Type: application/json" -d "$data"
}

delete_environment() {
  local id="$1"
  curl -X DELETE "$AUTOMIC_API_BASE_URL/environment/$id"
}

# Main function for CRUD operations on environments and their variables
manage_environments() {
  local action="$1"

  for project in $(get_projects); do
    echo "Project: $project"

    for variable in $(yq e ".projects[] | select(.name == \"$project\") | .variables | keys[]" "$YAML_FILE"); do
      value=$(get_project_variable "$project" "$variable")
      echo "  $variable = $value"

      case "$action" in
        insert)
          # Call the Automic API to insert environment and its variables...
          insert_environment "{...}"  # Adapt this line accordingly
          ;;
        update)
          # Call the Automic API to update environment and its variables...
          update_environment "ID_HERE" "{...}"  # Adapt this line accordingly
          ;;
        delete)
          # Call the Automic API to delete environment and its variables...
          delete_environment "ID_HERE"  # Adapt this line accordingly
          ;;
      esac
    done
  done
}

# Entry point of the script
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 {insert|update|delete}"
  exit 1
fi

command="$1"

case "$command" in
  insert|update|delete)
    manage_environments "$command"
    ;;
  *)
    echo "Unknown command: $command"
    exit 1
    ;;
esac
