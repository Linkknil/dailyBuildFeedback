#! /bin/bash

# com.cupcake.one.hd
# com.mobile.po

#PROJECT_DIR="/PandaHome/iphone/PoTu/PoTu"
#TARGET_NAME="PoTu"
#VERSION="1.3"
#BUILD_VERSION="15"

PROJECT_DIR=$PWD
TARGET_NAME="PoTu"
BUILD_CONFIG="DB-package"
BUNDLE_IDENTIFIER="com.froyo.three.hd"
REMOVE_BUILD_INFO=true
UPLOAD_TO_PGYER=true

# API Key
apiKey="e160ff3558a68810091f72addda62115"
# User Key
uKey="04e4186576155d9cb86de3346b78838d"

INFO_PLIST="$PROJECT_DIR/$TARGET_NAME/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "print:CFBundleShortVersionString" "$INFO_PLIST")
BUILD_VERSION_BACKUP=$(/usr/libexec/PlistBuddy -c "print:CFBundleVersion" "$INFO_PLIST")

# auto update build version
#BUILD_VERSION=$(($BUILD_VERSION+1))//modify for current date
BUILD_VERSION=$(date +%m%d%H%M)
/usr/libexec/PlistBuddy -c "Set:CFBundleVersion $BUILD_VERSION" "$INFO_PLIST"

# backup bundle identifier
#BUNDLE_IDENTIFIER_BACKUP=$(/usr/libexec/PlistBuddy -c "print:CFBundleIdentifier" "$INFO_PLIST")
# change bundle identifier
#/usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier $BUNDLE_IDENTIFIER" "$INFO_PLIST"

OUTPUT_DIR=$PROJECT_DIR"/../Documnet/dSYMs/v"$VERSION"_build"$BUILD_VERSION

#if ["0"]; then
#OUTPUT_DIR=$PROJECT_DIR"/../Documnet/dSYMs/v"$VERSION"_build""01061131"

#uploadRes=$(curl -F "file=@"$OUPUT_PATH -F "uKey=$uKey" -F "_api_key=$apiKey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload)
#uploadRes=`curl -F "file=@"$OUPUT_PATH -F "uKey=$uKey" -F "_api_key=$apiKey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload`
#反引号
#echo "-------------"
#echo $uploadRes
#echo "------test-------"
#/usr/bin/python $PROJECT_DIR"/dailyFeedback.py" $uploadRes
#fi


echo -e ' \n\n >>>>>>>>>>> Begin !!! \n\n '

cd $PROJECT_DIR
# clean
if [ $REMOVE_BUILD_INFO == 'true' ]; then
echo "clean build info"
/usr/bin/xcodebuild -target $TARGET_NAME clean
fi

# build
/usr/bin/xcodebuild -target $TARGET_NAME -configuration $BUILD_CONFIG -sdk iphoneos

# restore bundle identifier
#/usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier $BUNDLE_IDENTIFIER_BACKUP" "$INFO_PLIST"

# restore bundle buildversion
/usr/libexec/PlistBuddy -c "Set:CFBundleVersion $BUILD_VERSION_BACKUP" "$INFO_PLIST"

# package
if [ ! -d $OUTPUT_DIR ]; then
echo "create directory $OUTPUT_DIR created"
mkdir -p $OUTPUT_DIR
fi

OUPUT_PATH=$OUTPUT_DIR/$TARGET_NAME.ipa
if [ -f $OUPUT_PATH ]; then
echo "delete old package"
rm -f $OUPUT_PATH
fi

# backup dSYM
cp -r $PROJECT_DIR/build/$BUILD_CONFIG-iphoneos/$TARGET_NAME.app.dSYM $OUTPUT_DIR/$TARGET_NAME.app.dSYM

/usr/bin/xcrun -sdk iphoneos PackageApplication -v $PROJECT_DIR/build/$BUILD_CONFIG-iphoneos/$TARGET_NAME.app -o $OUPUT_PATH

if [ $REMOVE_BUILD_INFO == 'true' ]; then
echo "clean build info"
rm -rf $PROJECT_DIR/build
fi

# upload
if [ $UPLOAD_TO_PGYER == 'true' ]; then
echo "begin upload"
#uploadRes=$(curl -F "file=@"$OUPUT_PATH -F "uKey=$uKey" -F "_api_key=$apiKey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload)
uploadRes=`curl -F "file=@"$OUPUT_PATH -F "uKey=$uKey" -F "_api_key=$apiKey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload`
#反引号
echo "-------------"
echo $uploadRes
echo "-------------"
/usr/bin/python $PROJECT_DIR"/dailyFeedback.py" $uploadRes
fi

echo -e ' \n\n >>>>>>>>>>> Finish !!! \n\n '

exit 0
