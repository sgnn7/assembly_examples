#!/bin/bash -e

if [ $# -lt 1 ]; then
  echo "Usage $0 <project_name>"
  exit 1
fi

if [ "$(which nasm)" == "" ]; then
  echo "ERROR! You must install 'nasm' to compile these projects!"
  exit 1
fi

if [ "$(which ld)" == "" ]; then
  echo "ERROR! You must install 'ld' to compile these projects!"
  exit 1
fi

CURRENT_DIR=$(dirname $0)
PROG_NAME="$1"

echo "Assembling..."
nasm -f elf64 -o $CURRENT_DIR/$PROG_NAME.o $CURRENT_DIR/$PROG_NAME.asm

echo "Linking..."
ld -o $CURRENT_DIR/$PROG_NAME.bin $CURRENT_DIR/$PROG_NAME.o

echo "Running..."
echo "------------OUTPUT BELOW------------"

$CURRENT_DIR/$PROG_NAME.bin
