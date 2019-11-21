#!/bin/bash
cf v3_create_app hello
cf v3_apply_manifest -f ./hello_manifest.yml
cf v3_push hello -p ./hello-0.0.1-SNAPSHOT.jar
../addAppDebuggerRoute.sh hello hellodebugger DemoSpace homelab.fynesy.com
