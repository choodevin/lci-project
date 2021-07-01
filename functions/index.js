const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sevenThingsScheduler = functions.region('asia-southeast1').pubsub.schedule('0 * * * *').onRun((context) => {
    var now = new Date().getHours();
    now = now + ':00';
    var previousDate = new Date();
    var today = new Date();
    previousDate.setDate(previousDate.getDate() - 1);
    var month = (previousDate.getMonth() + 1).toString().padStart(2, "0");
    var tMonth = (today.getMonth() + 1).toString().padStart(2, "0");

    today = today.getFullYear() + '-' + tMonth + '-' + today.getDate() + ' 00:00:00.000';
    previousDate = previousDate.getFullYear() + '-' + month + '-' + previousDate.getDate() + ' 00:00:00.000';

    admin.firestore().collection('CampaignData').get().then(snapshot => {
        snapshot.forEach(campaignData => {
            var totalScore = 0;
            if (campaignData['sevenThingsDeadline'] === now) {
                admin.firestore().collection('UserData').where('currentEnrolledCampaign', "==", campaignData.get('invitationCode')).get().then(
                    snapshot => {
                        snapshot.forEach(userData => {
                            var noContent = false;
                            var noContentToday = false;
                            admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(previousDate).get().then(snapshot => {
                                if (snapshot.exists) {
                                    var status = snapshot.data()['status'];
                                    status['locked'] = true;
                                    admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(previousDate).update({ "status": status });
                                    if (snapshot.data()['content'] !== null && Object.entries(snapshot.data()['content']).length > 0) {
                                        var content = Object.entries(snapshot.data()['content']);
                                        var primaryScore = 0;
                                        var secondaryScore = 0;

                                        if (status['leave'] === null || !status['leave']) {
                                            for (const [key, value] of content) {
                                                if (value['status']) {
                                                    if (value['type'] === 'Primary') {
                                                        primaryScore = primaryScore + 3;
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
                                if (noContent) {
                                    totalScore = 0;
                                }
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
                                return null;
                            }).catch(e => { console.log(e); });
                            admin.firestore().collection('UserData/' + userData.id + '/SevenThings').doc(today).get().then(snapshot => {
                                if (snapshot.exists) {
                                    if (snapshot.data()['content'] !== null && Object.entries(snapshot.data()['content']).length > 0) {
                                        var content = Object.entries(snapshot.data()['content']);
                                        if (content.length < 7) {
                                            noContentToday = true;
                                        }
                                        for (const [key, value] of content) {
                                            if (!value['status']) {
                                                noContentToday = true;
                                                break;
                                            }
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