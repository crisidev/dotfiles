FRAMEWORK      = -framework Carbon -framework Cocoa -framework CoreServices
BUILD_FLAGS    = -std=c99 -Wall -g -O0 -fvisibility=hidden -mmacosx-version-min=11.0 -fno-objc-arc -arch x86_64 -arch arm64

all:
	xcrun clang $(BUILD_FLAGS) $(FRAMEWORK) yellowdot.c -o yellowdot
