'
  {
    "key": "aws_region",
    "value": "${AWS_REGION}",
    "sensitive": "false"
  },
  {
    "key": "aws_access_key",
    "value": "$${{ secrets.AWS_ACCESS_KEY }}",
    "sensitive": "true"
  },
  {
    "key": "aws_secret_key",
    "value": "$${{ secrets.AWS_SECRET_KEY }}",
    "sensitive": "true"
  },
  {
    "key": "aws_token",
    "value": "$${{ secrets.AWS_ACCESS_TOKEN }}",
    "sensitive": "true"
  }
'