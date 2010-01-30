CC = gcc
CPP = g++
COMPILER = $(CPP)

OPTFLAGS = -O2
DEBUGFLAGS = -g
WARNFLAGS = -Wall -Wno-long-long -pedantic
CFLAGS = $(OPTFLAGS) $(DEBUGFLAGS) $(WARNFLAGS)

INC =

EXE = http.exe
DIST = out/$(EXE)
OUT = -o $(DIST)

build:
	$(COMPILER) $(CFLAGS) $(INC) $(OUT) src/*.cpp

clean:
	rm $(DIST)

rebuild: clean build

test: build
	$(DIST) 80
dist: build


run: build
	$(DIST)

.PHONY: tar
tar:
	tar cvzf dist.tar.gz src/* Makefile out
