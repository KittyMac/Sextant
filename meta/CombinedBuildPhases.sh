# When we regenerate the xcode project using "make xcode", we lose the run scripts buiild phases.  As we 
# rely on several scripts now, we're combining them into this one script.  This has a couple of 
# advantages:
# 1. We can run them easily from the Makefile as well as from Xcode
# 2. We only need to manually add one build phase instead of 3+
#
# cd ${SRCROOT}; ./meta/CombinedBuildPhases.sh 
#
# This script assumes that the current directory is the Server project directory

set -e

# SwiftLint - Confirms all swift code meets basic formatting standards
if which swiftlint >/dev/null; then
  swiftlint --fix --path ./Sources/
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
