#pragma once

#define LENGTH(X)   (sizeof(X) / sizeof(X[0]))

__attribute__((__noreturn__, __format__(printf, 1, 2)))
void die(const char *restrict fmt, ...);
