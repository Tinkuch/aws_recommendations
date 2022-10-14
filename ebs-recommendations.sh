#!/bin/bash

cd /tmp/jenkins/workspace/AWS_Recommendations/recommendation_apply

BRANCH=${RANDOM}

git checkout -b "${BRANCH}"

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

###Get recommendations for ec2 instances###
aws compute-optimizer get-ebs-volume-recommendations > vol.json

#VolumeArn
VOLUMEARN=$( jq -r '.volumeRecommendations[].volumeArn' < vol.json )
#VOLUMEARN="arn:aws:ec2:us-east-1:876737291315:volume/vol-00e9c6f138981857d"
getVolumeId $VOLUMEARN
echo $VOLUMEID
#AccountID
ACCOUNTID=$( jq -r '.volumeRecommendations[].accountId' < vol.json )
echo "accountId: ${ACCOUNTID}"
#Recommended Options
VOLUMETYPETYPE=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeType' < vol.json )
echo "Recommednded volumeType: ${VOLUMETYPE}"
#Recommended Options
VOLUMESIZE=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeSize' < vol.json )
echo "volumeSize: ${VOLUMESIZE}"
#Recommended Options
VOLUMEBASELINEIOPS=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeBaselineIOPS' < vol.json )        
echo "volumeBaselineIOPS: ${VOLUMEBASELINEIOPS}"
#Recommended Options
VOLUMEBURSTIOPS=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeBurstIOPS' < vol.json )
echo "volumeBurstIops: ${VOLUMEBURSTIOPS}"
#Recommended Options
VOLUMEBASELINETHROUGHPUT=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeBaselineThroughput' < vol.json )
echo "volumeBaselineThroughput: ${VOLUMEBASELINETHROUGHPUT}"
#Recommended Options
VOLUMEBURSTTHROUGHPUT=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeBurstThroughput' < vol.json )  
echo "volumeBurstThroughput: ${VOLUMEBURSTTHROUGHPUT}"
#Recommended Options
PERFORMENCERISK=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].performanceRisk' < vol.json )
echo "PerformenceRisk: ${PERFORMENCERISK}"
#Recommended Options
RANK=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].rank' < vol.json )
echo "Rank: ${RANK}"

printf "${VOLUMEID}\n${ACCOUNTID}\n${VOLUMETYPE}\n${VOLUMESIZE}" > file.log
chmod 777 file.log
chmod 777 ec2.json

git add file.log ec2.json

git commit -m "${INSATNCEID}"

git push origin "${BRANCH}":"${BRANCH}"

hub pull-request -b main -m "merge "${BRANCH}" approve merge to apply recommendation"

#hub pull-request -m "merge "${BRANCH}"approve merge to apply recommendation"
