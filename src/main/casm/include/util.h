/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

#include <stddef.h>
#include <sys/types.h>

#define LENGTH(X)   (sizeof(X) / sizeof(X[0]))

ssize_t read_int(char **tmp_buf, size_t *n);

__attribute__((__noreturn__, __format__(printf, 1, 2)))
void die(const char *restrict fmt, ...);

__attribute__((__warn_unused_result__))
void *arqcp_calloc(size_t nmemb, size_t size);

__attribute__((__warn_unused_result__))
void *arqcp_malloc(size_t nmemb, size_t size);

__attribute__((__warn_unused_result__))
char *get_date(void);

__attribute__((__warn_unused_result__))
void *arqcp_realloc(void *ptr, size_t nmemb, size_t size);


ssize_t read_int(char **tmp, size_t *n);
ssize_t read_int_wrapper(void);
