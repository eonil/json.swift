#! /bin/bash
set -e errexit
set -o pipefail

PRODUCT=EonilJSON
IOS_DEST=id=`instruments -s devices | grep "iPhone" | grep "Simulator" | tail -1 | grep -o "\[.*\]" | tr -d "[]"`
xcodebuild -scheme $PRODUCT-iOS -destination "$IOS_DEST" -configuration Debug clean build test
xcodebuild -scheme $PRODUCT-iOS -destination "$IOS_DEST" -configuration Release clean build

xcodebuild -scheme $PRODUCT-OSX -configuration Debug clean build test
xcodebuild -scheme $PRODUCT-OSX -configuration Release clean build

