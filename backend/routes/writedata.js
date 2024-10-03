const router = require('express').Router()
const { Timestamp } = require('firebase-admin/firestore');
const {db, ns} = require('../firebase')

router.post('/setproperty', async (req, res) => {
    const {pId, uid, name, email, phoneNumber, address, photoURL} = req.body

    const property = {
        uid: uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        photoURL: photoURL,
        updatedDate: Timestamp.now()
    }

    const propertyUpdate = {
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        updatedDate: Timestamp.now()
    }

    if(pId == ""){
        const setproperty = await db.collection('property').add(property)
        res.status(200).send({id: setproperty.id})
    }else if(photoURL == ""){
        const setproperty = await db.collection('property').doc(pId).update(propertyUpdate)
        res.status(200).send({message: "success"})
    } else if(photoURL != "" && name == ""){
        const setproperty = await db.collection('property').doc(pId).update({photoURL: photoURL})
        res.status(200).send({message: "success"})
    }else {
        const setproperty = await db.collection('property').doc(pId).update(property)
        res.status(200).send({message: "success"})
    }

});

router.post('/setroom', async (req, res) => {
    const {rId, pId, uid, name, floor, price, description, photoURL} = req.body

    const room = {
        pId: pId,
        uid: uid,
        name: name,
        floor: floor,
        price: price,
        description: description,
        photoURL: photoURL,
        updatedDate: Timestamp.now()
    }

    const roomUpdate = {
        uid: uid,
        name: name,
        floor: floor,
        price: price,
        description: description,
        updatedDate: Timestamp.now()
    }

    if(rId == ""){
        const setRoom = await db.collection('room').add(room)
        res.status(200).send({id: setRoom.id})
    }else if(photoURL == ""){
        const setRoom = await db.collection('room').doc(rId).update(roomUpdate)
        res.status(200).send({message: "success"})
    } else if(photoURL != "" && name == ""){
        const setRoom = await db.collection('room').doc(rId).update({photoURL: photoURL})
        res.status(200).send({message: "success"})
    } else {
        const setRoom = await db.collection('room').doc(rId).update(room)
        res.status(200).send({message: "success"})
    }
     
});

router.post('/sendtransaction', async (req, res) => {
    const {sId, rId, uid, title, destination, amount, dueDate} = req.body

    var tDate = Date.parse(dueDate)
    var tDueDate = Timestamp.fromMillis(tDate)    
    const roomName = await db.collection('room').doc(rId).get()
    const name = await db.collection('user').doc(uid).get()

    const transaction = {
        rId: rId,
        uid: uid,
        sId: sId,
        title: title,
        destination: destination,
        amount: amount,
        dueDate: tDueDate,
        status: "Awaiting Payment",
        photoURL: "",
        name: name.get('username'),
        roomName: roomName.get('name'),
        createdDate: Timestamp.now(),
        paidDate: Timestamp.fromMillis(0),
        updatedDate: Timestamp.now()
    }

    const sendTransaction = await db.collection('transaction').add(transaction)
    await sendNS(uid, "New Transaction", "One New Transaction is Awaiting Payment")
    res.status(200).send({message: "success"})
});

router.post('/paytransaction', async (req, res) => {
    const {tId, photoURL} = req.body

    const transaction = {
        status: "Awaiting Confirmation",
        photoURL: photoURL,
        paidDate: Timestamp.now()
    }

    const sendTransaction = await db.collection('transaction').doc(tId).set(transaction, {merge: true})
    res.status(200).send({message: "success"})
});

router.post('/processtransaction', async (req, res) => {
    const {tId, status, photoURL} = req.body

    const txData = await db.collection('transaction').doc(tId).get()
    var txUid = ""
    if(photoURL == ""){
        txUid = txData.get('uid')
        const transaction = {
            status: status
        }

        const sendTransaction = await db.collection('transaction').doc(tId).update(transaction)
        await sendNS(txUid, "Transaction Update", "Your Transaction is " + status)
        res.status(200).send({message: "success"})   
    } else {
        txUid = txData.get('sId')
        const transaction = {
            status: status,
            photoURL: photoURL
        }

        const sendTransaction = await db.collection('transaction').doc(tId).update(transaction)
        await sendNS(txUid, "Transaction Update", "Your Transaction is " + status)
        res.status(200).send({message: "success"})        
    }
});

router.post('/sendcomplaint', async (req, res) => {
    const {sId, title, content, cPhotoURL} = req.body

    const roomName = await db.collection('room').where('uid', '==', sId).get()
    var pId
    var rId
    var nameroom
    roomName.forEach(roomName => {
        rId = roomName.id
        pId = roomName.get('pId')
        nameroom = roomName.get('name')
    });

    if(roomName.empty){
        res.status(502).send({message: "No Room Assigned!"})
    } else {
        const property = await db.collection('property').doc(pId).get()
        const name = await db.collection('user').doc(sId).get()

        const complaint = {
            uid: property.get('uid'),
            rId: rId,
            sId: sId,
            title: title,
            name: name.get('username'),
            roomName: nameroom,
            content: content,
            cPhotoURL: cPhotoURL,
            pPhotoURL: "",
            status: "Awaiting Review",
            createdDate: Timestamp.now()
        }

        const setComplaint = await db.collection('complaint').add(complaint)
        await sendNS(property.get('uid'), "New Complaint", "From " + name.get('username') + " with Title '" + title + "'")
        res.status(200).send({message: "success"})        
    }
});

router.post('/processcomplaint', async (req, res) => {
    const {cId, pPhotoURL, status} = req.body

    const complaint = {
        pPhotoURL: pPhotoURL,
        status: status,
    }

    const complaintDetail = await db.collection('complaint').doc(cId).get()
    const setComplaint = await db.collection('complaint').doc(cId).update(complaint)
    await sendNS(complaintDetail.get('sId'), "Complaint Update", "Complaint with title '" + complaintDetail.get('title') + "' is " + status)
    res.status(200).send({message: "success"})
});

router.post('/setboard', async (req, res) => {
    const {bId, uid, title, content, brId} = req.body
    const username = await db.collection('user').doc(uid).get()
    var name = ""
    name = username.get('username')

    if(bId == "" && brId == ""){
        const board = {
            uid: uid,
            title: title,
            content: content,
            name: name,
            brId: brId,
            createdDate: Timestamp.now(),
            updatedDate: Timestamp.now()
        }

        const setBoard = await db.collection('board').add(board)
        res.status(200).send({message: "success"})
    } else {
        const board = {
            uid: uid,
            title: title,
            content: content,
            name: name,
            brId: brId,
            createdDate: Timestamp.now(),
            updatedDate: Timestamp.now()
        }

        const boardUpdate = {
            updatedDate: Timestamp.now()
        }

        const setBoardComment = await db.collection('board').add(board)
        const setBoard = await db.collection('board').doc(brId).update(boardUpdate)
        res.status(200).send({message: "success"})
    }
});

async function sendNS(uid, title, content) {
    const getFCMToken = await db.collection('user').doc(uid).get()
    const token = getFCMToken.get('FCMToken')
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
        console.log('Successfully sent message!', response)
      })
      .catch((error) => {
        console.log('Error sending message!', error)
      });
    return uid
}

module.exports = router;