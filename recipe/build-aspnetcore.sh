#!/bin/bash
set -eox pipefail

PREFIX=$(echo "${PREFIX}" | tr '\\' '/')
DOTNET_ROOT="${PREFIX}/dotnet"

mkdir -p "${DOTNET_ROOT}/shared"
cp -r ./dotnet/shared/Microsoft.AspNetCore.App/ "${DOTNET_ROOT}/shared/Microsoft.AspNetCore.App/"
