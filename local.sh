#!/usr/bin/env bash

set -e

deno --version
sam --version
sam --info

sam validate --lint
rm -rf .deno_dir
DENO_DIR=.deno_dir deno cache hello.ts
cp -R .deno_dir/gen/file/"$PWD"/ .deno_dir/LAMBDA_TASK_ROOT

# sam build
sam local generate-event apigateway aws-proxy > event.json
sam local invoke --force-image-build --event event.json --container-host-interface host.docker.internal --debug HelloWorldFunction
# sam local start-api
