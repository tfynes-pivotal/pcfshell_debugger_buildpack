PCFShell App Debugger edition v0.0.1-alpha
==========================================
PCFShell provides web based terminal to any browser over https.

This version of the PCFShell is packaged as both offline and online non-final (supplier) buildpacks, designed to be run as a sidecar daemon inside an exsiting "cf push'd" application container.

Use this buildpack together with a sidecar manifest on the target application to provide a secondary listener/route allowing the developer to 'hijack' a live PCF container hosted application just using a web-browser. (cf-ssh access is not required)

Demo:
Online buildpack mode
Demo app 'hello world' rest spring boot in test/ folder
Target pcf foundation - e.g. PWS
modify test/hello_manifest.yml 
  change app name from 'tmfhello' to something unique
  change 'route' to unique FQDN
modify test/deploy_with_debugger.sh
  change 'tmfhello' app name in line with new name chosen in manifest
  last line of script invokes script to open up sidecar PCF Route and port - parameters required
    addAppDebuggerRoute.sh <app-name> <debugger-hostname> <PCF-Space> <debugger-host-DNS-domain>
    e.g. addAppDebuggerRouter.sh tmfhello tmfhellodebugger tmf cfapps.io
  
  
"hello_manifest.yml" sample manifest points to online version of pcfshell_debugger_buildpack, listed first / before target app buildpack.

sidecar: element of manifest invokes the pcfshell-debugger sidecar container in live App container.

addAppDebuggerRoute.sh 
  1. exposes a second listen port for the target application-container (hardcoded to 18080)
  2. creates a PCF route for the debugger web-shell
  3. maps the debugger web-shell route to the second port (18080)

sidecar launch command "launch_debugger.sh"
  1. launches a ha-proxy facade to the sidecar web-shell to provide http basic-auth (default user/pass pcfuser/pcfpass) on port 18080
  2. launches shellinaboxd on port 18081
 
Sidecar configured application deployed using v3 api as follows: 
cf v3-create-app hello
cf v3-apply-manifest hello.yaml
cf v3-push hello -p ./hello.jar


OFFLINE BUILDPACK MODE
create_buildpack.sh creates a zipfile / offline version of the supplier buildpack for installation into a PCF foundation as a system bp. (supply script is slightly different)

run create_buildpack.sh
cf create-buildpack pcfshell_debugger_buildpack_offline pcfshell_debugger_buildpack_offline.zip 15
run test/deploy_with_debugger_offline.sh
 to deploy test app using offline/system supplier buildpack.
