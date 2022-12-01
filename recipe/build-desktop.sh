#!/bin/bash
set -eox pipefail

PREFIX=$(echo "${PREFIX}" | tr '\\' '/')

DOTNET_ROOT="${PREFIX}/dotnet"

mkdir -p "${DOTNET_ROOT}/shared"
cp -r ./dotnet/shared/Microsoft.WindowsDesktop.App/ "${DOTNET_ROOT}/shared/Microsoft.WindowsDesktop.App/"
