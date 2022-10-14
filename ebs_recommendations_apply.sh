#!/bin/bash

function getVolumeId() {
    delimiter="volume/"
    s=$1$delimiter
    VOLUMEDETAILS=();
    while [[ $s ]];
    do
        VOLUMEDETAILS+=("${s%%"$delimiter"*}");
        s=${s#*"$delimiter"};
    done;

    VOLUMEID=${VOLUMEDETAILS[1]}
}

#VolumeArn
VOLUMEARN=$( jq -r '.volumeRecommendations[].volumeArn' < vol.json )
#VOLUMEARN="arn:aws:ec2:us-east-1:876737291315:volume/vol-00e9c6f138981857d"
getVolumeId $VOLUMEARN
echo $VOLUMEID

#Recommended Options
VOLUMETYPETYPE=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeType' < vol.json )
echo "Recommednded volumeType: ${VOLUMETYPE}"

aws ec2 modify-volume \
    --volume-type gp2 \
    --iops 100 \
    --size 8 \
    --volume-id vol-05f42a1459c99f98a