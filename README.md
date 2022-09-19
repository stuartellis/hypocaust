# Hypocaust

Example project for a database-backed Web application on AWS.

## Running this project

To run this project, use *make* to run a task.

    make dbmaker:compile
    make terraform:init ENVIRONMENT=dev TF_STACK=dbmaker_lambda
    make terraform:plan ENVIRONMENT=dev TF_STACK=dbmaker_lambda
    make terraform:apply ENVIRONMENT=dev TF_STACK=dbmaker_lambda

## Developing this project

See *CONTRIBUTING.md* for how to develop this project.
