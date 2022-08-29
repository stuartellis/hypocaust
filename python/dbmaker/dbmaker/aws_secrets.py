import json

import boto3

def get(region_name, secrets_names):
    unwrapped_secrets = {}

    session = boto3.session.Session()
    client = session.client(
        service_name="secretsmanager",
        region_name=region_name,
    )

    for secret_name in secrets_names:
        response = client.get_secret_value(SecretId=secret_name)
        unwrapped_secrets[secret_name] = unwrap(response)

    return unwrapped_secrets

def unwrap(secret):
  if "SecretString" in secret:
      secret_data = secret["SecretString"]
      if secret_data[0] == "{":
          secret_data = json.loads(secret_data)
  else:
      secret_data = secret["SecretBinary"]
  return secret_data
