# Copyright (c) 2023 Jovami. All Rights Reserved.

PROGNAME = main

CXXFLAGS = -Iinclude -D_POSIX_C_SOURCE=200809L -D_DEFAULT_SOURCE -D_GNU_SOURCE -DPROGNAME=\"${PROGNAME}\"
CFLAGS = -std=gnu17 -Wall -pedantic -pipe -O2 ${CXXFLAGS}
LDFLAGS =

ifneq ($(strip ${DEBUG}),)
	DEBUG_CXXFLAGS = -D_JOVAMI_DEBUG
	DEBUG_CFLAGS = -g ${DEBUG_CXXFLAGS}
endif

CC = cc

CSRC = main.c \
	   menu.c \
	   menu_aux.c \
	   bootstrap.c \
	   conf/confparser.c \
	   util.c \
	   rnd/rnd.c \
	   sensors/sensor_impl.c \
	   sensors/sensor_vec.c \
	   sensors/gen_sens_values.c \
	   dailymatrix/dailymatrix.c \
       csv/export_dailymatrix.c \
	   csv/export_sensors.c \

SSRC = rnd/rnd_gen.s \
	   sensors/sens_dir_vento.s \
	   sensors/sens_humd_atm.s	\
	   sensors/sens_humd_solo.s \
	   sensors/sens_pluvio.s \
	   sensors/sens_temp.s \
	   sensors/sens_velc_vento.s \
	   sensors/verify_value_generated.s \

INIPARSERSH = conf/build.sh

OBJ = ${CSRC:.c=.o} ${SSRC:.s=.o} conf/libiniparser.a


all: flags lib ${PROGNAME}

flags:
	@echo "${PROGNAME} build options:"
	@echo "CFLAGS      =    ${CFLAGS}"
	@echo "LDFLAGS     =    ${LDFLAGS}"
	@[ -z "${DEBUG}" ] || echo "DEBUG_CFLAGS =    ${DEBUG_CFLAGS}"
	@echo "CC          =    ${CC}"
	@echo

lib: ${INIPARSERSH}
	chmod +x $<
	./$<

%.o: %.c
	$(CC) -c ${CFLAGS} ${DEBUG_CFLAGS} -o $@ $<

%.o: %.s
	$(CC) -c ${DEBUG_CFLAGS} -o $@ $<

${PROGNAME}: ${OBJ}
	$(CC) -o $@ $^ ${LDFLAGS}

clean:
	rm -f ${OBJ} ${PROGNAME}
	rm -f conf/dictionary.h conf/{lib,}iniparser.*

.PHONY: all flags clean
