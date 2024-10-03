const {initializeApp, cert} = require('firebase-admin/app')
const {getFirestore} = require('firebase-admin/firestore')
const {getMessaging} = require('firebase-admin/messaging')
const dotenv = require('dotenv');

dotenv.config()

const svcAccount = JSON.parse(process.env.FIREBASE_CONFIG || {})

initializeApp( {
    credential: cert(svcAccount)
})

const db = getFirestore()
const ns = getMessaging()

module.exports = {db, ns}