PROGNAME =

CXXFLAGS =
CFLAGS = -Wall -pedantic ${CXXFLAGS}
LDFLAGS =

ifneq ($(strip ${DEBUG}),)
	DEBUG_CXXFLAGS =
	DEBUG_CFLAGS = -g ${DEBUG_CXXFLAGS}
endif

CC = c99

CSRC =
SSRC =

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
	$(CC) -c ${CFLAGS} ${DEBUG_CFLAGS} $<

%.o: %.s
	$(CC) -c ${DEBUG_CFLAGS} $<

${PROGNAME}: ${OBJ}
	$(CC) -o $@ $^ ${LDFLAGS}

clean:
	rm -f ${OBJ} ${PROGNAME}

.PHONY: all flags clean
