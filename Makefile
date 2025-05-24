SOURCES := $(wildcard *.v)
OUTPUT  := a.out

all: $(OUTPUT)

$(OUTPUT): $(SOURCES)
	iverilog -o $(OUTPUT) $(SOURCES)

clean:
	rm -f $(OUTPUT)
