# Copyright (c) 2022 Jovami. All Rights Reserved.

CDIR = src/main/casm
CTEST = src/test/casm

TEXDIR = src/main/tex

all: c package tex

asm: c
asmtest: ctest

c:
	cd ${CDIR} && $(MAKE)

ctest:
	cd ${CTEST} && $(MAKE) run

java:
	./mvnw compile

jtest:
	./mvnw test

package:
	./mvnw package

tex:
# 	cd ${TEXDIR} && $(MAKE)


check: ctest jtest

clean:
	./mvnw clean
	cd ${CDIR} && $(MAKE) clean
	cd ${CTEST} && $(MAKE) clean
	cd ${TEXDIR} && $(MAKE) clean


.PHONY: c ctest asm asmtest java jtest tex package check all clean
