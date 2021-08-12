#!/usr/bin/env sh
set -ex
DIR=~/Downloads
MIRROR=https://github.com/adoptium

# examples
# https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u302b08.tar.gz.sha256.txt
# https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u302b08.tar.gz.sha256.txt
# https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz.sha256.txt
# https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_linux_hotspot_16.0.2_7.tar.gz.sha256.txt

dl()
{
    # 8, 11, 16
    local majorver=$1

    # 302, 0, 0
    local minorver=$2

    # N/A, 12, 2
    local patchver=$3

    # 08, 7, 7
    local bver=$4

    # jdk
    local app=$5

    # linux
    local os=$6

    # x64
    local arch=$7

    # zip or tar.gz
    local archivetype=$8

    if [ $majorver -ge 9 ]
    then
        local verstr=${majorver}.${minorver}.${patchver}_${bver}
        local lastrpath=jdk-${majorver}.${minorver}.${patchver}%2B${bver}
    else
        local verstr=${majorver}u${minorver}b${bver}
        local lastrpath=jdk${majorver}u${minorver}-b${bver}
    fi
    local file=OpenJDK${majorver}U-${app}_${arch}_${os}_hotspot_${verstr}.${archivetype}
    local rpath=temurin${majorver}-binaries/releases/download/$lastrpath
    local checksums=${file}.sha256.txt

    local rfileurl=$MIRROR/$rpath/$file
    local rchecksumsurl=$MIRROR/$rpath/$checksums
    local lchecksums=$DIR/$checksums

    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $rchecksumsurl
    fi

    printf "      # %s\n" $rfileurl
    printf "      %s_%s: sha256:%s\n" $os $arch `fgrep $file $lchecksums | awk '{print $1}'`
}

dlall() {
    # 8, 11, 12
    local majorver=$1
    # 212, 0, 12
    local minorver=$2

    # N/A, 3, 0
    local patchver=$3

    # 04, 7, 12
    local bver=$4


    if [ $majorver -ge 9 ]
    then
        printf "  '%s.%s.%s_%s':\n" $majorver $minorver $patchver $bver
    else
        printf "  '%su%sb%s':\n" $majorver $minorver $bver
    fi
    printf "    %s:\n" jdk
    dl $majorver $minorver $patchver $bver jdk linux x64 tar.gz
    dl $majorver $minorver $patchver $bver jdk linux ppc64le tar.gz
    dl $majorver $minorver $patchver $bver jdk linux s390x tar.gz
    dl $majorver $minorver $patchver $bver jdk mac x64 tar.gz
    dl $majorver $minorver $patchver $bver jdk windows x64 zip
    dl $majorver $minorver $patchver $bver jdk windows x86-32 zip

    printf "    %s:\n" jre
    dl $majorver $minorver $patchver $bver jre linux x64 tar.gz
    dl $majorver $minorver $patchver $bver jre linux ppc64le tar.gz
    dl $majorver $minorver $patchver $bver jre linux s390x tar.gz
    dl $majorver $minorver $patchver $bver jre mac x64 tar.gz
    dl $majorver $minorver $patchver $bver jre windows x64 zip
    dl $majorver $minorver $patchver $bver jre windows x86-32 zip
}

# https://adoptopenjdk.net/releases.html

dlall 8 302 'N/A' '08'
dlall 11 0 12 7
dlall 16 0 2 7
