#!/usr/bin/env bash

########################################################################
# Package the binaries built on Travis-CI as an AppImage
# By Simon Peter 2016
# For more information, see http://appimage.org/
########################################################################

export ARCH=$(arch)

APP=DetectionSuite
LOWERAPP=${APP,,}


mkdir -p $APP.AppDir/usr/
wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O ./functions.sh
. ./functions.sh

cd $APP.AppDir

mkdir -p usr/bin
mv build/DatasetEvaluationApp/DatasetEvaluationApp usr/bin/DatasetEvaluationApp

mkdir -p usr/lib
ldd build/DatasetEvaluationApp/DatasetEvaluationApp | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' usr/lib/

cd usr/ ; find . -type f -exec sed -i -e 's|/usr|././|g' {} \; ; cd -

cat > AppRun << 'EOF'
#!/usr/bin/env bash
# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null
# disable parameter expansion to forward all arguments unprocessed to the VM
set -f
# run the VM and pass along all arguments as is
LD_LIBRARY_PATH="$DIR/usr/lib" "${DIR}/usr/bin/" "${DIR}/usr/bin/DatasetEvaluationApp" `zenity --file-selection --filename="$PWD"` "$@"
EOF

chmod +x AppRun

wget http://files.pharo.org/media/logo/icon-lighthouse-512x512.png -O $APP.png

cat > $APP.desktop <<EOF
[Desktop Entry]
Name=$APP
Icon=$APP
Exec=AppRun
Categories=Programming;
EOF

cd ..

wget "https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod a+x appimagetool-x86_64.AppImage

./appimagetool-x86_64.AppImage Pharo.AppDir
