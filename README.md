PCFShell app debugger

'supplier buildpack' provides the web-console to a candidate application that will in turn use a sidecar launch model to run parallel exposed route allowing for app debugging in live container.

uses sidecar manifest and 'addAppDebuggerRoute.sh' 

cf v3-create-app hello
cf v3-apply-manifest hello.yaml
cf v3-push hello -p ./hello.jar

sample app manifest

applications:
- name: hello
  path: ./hello-0.0.1-SNAPSHOT.jar
  buildpacks:
  - pcfshell_debugger
  - java_buildpack_offline
  memory: 2GB
  routes:
  - route: hello2.homelab.fynesy.com
  sidecars:
  - name: debugger
    process_types: [web]
    command: 'exec launch_debugger.sh'
    memory: 512MB
