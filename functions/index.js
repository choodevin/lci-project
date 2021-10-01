const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sevenThingsScehduler = functions.region('asia-southeast1').pubsub.schedule('0 * * * *').onRun((context) => {
    var now = new Date().toLocaleString('en-us', { timeZone: 'Asia/Kuala_Lumpur', hour12: false, hour: 'numeric' });
    now = parseInt(now) + ':00';

    console.log('TIME PERIOD: ' + now);

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

    dateOne = dateOne.getFullYear() + '-' + month + '-' + day + ' 00:00:00.000';

    console.log('DATE 1: ' + dateOne);
    console.log('DATE 2: ' + dateTwo);
    console.log('DAY TODAY: ' + today);

    var campaignRef = admin.firestore().collection('CampaignData');
    var userRef = admin.firestore().collection('UserData');

    campaignRef.where(now, "==", "sevenThingDeadline").get().then(campaignSnapshot => {
        campaignSnapshot.forEach(campaignData => {
            console.log("STATUS: CAMPAIGN FOUND, DOCUMENT ID " + campaignData.id);
            userRef.where('currentEnrolledCampaign', "==", campaignData.get('invitationCode')).get().then(userSnapshot => {
                userSnapshot.forEach(userData => {
                    var currentUserRef = admin.firestore().collection('UserData/' + userData.id + '/SevenThings');
                    var campaignRankingsRef = admin.firestore().collection('CampaignData/' + campaignData.id + '/Rankings');

                    currentUserRef.doc(dateOne).get().then(sevenThingsSnapshot => { // Calculate score (DATE ONE) 
                        var totalScore = 0;
                        if (sevenThingsSnapshot.exists) {
                            var status = sevenThingsSnapshot.data()['status'];
                            var content = sevenThingsSnapshot.data()['content'];
                            var isOnLeave = status['leave'] === null || status['leave'] === undefined || !status['leave'] ? false : true;

                            status['locked'] = true; // Set status to full lock

                            currentUserRef.doc(dateOne).update({ "status": status }).catch(e => {
                                console.log("STATUS: ERROR WHILE UPDATING USER(" + userData.id + ") SEVEN THINGS'S STATUS -" + e);
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
                        }

                        if (!isOnLeave) {
                            campaignRankingsRef.doc(userData.id).get().then(snapshot => { // Will modify soon to monthly
                                if (snapshot.exists) {
                                    var tempScore = snapshot.data()['totalScore'];
                                    var days = snapshot.data()['totalDays'];
                                    totalScore = totalScore + tempScore;
                                    days = days + 1;
                                    campaignRankingsRef.doc(userData.id).set({
                                        'totalScore': totalScore,
                                        'totalDays': days,
                                    });
                                } else {
                                    campaignRankingsRef.doc(userData.id).set({
                                        'totalScore': totalScore,
                                        'totalDays': 1,
                                    });
                                }
                                return null;
                            }).catch(e => {
                                console.log("STATUS: ERROR WHILE UPDATE USER RANKINGS -" + e);
                            });
                        }
                        return null;
                    }).catch(e => {
                        console.log("STATUS: ERROR WHILE RETRIEVING " + dateOne + " USER SEVEN THINGS -" + e);
                    });

                    currentUserRef.doc(dateTwo).get().then(sevenThingsSnapshot => { // LockEdit (DATE TWO)
                        var penalty = false;
                        if (sevenThingsSnapshot.exists) {
                            var content = sevenThingsSnapshot.data()['content'];

                            if (content === null || content === undefined) {
                                penalty = true;
                            } else {
                                if (Object.entries(content).length < 7) {
                                    penalty = true;
                                }
                            }
                        } else {
                            penalty = true;
                        }

                        if (penalty) {
                            currentUserRef.doc(dateTwo).update({
                                "status": {
                                    "penalty": true,
                                }
                            });
                        }

                        currentUserRef.doc(dateTwo).update({
                            "status": {
                                "lockEdit": true,
                            }
                        });
                        return null;
                    }).catch(e => {
                        console.log("STATUS: ERROR WHILE RETRIEVING " + dateTwo + " USER SEVEN THINGS -" + e);
                    });

                    currentUserRef.doc(today).get().then(sevenThingsSnapshot => { // (TODAY)
                        if (sevenThingsSnapshot.exists) {
                            var content = sevenThingsSnapshot.data()['content'];

                            if (content !== null && content !== undefined) {
                                if (Object.entries(content).length == 7) {
                                    currentUserRef.doc(today).update({
                                        "status": {
                                            "lockEdit": true,
                                        }
                                    });
                                }
                            }
                        }
                    }).catch(e => {
                        console.log("STATUS: ERROR WHILE RETRIEVING " + today + " USER SEVEN THINGS -" + e);
                    });
                });
                return null;
            }).catch(e => {
                console.log("STATUS: ERROR WHILE RETRIEVING USER DATA -" + e);
            });
        });
        return null;
    }).catch(e => {
        console.log("STATUS: ERROR WHILE RETRIEVING CAMPAIGN DATA -" + e);
    });
    return null;
});


exports.chatPushNotification = functions.firestore.document("ChatData/content/{campaignId}/{messsageId}").onCreate((messageData, context) => {
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
});