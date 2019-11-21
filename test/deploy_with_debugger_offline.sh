#!/bin/bash
cf v3-create-app hello
cf v3-apply-manifest -f ./hello_manifest_offline.yml
cf v3-push hello -p ./hello-0.0.1-SNAPSHOT.jar
../addAppDebuggerRoute.sh hello hellodebugger DemoSpace homelab.fynesy.com
