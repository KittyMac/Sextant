SWIFT_BUILD_FLAGS=--configuration release

build:
	./meta/CombinedBuildPhases.sh
	swift build -v $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build

test:
	swift test -v

update:
	swift package update

xcode:
	swift package generate-xcodeproj
	meta/addBuildPhase Sextant.xcodeproj/project.pbxproj 'Sextant::Sextant' 'cd $${SRCROOT}; ./meta/CombinedBuildPhases.sh'

