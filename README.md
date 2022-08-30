# Hypocaust

Example project.

## Running this project

To run this project, use *make* to run a task.

    make dbmaker:compile
    make tf:init ENVIRONMENT=dev TF_STACK=dbmaker_lambda
    make tf:plan ENVIRONMENT=dev TF_STACK=dbmaker_lambda
    make tf:apply ENVIRONMENT=dev TF_STACK=dbmaker_lambda

## Developing this project

See *CONTRIBUTING.md* for how to develop this project.
