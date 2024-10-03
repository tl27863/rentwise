const router = require('express').Router()
const {db, ns} = require('../firebase')

router.post('/register', async (req, res) => {
    const {uid, username, email, phoneNumber, isManager, FCMToken} = req.body

    const newUser = {
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        isManager: isManager,
        FCMToken: FCMToken
    }

    ns.subscribeToTopic(FCMToken, "all")
    const setUser = await db.collection('user').doc(uid).set(newUser)
    console.log(setUser)
    res.status(200).send({message: "success"})
});

router.post('/getaccount', async (req, res) => {
    const {uid} = req.body
    const getUser = await db.collection('user').doc(uid).get()
    
    if (!getUser.exists){
        res.status(502).send({message: "Fetch Failed"})
    }else{
        var user = getUser.data()
        user['uid'] = getUser.id
        res.status(200).send(user)
    }
});

router.post('/update', async (req, res) => {
    const {uid, username, phoneNumber} = req.body

    const newUser = {
        username: username,
        phoneNumber: phoneNumber,
    }

    const setUser = await db.collection('user').doc(uid).update(newUser)
    //console.log(setUser)
    res.status(200).send({message: "success"})
});

router.post('/refreshfcm', async (req, res) => {
    const {uid, FCMToken} = req.body

    const refreshDetail = {
        FCMToken: FCMToken
    }

    ns.subscribeToTopic(FCMToken, "all")
    const refreshToken = await db.collection('user').doc(uid).update(refreshDetail)
    res.status(200).send({message: "success"})
});

router.post('/gettenant', async (req, res) => {
    const alltenant = await db.collection('user').where('isManager', '!=', true).get()
    var arr = []

    alltenant.forEach(alltenant => {
        var temp = alltenant.data()
        temp['uid'] = alltenant.id
        arr.push(temp)
      });

    //response = arr.filter(item => !del.includes(item))
    res.status(200).send(arr)
});

module.exports = router;