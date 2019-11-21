#!/bin/bash
pushd ./buildpack
zip -r ../pcfshell_debugger_buildpack_offline.zip *
popd
