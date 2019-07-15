#!/usr/bin/env sh
DIR=~/Downloads
MIRROR=https://github.com/AdoptOpenJDK

# examples
# https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b04/OpenJDK8U-jdk_x64_linux_hotspot_8u212b04.tar.gz.sha256.txt
# https://github.com/AdoptOpenJDK/openjdk9-binaries/releases/download/jdk-9.0.4%2B11/OpenJDK9U-jdk_x64_linux_hotspot_9.0.4_11.tar.gz.sha256.txt
# https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B12/OpenJDK12U-jre_x64_linux_hotspot_12.0.1_12.tar.gz.sha256.txt

dl()
{
    # 8, 11, 12
    MAJORVER=$1

    # 212, 0, 0
    MINORVER=$2

    # N/A, 3, 1
    PATCHVER=$3

    # 04, 7, 12
    BVER=$4

    # jdk
    APP=$5

    # linux
    OS=$6

    # x64
    ARCH=$7

    # zip or tar.gz
    ARCHIVETYPE=$8

    if [ $MAJORVER -ge 9 ]
    then
        VERSTR=${MAJORVER}.${MINORVER}.${PATCHVER}_${BVER}
        LASTRPATH=jdk-${MAJORVER}.${MINORVER}.${PATCHVER}%2B${BVER}
    else
        VERSTR=${MAJORVER}u${MINORVER}b${BVER}.${ARCHIVETYPE}
        LASTRPATH=jdk${MAJORVER}u${MINORVER}-b${BVER}
    fi
    FILE=OpenJDK${MAJORVER}U-${APP}_${ARCH}_${OS}_hotspot_${VERSTR}.${ARCHIVETYPE}
    RPATH=openjdk${MAJORVER}-binaries/releases/download/$LASTRPATH
    CHECKSUMS=${FILE}.sha256.txt

    RFILEURL=$MIRROR/$RPATH/$FILE
    RCHECKSUMSURL=$MIRROR/$RPATH/$CHECKSUMS
    LCHECKSUMS=$DIR/$CHECKSUMS

    if [ ! -e $LCHECKSUMS ];
    then
        wget -q -O $LCHECKSUMS $RCHECKSUMSURL
    fi

    printf "      # %s\n" $RFILEURL
    printf "      %s_%s: sha256:%s\n" $OS $ARCH `fgrep $FILE $LCHECKSUMS | awk '{print $1}'`
}

dlall() {
    # 8, 11, 12
    MAJORVER=$1
    # 212, 0, 12
    MINORVER=$2

    # N/A, 3, 0
    PATCHVER=$3

    # 04, 7, 12
    BVER=$4


    if [ $MAJORVER -ge 9 ]
    then
        printf "  '%s.%s.%sB%s':\n" $MAJORVER $MINORVER $PATCHVER $BVER
    else
        printf "  '%su%s_%s':\n" $MAJORVER $MINORVER $BVER
    fi
    printf "    %s:\n" jdk
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk linux x64 tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk linux ppc64le tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk linux s390x tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk mac x64 tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk windows x64 zip
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk windows x86-32 zip
    dl $MAJORVER $MINORVER $PATCHVER $BVER jdk aix ppc64 tar.gz

    printf "    %s:\n" jre
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre linux x64 tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre linux ppc64le tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre linux s390x tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre mac x64 tar.gz
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre windows x64 zip
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre windows x86-32 zip
    dl $MAJORVER $MINORVER $PATCHVER $BVER jre aix ppc64 tar.gz
}

dlall 8 212 'N/A' '04'
dlall 11 0 3 7
dlall 12 0 1 12

