const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

async function sevenThingsSchedulerFunction() {
    var debugLogPrefix = "DEBUG LOG: ";
    var now = new Date().toLocaleString('en-us', { timeZone: 'Asia/Kuala_Lumpur', hour12: false, hour: 'numeric' });
    now = parseInt(now) + ':00';

    console.log(debugLogPrefix + 'TIME PERIOD: ' + now);

    var dateOne = new Date(); // 2 days before
    var dateTwo = new Date(); // 1 day before
    var today = new Date();

    dateOne.setDate(dateOne.getDate() - 2);
    dateTwo.setDate(dateTwo.getDate() - 1);

    var tMonth = (today.getMonth() + 1).toString().padStart(2, "0");
    var tDay = (today.getDate()).toString().padStart(2, "0");
    today = today.getFullYear() + '-' + tMonth + '-' + tDay + ' 00:00:00.000';

    var month;
    var day;

    month = (dateTwo.getMonth() + 1).toString().padStart(2, "0");
    day = (dateTwo.getDate()).toString().padStart(2, "0");

    dateTwo = dateTwo.getFullYear() + '-' + month + '-' + day + ' 00:00:00.000';

    month = (dateOne.getMonth() + 1).toString().padStart(2, "0");
    day = (dateOne.getDate()).toString().padStart(2, "0");

    var toSetRanking = month + '-' + dateOne.getFullYear();

    console.log(debugLogPrefix + 'TO SET RANKING: ' + toSetRanking);

    dateOne = dateOne.getFullYear() + '-' + month + '-' + day + ' 00:00:00.000';

    console.log(debugLogPrefix + 'DATE 1: ' + dateOne);
    console.log(debugLogPrefix + 'DATE 2: ' + dateTwo);
    console.log(debugLogPrefix + 'DAY TODAY: ' + today);

    var campaignRef = admin.firestore().collection('CampaignData');
    var userRef = admin.firestore().collection('UserData');

    campaignRef.where("sevenThingDeadline", "==", now).get().then(campaignSnapshot => {
        campaignSnapshot.forEach(campaignData => {
            var rankingsByMonthRef = admin.firestore().collection('CampaignData/' + campaignData.id + '/MonthlyRanking').doc(toSetRanking);
            rankingsByMonthRef.get().then(rankingsSnapshot => {
                var rankingsMap = rankingsSnapshot.data();
                console.log(debugLogPrefix + "STATUS: CAMPAIGN FOUND, DOCUMENT ID " + campaignData.id);
                userRef.where('currentEnrolledCampaign', "==", campaignData.get('invitationCode')).get().then(userSnapshot => {
                    console.log(debugLogPrefix + ' TOTAL USER: ' + userSnapshot.size);
                    userSnapshot.forEach(async userData => {
                        var currentUserRef = admin.firestore().collection('UserData/' + userData.id + '/SevenThings');

                        rankingsMap = await currentUserRef.doc(dateOne).get().then(sevenThingsSnapshot => { // Calculate score (DATE ONE) 
                            var totalScore = 0;
                            var isOnLeave;
                            if (sevenThingsSnapshot.exists) {
                                var status = sevenThingsSnapshot.data()['status'];
                                var content = sevenThingsSnapshot.data()['content'];
                                isOnLeave = status['leave'] === null || status['leave'] === undefined || !status['leave'] ? false : true;

                                status['locked'] = true; // Set status to full lock

                                currentUserRef.doc(dateOne).update({ "status": status }).catch(e => {
                                    console.log(debugLogPrefix + "STATUS: ERROR WHILE UPDATING USER(" + userData.id + ") SEVEN THINGS'S STATUS -" + e);
                                });

                                if (!isOnLeave) {
                                    if (content !== null && content !== undefined) {
                                        if (Object.entries(content.length > 0)) {
                                            var primaryScore = 0;
                                            var secondaryScore = 0;

                                            content = Object.entries(content);

                                            for (const [key, value] of content) {
                                                if (value['status']) {
                                                    if (value['type'] === 'Primary') {
                                                        primaryScore = primaryScore + 2;
                                                    } else if (value['type'] === 'Secondary') {
                                                        secondaryScore = secondaryScore + 1;
                                                    }
                                                }
                                            }

                                            totalScore = primaryScore + secondaryScore;
                                        }
                                    }

                                    if (status['penalty'] !== null && status['penalty']) {
                                        if (campaignData.get('sevenThingsPenalties') !== null) {
                                            var penalty = campaignData.get('sevenThingsPenalties');
                                            totalScore = totalScore * (100 - penalty) / 100;
                                        }
                                    }
                                }
                            } else {
                                currentUserRef.doc(dateOne).set({
                                    "content": {},
                                    "contentOrder": [],
                                    "status": {
                                        "penalty": true,
                                        "locked": true
                                    }
                                });
                            }

                            if (rankingsMap[userData.id] === undefined) {
                                rankingsMap[userData.id] = {
                                    'days': isOnLeave ? 0 : 1,
                                    'totalLeave': isOnLeave ? 1 : 0,
                                    'totalScore': totalScore
                                }
                            } else {
                                rankingsMap[userData.id]['days'] = isOnLeave ? rankingsMap[userData.id]['days'] : rankingsMap[userData.id]['days'] + 1;
                                rankingsMap[userData.id]['totalLeave'] = isOnLeave ? rankingsMap[userData.id]['totalLeave'] = rankingsMap[userData.id]['totalLeave'] + 1 : rankingsMap[userData.id]['totalLeave'];
                                if (!isOnLeave) {
                                    rankingsMap[userData.id]['totalScore'] = rankingsMap[userData.id]['totalScore'] + totalScore;
                                }
                            }

                            console.log('1' + rankingsMap);
                            return rankingsMap;
                        }).catch(e => {
                            console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING " + dateOne + " USER SEVEN THINGS -" + e);
                        });

                        rankingsByMonthRef.set(rankingsMap);

                        currentUserRef.doc(dateTwo).get().then(sevenThingsSnapshot => { // LockEdit (DATE TWO)
                            if (sevenThingsSnapshot.exists) {
                                var content = sevenThingsSnapshot.data()['content'];
                                var status = sevenThingsSnapshot.data()['status'];

                                if (content !== null && content !== undefined) {
                                    if (Object.entries(content).length == 7) {
                                        status['lockEdit'] = true;
                                    } else {
                                        status['penalty'] = true;
                                    }
                                } else {
                                    status['penalty'] = true;
                                }

                                currentUserRef.doc(dateTwo).update({
                                    "status": status
                                });
                            } else {
                                currentUserRef.doc(dateTwo).set({
                                    "content": {},
                                    "contentOrder": [],
                                    "status": {
                                        "lockEdit": true,
                                        "penalty": true
                                    }
                                });
                            }

                            return null;
                        }).catch(e => {
                            console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING " + dateTwo + " USER SEVEN THINGS -" + e);
                        });

                        currentUserRef.doc(today).get().then(sevenThingsSnapshot => { // (TODAY)
                            var penalty = false;
                            if (sevenThingsSnapshot.exists) {
                                var content = sevenThingsSnapshot.data()['content'];

                                if (content !== null && content !== undefined) {
                                    if (Object.entries(content).length == 7) {
                                        currentUserRef.doc(today).update({
                                            "status": {
                                                "lockEdit": true,
                                            }
                                        });
                                    } else {
                                        penalty = true;
                                    }
                                } else {
                                    penalty = true;
                                }

                                if (penalty) {
                                    currentUserRef.doc(today).update({
                                        "status": {
                                            "penalty": true,
                                        }
                                    });
                                }
                            } else {
                                currentUserRef.doc(today).set({
                                    "status": {
                                        "penalty": true
                                    }
                                });
                            }
                        }).catch(e => {
                            console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING " + today + " USER SEVEN THINGS -" + e);
                        });
                    });
                    return null;
                }).catch(e => {
                    console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING USER DATA -" + e);
                });

                return null;
            }).catch(e => {
                console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING MONTHLY RANKING " + campaignData.id + " " + toSetRanking + e);
            });
        });
        return null;
    }).catch(e => {
        console.log(debugLogPrefix + "STATUS: ERROR WHILE RETRIEVING CAMPAIGN DATA -" + e);
    });
    return null;
}

function chatPushNotificationFunction() {
    var campaignId = context.params.campaignId;
    var invitationCode;
    var senderName;
    admin.firestore().collection("CampaignData").doc(campaignId).get().then((campaignData) => {
        invitationCode = campaignData.data()['invitationCode'];
        admin.firestore().collection("UserData").doc(messageData.data()['sender']).get().then((senderData) => {
            senderName = senderData.get('name');
            admin.firestore().collection("UserData").where("currentEnrolledCampaign", "==", invitationCode).get().then((snapshot) => {
                snapshot.forEach((userData) => {
                    if (userData.id !== messageData.data()['sender']) {
                        var token = userData.data()['token'];
                        admin.messaging().send({
                            token: token,
                            data: {
                                title: campaignData.data()['name'],
                                content: senderName + ": " + messageData.data()['content'],
                                targetCampaign: campaignData.id,
                            },
                            android: {
                                priority: "high",
                            },
                        }).catch(e => { console.log(e) });
                    }
                });
                return null;
            }).catch(e => { console.log(e) });
            return null;
        }).catch(e => { console.log(e) });
        return null;
    }).catch(e => { console.log(e) });
}

function exportData() {
    admin.firestore().collection('CampaignData/PAvObgSFiHc6u4yGxTGE/MonthlyRanking/').get().then(snapshot => {
        snapshot.forEach(snapshotData => {
            console.log('start data - ' + snapshotData.id);
            console.log(JSON.stringify(snapshotData));
        });
    });
}

function monthlyRankingPatching() {
    var userRef = admin.firestore().collection('UserData').where('currentEnrolledCampaign', '==', '1kBv2');
    var parentMap = {};

    userRef.get().then(userSnapshot => {
        userSnapshot.forEach(userData => {
            var userId = userData.id;
            var sevenThingsRef = admin.firestore().collection('UserData/' + userId + '/SevenThings');
            sevenThingsRef.get().then(userSevenThingsSnapshot => {
                userSevenThingsSnapshot.forEach(sevenThingsData => {
                    var sevenThingsDate = sevenThingsData.id;
                    var sevenThingsYear = sevenThingsDate.split(' ')[0].split('-')[0];
                    var sevenThingsMonth = sevenThingsDate.split(' ')[0].split('-')[1].padStart(2, '0');
                    var sevenThingsDay = parseInt(sevenThingsDate.split(' ')[0].split('-')[2]);
                    var stopCount = sevenThingsMonth == '12' && sevenThingsDay > 2 ? true : false;
                    if (!stopCount) {
                        var toSetRanking = sevenThingsMonth + '-' + sevenThingsYear;
                        if (parentMap[toSetRanking] === undefined) {
                            parentMap[toSetRanking] = {};
                        }

                        var sevenThingsPenalty = sevenThingsData.data()['status'];
                        var isPenalty = (sevenThingsPenalty['lockEdit'] == undefined) || (sevenThingsPenalty['penalty'] != undefined && sevenThingsPenalty['penalty']) ? true : false;
                        var isLeave = sevenThingsPenalty['leave'] != undefined && sevenThingsPenalty['leave'] ? true : false;
                        var totalScore = 0;
                        var content = sevenThingsData.data()['content'];

                        if (content !== null && content !== undefined) {
                            if (Object.entries(content).length > 0) {
                                var primaryScore = 0;
                                var secondaryScore = 0;
                                content = Object.entries(content);
                                for (const [key, value] of content) {
                                    if (value['status']) {
                                        if (value['type'] === 'Primary') {
                                            primaryScore = primaryScore + 2;
                                        } else if (value['type'] === 'Secondary') {
                                            secondaryScore = secondaryScore + 1;
                                        }
                                    }
                                }
                                totalScore = primaryScore + secondaryScore;
                            } else {
                                isLeave = true;
                            }
                        } else {
                            isLeave = true;
                        }

                        if (parentMap[toSetRanking][userId] === undefined) {
                            parentMap[toSetRanking][userId] = {
                                'days': isLeave ? 0 : 1,
                                'totalLeave': isLeave ? 1 : 0,
                                'totalScore': isPenalty ? totalScore / 2 : totalScore
                            }
                        } else {
                            parentMap[toSetRanking][userId]['days'] = isLeave ? parentMap[toSetRanking][userId]['days'] : parentMap[toSetRanking][userId]['days'] + 1;
                            parentMap[toSetRanking][userId]['totalLeave'] = isLeave ? parentMap[toSetRanking][userId]['totalLeave'] = parentMap[toSetRanking][userId]['totalLeave'] + 1 : parentMap[toSetRanking][userId]['totalLeave'];
                            if (!isLeave) {
                                parentMap[toSetRanking][userId]['totalScore'] = isPenalty ? parentMap[toSetRanking][userId]['totalScore'] + (totalScore / 2) : totalScore + parentMap[toSetRanking][userId]['totalScore'];
                            }
                        }
                    }
                });

                let newList = new Map(Object.entries(parentMap));

                newList.forEach((v, k) => {
                    var rankingsByMonthRef = admin.firestore().collection('CampaignData/PAvObgSFiHc6u4yGxTGE/MonthlyRanking').doc(k);
                    rankingsByMonthRef.set(v);
                });
            }).catch(e => {
                console.log(e);
            });
        });
    }).catch(e => {
        console.log(e);
    });
}


exports.sevenThingsScheduler = functions.region('asia-southeast1').pubsub.schedule('0 * * * *').timeZone('Asia/Kuala_Lumpur').onRun(async(context) => {
    await sevenThingsSchedulerFunction();
});

exports.chatPushNotification = functions.region('asia-southeast1').firestore.document("ChatData/content/{campaignId}/{messsageId}").onCreate((messageData, context) => {
    chatPushNotificationFunction();
});