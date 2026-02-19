.PHONY: all build clean run-java3d run-javafx run-swing run-terminal

all: build

build:
	./build.sh build

clean:
	./build.sh clean

run-java3d:
	./build.sh run-java3d $(TRACK)

run-javafx:
	./build.sh run-javafx $(TRACK)

run-swing:
	./build.sh run-swing $(TRACK)

run-terminal:
	./build.sh run-terminal $(TRACK)
