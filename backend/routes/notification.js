const router = require('express').Router()
const {db, ns} = require('../firebase');
const { response } = require('express');

router.post('/user', async (req, res) => {
    const {uid, title, content} = req.body
    const getFCMToken = await db.collection('user').doc(uid).get()
    
    const token = getFCMToken.get('FCMToken')
    //console.log(token)
    const notificationMessage = {
        notification: {
            title: title,
            body: content
        },
        android: {
            notification: {
                title: title,
                body: content
            }
        },
        token: token,
      };
         
    ns.send(notificationMessage)
    .then((response) => {
      console.log('Successfully sent message!', response);
      res.status(200).send({message: "success"})
    })
    .catch((error) => {
      console.log('Error sending message!', error);
      res.status(502).send({message: response})
    });
});

router.post('/all', async (req, res) => {
    const {title, content} = req.body

    const notificationMessage = {
        notification: {
            title: title,
            body: content
        },
        android: {
            notification: {
                title: title,
                body: content
            }
        },
        topic: "all",
      };

    ns.send(notificationMessage)
    .then((response) => {
    console.log('Successfully sent message!', response);
    res.status(200).send({message: "success"})
    })
    .catch((error) => {
    console.log('Error sending message!', error);
    res.status(502).send({message: response})
    });
});

module.exports = router;