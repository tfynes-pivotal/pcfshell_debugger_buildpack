#!/bin/bash
cf v3-create-app tmfhello
cf v3-apply-manifest -f ./hello_manifest.yml
cf v3-push tmfhello -p ./hello-0.0.1-SNAPSHOT.jar
../addAppDebuggerRoute.sh tmfhello tmfhellodebugger tmf cfapps.io
