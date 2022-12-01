#!/bin/bash
set -eox pipefail

PREFIX=$(echo "${PREFIX}" | tr '\\' '/')

DOTNET_ROOT="${PREFIX}/dotnet"

mkdir -p "${DOTNET_ROOT}"
cp -r ./dotnet/packs/ "${DOTNET_ROOT}/packs/"
cp -r ./dotnet/sdk/ "${DOTNET_ROOT}/sdk/"
if [[ -e ./dotnet/sdk-manifests/ ]]; then
    cp -r ./dotnet/sdk-manifests/ "${DOTNET_ROOT}/sdk-manifests/"
fi
cp -r ./dotnet/templates/ "${DOTNET_ROOT}/templates/"
