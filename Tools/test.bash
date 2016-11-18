export TOOL="xcodebuild"
export PROJ="EonilJSON.xcodeproj"
xcrun swiftc --version
$TOOL -project      $PROJ -scheme EonilJSON-iOS -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
$TOOL test -project $PROJ -scheme EonilJSON-iOS -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
$TOOL -project      $PROJ -scheme EonilJSON-OSX -sdk macosx ONLY_ACTIVE_ARCH=NO
$TOOL test -project $PROJ -scheme EonilJSON-OSX -sdk macosx ONLY_ACTIVE_ARCH=NO
swift build
# It seems the toolchain has a bug...
#swift test
