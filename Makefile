START  ?= 1
END    ?= 10
BLEND  ?= $(shell ls *.blend 2>/dev/null | head -1)
OUTPUT ?= outputs/frames_$(START)_$(END).tar.gz

.PHONY: help setup run test clean

help:
	@echo ""
	@echo "  make setup                    instala Blender"
	@echo "  make run START=1 END=50       renderiza frames 1-50"
	@echo "  make test                     prueba rápida (frames 1-3)"
	@echo "  make clean                    borra outputs"
	@echo ""

setup:
	tar -xf blender-5.1.0-linux-x64.tar.xz

run:
	bash render.sh --start $(START) --end $(END) --output $(OUTPUT)

test:
	bash render.sh --start 1 --end 3 --output outputs/test

clean:
	rm -rf outputs
