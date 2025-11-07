#!/bin/bash
# ============================================================
# SYSC4001_A2_P3 - Automated build and multi-trace runner
# ------------------------------------------------------------


set -euo pipefail
shopt -s nullglob

echo "Compiling simulator..."
g++ -std=c++17 interrupts_WendingSha_JanBeyati.cpp -o interrupts
echo "Compilation successful."

VECTOR="vector_table.txt"
DEVICE="device_table.txt"
EXTERNAL="external_files.txt"

for f in "$VECTOR" "$DEVICE" "$EXTERNAL"; do
  if [[ ! -f "$f" ]]; then
    echo "Missing required file: $f"
    exit 1
  fi
done

for TRACE in trace*.txt; do
  echo "-----------------------------------------------------------"
  echo "Running $TRACE ..."
  ./interrupts "$TRACE" "$VECTOR" "$DEVICE" "$EXTERNAL"

  suffix=""
  if [[ "$TRACE" =~ ^trace([0-9]+)\.txt$ ]]; then
    suffix="${BASH_REMATCH[1]}"
  fi

  out_exec="execution${suffix}.txt"
  out_status="system_status${suffix}.txt"

  if [[ -f execution.txt ]]; then
    mv -f execution.txt "$out_exec"
    echo "   → $out_exec"
  else
    echo "  execution.txt not found!"
  fi

  if [[ -f system_status.txt ]]; then
    mv -f system_status.txt "$out_status"
    echo "   → $out_status"
  else
    echo "system_status.txt not found!"
  fi
done

echo "All traces complete."

