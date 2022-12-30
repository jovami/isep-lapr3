PROGNAME = tests

PFX = ../../main/casm

CXXFLAGS = -I${PFX}/include
CFLAGS = -std=gnu17 -Wall -pedantic -pipe -O2 ${CXXFLAGS}
LDFLAGS =

CC = cc

ifneq ($(strip ${DEBUG}),)
	DEBUG_CXXFLAGS =
	DEBUG_CFLAGS = -g ${DEBUG_CXXFLAGS}
endif

CFILES = $(shell find ${PFX} -type f ! -iname 'main.c' ! -ipath '*/conf/*' -iname '*.c')
SFILES = $(shell find ${PFX} -type f -iname '*.s')

CSRC = tests.c rnd_gen_test.c sensor_vec_test.c ${CFILES}
SSRC = ${SFILES}

OBJ = ${CSRC:.c=.o} ${SSRC:.s=.o}

all: flags ${PROGNAME}

tests.c: tests.h

flags:
	@echo "${PROGNAME} build options:"
	@echo "CFLAGS      =    ${CFLAGS}"
	@echo "LDFLAGS     =    ${LDFLAGS}"
	@[ -z "${DEBUG}" ] || echo "DEBUG_CFLAGS =    ${DEBUG_CFLAGS}"
	@echo "CC          =    ${CC}"

%.o: %.c
	$(CC) -c ${CFLAGS} ${DEBUG_CFLAGS} $<

%.o: %.s
	$(CC) -c ${DEBUG_CFLAGS} $<

${PROGNAME}: ${OBJ}
	$(CC) -o $@ ${notdir $^} ${LDFLAGS}

run: ${PROGNAME}
	./$<

clean:
	rm -f *.o ${PROGNAME}

.PHONY: all flags clean
