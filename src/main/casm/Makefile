PROGNAME = main

CXXFLAGS = -Iinclude
CFLAGS = -std=gnu17 -Wall -pedantic ${CXXFLAGS}
LDFLAGS =

ifneq ($(strip ${DEBUG}),)
	DEBUG_CXXFLAGS =
	DEBUG_CFLAGS = -g ${DEBUG_CXXFLAGS}
endif

CC = cc

CSRC = main.c \
	   util.c \
	   rnd/rnd.c \


SSRC = rnd/rnd_gen.s \



OBJ = ${CSRC:.c=.o} ${SSRC:.s=.o}


all: flags ${PROGNAME}

flags:
	@echo "${PROGNAME} build options:"
	@echo "CFLAGS      =    ${CFLAGS}"
	@echo "LDFLAGS     =    ${LDFLAGS}"
	@[ -z "${DEBUG}" ] || echo "DEBUG_CFLAGS =    ${DEBUG_CFLAGS}"
	@echo "CC          =    ${CC}"
	@echo

%.o: %.c
	$(CC) -c ${CFLAGS} ${DEBUG_CFLAGS} -o $@ $<

%.o: %.s
	$(CC) -c ${DEBUG_CFLAGS} -o $@ $<

${PROGNAME}: ${OBJ}
	$(CC) -o $@ $^ ${LDFLAGS}

clean:
	rm -f ${OBJ} ${PROGNAME}

.PHONY: all flags clean
