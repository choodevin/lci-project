const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();


exports.sevenThingsScheduler = functions.region('asia-southeast1').pubsub.schedule('0 * * * *').onRun((context) => {
    var now = new Date().toLocaleString('en-us', { timeZone: 'Asia/Kuala_Lumpur', hour12: false, hour: 'numeric' });
    now = parseInt(now) + ':00';
    console.log('TIME PERIOD: ' + now);
    var previousDate = new Date();
    var today = new Date();
    previousDate.setDate(previousDate.getDate() - 1);
    var month = (previousDate.getMonth() + 1).toString().padStart(2, "0");
    var tMonth = (today.getMonth() + 1).toString().padStart(2, "0");
    var day = (previousDate.getDate()).toString().padStart(2, "0");
    var tDay = (today.getDate()).toString().padStart(2, "0");

    today = today.getFullYear() + '-' + tMonth + '-' + tDay + ' 00:00:00.000';
    previousDate = previousDate.getFullYear() + '-' + month + '-' + day + ' 00:00:00.000';
    console.log('DAY BEFORE: ' + previousDate);
    console.log('DAY TODAY: ' + today);

    admin.firestore().collection('CampaignData').get().then(snapshot => {
        snapshot.forEach(campaignData => {
            if (campaignData.get('sevenThingDeadline') === now) {
                console.log("STATUS: CAMPAIGN MATCHED, ID: " + campaignData.id);
                admin.firestore().collection('UserData').where('currentEnrolledCampaign', "==", campaignData.get('invitationCode')).get().then(
                    snapshot => {
                        snapshot.forEach(userData => {
                            var noContent = false;
                            var noContentToday = false;
                            admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(previousDate).get().then(snapshot => {
                                var totalScore = 0;
                                if (snapshot.exists) {
                                    var status = snapshot.data()['status'];
                                    status['locked'] = true;
                                    admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(previousDate).update({ "status": status });
                                    if (snapshot.data()['content'] !== null && snapshot.data()['content'] !== undefined) {
                                        if (Object.entries(snapshot.data()['content'].length > 0)) {
                                            console.log("STATUS: USER " + userData.id + " " + previousDate + " SEVEN THINGS EXISTS");
                                            var content = Object.entries(snapshot.data()['content']);
                                            var primaryScore = 0;
                                            var secondaryScore = 0;

                                            if (status['leave'] === null || status['leave'] === undefined || !status['leave']) {
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

                                                if (status['penalty'] !== null && status['penalty']) {
                                                    if (campaignData.get('sevenThingsPenalties') !== null) {
                                                        var penalty = campaignData.get('sevenThingsPenalties');
                                                        totalScore = totalScore * (100 - penalty) / 100;
                                                    }
                                                }
                                            }
                                        } else {
                                            noContent = true;
                                        }

                                    } else {
                                        noContent = true;
                                    }
                                } else {
                                    admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(previousDate).set({ "status": { "locked": true } });
                                    noContent = true;
                                }
                                if (noContent) {
                                    totalScore = 0;
                                }
                                if (status['leave'] === null || status['leave'] === undefined || !status['leave']) {
                                    admin.firestore().collection('CampaignData/' + campaignData.id + '/Rankings').doc(userData.id).get().then(snapshot => {
                                        if (snapshot.exists) {
                                            var tempScore = snapshot.data()['totalScore'];
                                            var days = snapshot.data()['totalDays'];
                                            totalScore = totalScore + tempScore;
                                            days = days + 1;
                                            admin.firestore().collection('CampaignData/' + campaignData.id + '/Rankings').doc(userData.id).set({
                                                'totalScore': totalScore,
                                                'totalDays': days,
                                            });
                                        } else {
                                            admin.firestore().collection('CampaignData/' + campaignData.id + '/Rankings').doc(userData.id).set({
                                                'totalScore': totalScore,
                                                'totalDays': 1,
                                            });
                                        }
                                        return null;
                                    }).catch(e => { console.log(e); });
                                }
                                return null;
                            }).catch(e => { console.log(e); });
                            admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(today).get().then(snapshot => {
                                if (snapshot.exists) {
                                    if (snapshot.data()['content'] !== null && snapshot.data()['content'] !== undefined) {
                                        if (Object.entries(snapshot.data()['content']).length > 0) {
                                            var content = Object.entries(snapshot.data()['content']);
                                            if (content.length < 7) {
                                                noContentToday = true;
                                            }
                                        } else {
                                            noContentToday = true;
                                        }
                                    } else {
                                        noContentToday = true;
                                    }
                                    if (noContentToday) {
                                        admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(today).update({
                                            "status": {
                                                "penalty": true,
                                            }
                                        });
                                    } else {
                                        admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(today).update({
                                            "status": {
                                                "lockEdit": true,
                                            }
                                        });
                                    }
                                } else {
                                    admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(today).set({
                                        "content": {},
                                        "status": {
                                            "penalty": true,
                                        }
                                    });
                                }
                                return null;
                            }).catch(e => { console.log(e); });
                        });
                        return null;
                    }
                ).catch(e => { console.log(e); });
            }
        });
        return null;
    }).catch(e => { console.log(e); });
    return null;
});

exports.chatPushNotification = functions.firestore.document("ChatData/content/{campaignId}/{messsageId}").onCreate((messageData, context) => {
    var campaignId = context.params.campaignId;
    var invitationCode;
    admin.firestore().collection("CampaignData").doc(campaignId).get().then((campaignData) => {
        invitationCode = campaignData.data()['invitationCode'];

        admin.firestore().collection("UserData").where("currentEnrolledCampaign", "==", invitationCode).get().then((snapshot) => {
            snapshot.forEach((userData) => {
                if (userData.id !== messageData.data()['sender']) {
                    var token = userData.data()['token'];
                    admin.messaging().send({
                        token: token,
                        data: {
                            title: campaignData.data()['name'],
                            content: messageData.data()['content']
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
});