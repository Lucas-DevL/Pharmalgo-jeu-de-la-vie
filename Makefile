##
## EPITECH PROJECT, 2026
## Pharmalgo
## File description:
## Makefile
##

TARGET = challenge
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17
INCLUDES = -ILib_Croix -IWiringPi/wiringPi
LDFLAGS = -LWiringPi/wiringPi -Wl,-rpath,'$$ORIGIN/WiringPi/wiringPi'
LDLIBS = -lwiringPi
WIRINGPI_LIB_VERSIONED = WiringPi/wiringPi/libwiringPi.so.3.18
WIRINGPI_LIB = WiringPi/wiringPi/libwiringPi.so

SRC = \
	main.cpp \
	Lib_Croix/CroixPharma.cpp

all: $(TARGET)

$(TARGET): $(SRC) $(WIRINGPI_LIB)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(SRC) $(LDFLAGS) $(LDLIBS) -o $(TARGET)

$(WIRINGPI_LIB): $(WIRINGPI_LIB_VERSIONED)
	ln -sf libwiringPi.so.3.18 $(WIRINGPI_LIB)

clean:
	rm -f $(TARGET)

fclean: clean

re: fclean all

test: $(TARGET)
	@echo "Starting Game of Life simulator..."
	@python3 sim.py > /tmp/sim.log 2>&1 & \
	SIM_PID=$$!; \
	sleep 1; \
	echo "Starting challenge..."; \
	./$(TARGET); \
	kill $$SIM_PID 2>/dev/null || true

.PHONY: all clean fclean re test