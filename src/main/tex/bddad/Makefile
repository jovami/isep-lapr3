NAME = dictionary

LC = pdflatex
BC = biber

TEX = ${NAME}.tex

all: tex tex2

tex:
	@echo "Compiling doc for the first time"
	@echo
	${LC} -halt-on-error -file-line-error ${TEX}
	@echo


tex2:
	@echo "Compiling for the second time"
	@echo
	${LC} -halt-on-error -file-line-error ${TEX}
	@echo

tex3:
	@echo "Compiling for the third time"
	@echo
	${LC} -halt-on-error -file-line-error ${TEX}
	@echo

clean:
	rm -f ${NAME}.{aux,log,{b,i}??,out,toc,run.xml}

fullclean: clean
	rm -r ${NAME}.pdf


.PHONY: all tex tex2 tex3 clean fullclean
