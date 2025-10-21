#!/bin/bash

# Function to fetch AWS credentials, supporting IMDSv2 with IMDSv1 fallback
fetch_aws_credentials_imds() {
  local metadata_base_url="http://169.254.169.254/latest"
  local token_url="$metadata_base_url/api/token"
  local metadata_url="$metadata_base_url/meta-data/iam/security-credentials/"
  local token
  local curl_headers=() # Bash array to hold curl headers

  # 1. Attempt to get an IMDSv2 token
  # We use --connect-timeout 1 to fail fast if the endpoint isn't listening
  # We redirect stderr to /dev/null to suppress connection errors if v2 isn't enabled
  token=$(curl -s -f -X PUT "$token_url" \
               -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
               --connect-timeout 1 -m 5 2>/dev/null)

  if [ -n "$token" ]; then
    echo "IMDSv2 token retrieved. Using IMDSv2." >&2
    # Set the header for subsequent IMDSv2 requests
    curl_headers=("-H" "X-aws-ec2-metadata-token: $token")
  else
    echo "Could not retrieve IMDSv2 token. Falling back to IMDSv1." >&2
    # curl_headers remains empty for IMDSv1
  fi

  # 2. Get the IAM role name
  # The "${curl_headers[@]}" syntax correctly passes the header(s) if they exist,
  # or passes nothing if the array is empty (for IMDSv1).
  local role_name
  role_name=$(curl -s -f "${curl_headers[@]}" "$metadata_url" --connect-timeout 1 -m 5)

  if [ -z "$role_name" ]; then
    echo "Error: Could not retrieve IAM role name. Is an IAM role attached to the node?" >&2
    return 1
  fi

  echo "Fetching credentials for role: $role_name" >&2

  # 3. Get the temporary credentials using the role name
  local credentials
  credentials=$(curl -s -f "${curl_headers[@]}" "$metadata_url$role_name" --connect-timeout 1 -m 5)

  if [ -z "$credentials" ]; then
    echo "Error: Could not retrieve credentials for role $role_name." >&2
    return 1
  fi

  # 4. Parse the JSON response
  # Check for jq (a proper JSON parser) first, as it's far more reliable
  local access_key_id
  local secret_access_key
  local session_token

  if command -v jq &> /dev/null; then
    # Use jq
    access_key_id=$(echo "$credentials" | jq -r .AccessKeyId)
    secret_access_key=$(echo "$credentials" | jq -r .SecretAccessKey)
    session_token=$(echo "$credentials" | jq -r .Token)
  else
    # Fallback to grep/cut (less reliable, but matches your example)
    echo "Warning: 'jq' not found. Using grep/cut for parsing, which can be fragile." >&2
    access_key_id=$(echo "$credentials" | grep "AccessKeyId" | cut -d'"' -f4)
    secret_access_key=$(echo "$credentials" | grep "SecretAccessKey" | cut -d'"' -f4)
    session_token=$(echo "$credentials" | grep "Token" | cut -d'"' -f4)
  fi

  if [ -z "$access_key_id" ] || [ -z "$secret_access_key" ] || [ -z "$session_token" ]; then
    echo "Error: Failed to parse credentials." >&2
    echo "Response was: $credentials" >&2
    return 1
  fi

  # 5. Export the credentials as environment variables
  # These will be available to subsequent commands in the script/shell
  export AWS_ACCESS_KEY_ID="$access_key_id"
  export AWS_SECRET_ACCESS_KEY="$secret_access_key"
  export AWS_SESSION_TOKEN="$session_token"

  echo "AWS credentials exported successfully." >&2
}

# --- Main execution ---
# Call the function
fetch_aws_credentials_imds

if [ -n "$AWS_ACCESS_KEY_ID" ]; then
  echo "Verification: AWS_ACCESS_KEY_ID is set."
else
  echo "Failed to retrieve and export AWS credentials."
fi