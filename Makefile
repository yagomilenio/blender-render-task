START  ?= 1
END    ?= 10
BLEND  ?= $(shell ls *.blend 2>/dev/null | head -1)
OUTPUT ?= outputs/frames_$(START)_$(END)

.PHONY: help setup run test clean

help:
	@echo ""
	@echo "  make setup                    instala Blender"
	@echo "  make run START=1 END=50       renderiza frames 1-50"
	@echo "  make test                     prueba rápida (frames 1-3)"
	@echo "  make clean                    borra outputs"
	@echo ""

setup:
	curl "https://drive.usercontent.google.com/download?id=1L9tkite4WGG3QM8e7MvkTyhYZjHNm_aW&export=download&authuser=0&confirm=t&uuid=7fef5a01-aa7a-4364-93a3-a5333aaeec22&at=AGN2oQ1bYX9PppsVukRcczL4cQW0%3A1773345498431" --output blender-4.1-splash.blend

run:
	bash render.sh --start $(START) --end $(END) --output $(OUTPUT)

test:
	bash render.sh --start 1 --end 3 --output outputs/test

clean:
	rm -rf outputs/frames_* outputs/test
