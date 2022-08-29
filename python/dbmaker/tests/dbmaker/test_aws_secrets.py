import dbmaker.aws_secrets as aws_secrets

def test_get_secrets():
    region_name = "eu-west-2" 
    secrets_names = ["/sje/hypocaust/dev/app_config/credentials"]
    actual = aws_secrets.get(region_name, secrets_names)
    print(type(actual))
