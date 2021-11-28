SWIFT_BUILD_FLAGS=--configuration release

.PHONY: all build clean xcode

all: build

build:
	swift build $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build

update:
	swift package update

run:
	swift run $(SWIFT_BUILD_FLAGS)
	
test:
	swift test --configuration debug

xcode:
	swift package generate-xcodeproj

release: build
	cp .build/release/pamphlet ./bin/pamphlet

install: build
	-cp .build/release/pamphlet /opt/homebrew/bin/pamphlet
	-cp .build/release/pamphlet /usr/local/bin/pamphlet
	cp .build/release/pamphlet ./bin/pamphlet