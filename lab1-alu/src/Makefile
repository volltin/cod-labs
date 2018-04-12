CC = iverilog
TARGET = a.out
VCD_FILE = result.vcd

run: build
	./$(TARGET)

build:
	$(CC) -o $(TARGET) *.v

view: run
	open -a "GTKWave" $(VCD_FILE)

clean:
	rm -rf ./$(TARGET)
	rm -rf ./$(VCD_FILE)
