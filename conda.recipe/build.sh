#!/bin/bash


# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
#
source activate "${CONDA_DEFAULT_ENV}"

# Source and binary
SOURCE_FILES="`ls *.cpp | tr '\r\n' ' '`"
BIN_FILE="bh_tsne"
PY_BIN_FILE="bhtsne"

# Compiler flags
export CFLAGS="${CFLAGS} -O2"
export CXXFLAGS="${CXXFLAGS} -O2"

# Compile the binary
$CXX $CXXFLAGS $SOURCE_FILES -o $BIN_FILE

# Place the binary in the prefix
mkdir -p "${PREFIX}/bin"
mv $BIN_FILE "${PREFIX}/bin"
mv "${PY_BIN_FILE}.py" "${SP_DIR}"
ln -s "${PREFIX}/bin/${BIN_FILE}" "${SP_DIR}/${BIN_FILE}"

cat >"${PREFIX}/bin/${PY_BIN_FILE}" <<EOF
#!/usr/bin/env python

import runpy
runpy.run_module("${PY_BIN_FILE}", run_name="__main__")
EOF

chmod +x "${PREFIX}/bin/${PY_BIN_FILE}"
