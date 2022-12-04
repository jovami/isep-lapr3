# Copyright (c) 2022 Jovami. All Rights Reserved.

BDDAD = bddad/
FSIAP = fsiap/

all: dict report

dict:
	cd ${BDDAD} && $(MAKE) all tex3

report:
	cd ${FSIAP} && $(MAKE) all tex3

clean:
	cd ${BDDAD} && $(MAKE) clean
	cd ${FSIAP} && $(MAKE) clean

.PHONY: all dict clean
