##
## EPITECH PROJECT, 2026
## Pharmalgo
## File description:
## Makefile
##

TARGET = challenge
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17
INCLUDES = -ILib_Croix -Ilibcroix/WiringPi/wiringPi
LDFLAGS = -Llibcroix/WiringPi/wiringPi -Wl,-rpath,'$$ORIGIN/libcroix/WiringPi/wiringPi'
LDLIBS = -lwiringPi

SRC = \
	main.cpp \
	Lib_Croix/CroixPharma.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(SRC) $(LDFLAGS) $(LDLIBS) -o $(TARGET)

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