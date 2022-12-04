NAME = 2DD_G031_Fisica

LC = pdflatex
BC = biber

TEX = ${NAME}.tex

all: bib tex2


bib: tex
	@echo "Adding bibliography"
	@echo
	$(BC) ${NAME}
	@echo


tex:
	@echo "Compiling doc for the first time"
	@echo
	$(LC) -halt-on-error -file-line-error ${TEX}
	@echo


tex2:
	@echo "Compiling for the second time"
	@echo
	$(LC) -halt-on-error -file-line-error ${TEX}
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


.PHONY: all bib tex clean fullclean
