# Copyright (c) 2022 Jovami. All Rights Reserved.

CDIR = src/main/casm
CTEST = src/test/casm

TEXDIR = src/main/tex

all: c java tex

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
	cd ${TEXDIR} && $(MAKE)


check: ctest jtest

cclean:
	cd ${CDIR} && $(MAKE) clean

clean: cclean
	cd ${CTEST} && $(MAKE) clean
	./mvnw clean
	cd ${TEXDIR} && $(MAKE) clean


.PHONY: c ctest cclean asm asmtest java jtest tex package check all clean
