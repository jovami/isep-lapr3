PROGNAME = main

CXXFLAGS = -Iinclude
CFLAGS = -std=gnu17 -Wall -pedantic -pipe -O2 ${CXXFLAGS}
LDFLAGS =

ifneq ($(strip ${DEBUG}),)
	DEBUG_CXXFLAGS =
	DEBUG_CFLAGS = -g ${DEBUG_CXXFLAGS}
endif

CC = cc

CSRC = main.c \
	   util.c \
	   rnd/rnd.c \
	   sensors/gen_sens_values.c \
	   sensors/sensors_impl.c \
	   dailymatrix/dailymatrix.c \


SSRC = rnd/rnd_gen.s \
	sensors/sens_dir_vento.s \
	sensors/sens_humd_atm.s	\
	sensors/sens_humd_solo.s \
	sensors/sens_pluvio.s \
	sensors/sens_temp.s \
	sensors/sens_velc_vento.s \
	sensors/verify_value_generated.s \


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
