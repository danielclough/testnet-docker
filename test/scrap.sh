#!/bin/bash

A="abcd dcba"
B=A
C=${!B}
echo $C