const router = require('express').Router()
// const { Timestamp } = require('firebase-admin/firestore');
const {db} = require('../firebase');

router.post('/getpropertyfeed', async (req, res) => {
    const {uid} = req.body

    const getPropertyFeed = await db.collection('property').where('uid', '==', uid).get()
    const arr = []
    getPropertyFeed.forEach(getPropertyFeed => {
        var temp = []
        temp = getPropertyFeed.data()
        temp['pId'] = getPropertyFeed.id
        arr.push(temp)
      });
    if (getPropertyFeed.empty){
        res.status(200).send({message: "No Data"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/getpropertyroom', async (req, res) => {
    const {pId, uid} = req.body

    const getPropertyRoom = await db.collection('room').where('pId', '==', pId).get()

    const arr = []
    getPropertyRoom.forEach(getPropertyRoom => {
        if(uid != ""){
            if(getPropertyRoom.get('uid') == uid){
                var temp = []
                temp = getPropertyRoom.data()
                temp['rId'] = getPropertyRoom.id
                arr.push(temp)      
            }
        } else {
            var temp = []
            temp = getPropertyRoom.data()
            temp['rId'] = getPropertyRoom.id
            arr.push(temp)            
        }
      });

    if (getPropertyRoom.empty){
        res.status(200).send({message: "No Data"})
    }else{
        //console.log(arr)
        res.status(200).send(arr)
    }
});

router.post('/getpropertytenant', async (req, res) => {
    const {uid} = req.body

    var pId = ""
    var arr = []
    const getPropertyRoom = await db.collection('room').where('uid', '==', uid).get()
    getPropertyRoom.forEach(getPropertyRoom => {
        pId = getPropertyRoom.get('pId')
      });

    const getProperty = await db.collection('property').doc(pId).get()
    arr = getProperty.data()
    arr["pId"] = getProperty.id

    
    if (getPropertyRoom.empty){
        res.status(200).send({message: "No Data"})
    }else{
        //console.log(arr)
        res.status(200).send(arr)
    }
});

router.post('/gettransactiontenant', async (req, res) => {
    const {uid} = req.body

    var property = []
    var propertyName = []
    var user = []
    var username =[]
    var response =[]
    const allProperty = await db.collection('property').where('uid', '==', uid).select('name').get()
    allProperty.forEach(allProperty => {
        propertyName.push(allProperty.get('name'))
        property.push(allProperty.id)
    })

    const alltenant = await db.collection('user').where('isManager', '!=', true).select('username').get()
    alltenant.forEach(alltenant => {
        username.push(alltenant.get('username'))
        user.push(alltenant.id)
    })

    const roomTenant = await db.collection('room').where('pId', 'in', property).select('pId', 'uid', 'name').get()
    roomTenant.forEach(roomTenant => {
        if(roomTenant.get('uid') == ""){

        } else {
        var temp = []
        temp = roomTenant.data()
        temp['rId'] = roomTenant.id
        temp['propertyName'] = propertyName[property.indexOf(roomTenant.get('pId'))]
        temp['username'] = username[user.indexOf(roomTenant.get('uid'))]
        response.push(temp)
        }
    })

    res.status(200).send(response)
});

router.post('/getroom', async (req, res) => {
    const {rId} = req.body

    var arr = []
    const getRoom = await db.collection('room').doc(rId).get()
    arr = getRoom.data()
    arr["rId"] = rId
    if (!getRoom.exists){
        res.status(502).send({message: "Fetch Failed"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/getcomplaint', async (req, res) => {
    const {cId} = req.body

    var arr = []
    const getComplaint = await db.collection('complaint').doc(cId).get()
    arr = getComplaint.data()
    arr["cId"] = cId
    if (!getComplaint.exists){
        res.status(502).send({message: "Fetch Failed"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/gettransaction', async (req, res) => {
    const {tId} = req.body

    var arr = []
    const getTransaction = await db.collection('transaction').doc(tId).get()
    arr = getTransaction.data()
    arr["tId"] = tId
    if (!getTransaction.exists){
        res.status(502).send({message: "Fetch Failed"})
    }else{
        res.status(200).send(arr)
    }
});

router.get('/getcomplaintfeeduser', async (req, res) => {
    const {uid} = req.body

    const getComplaintFeed = await db.collection('complaint').where('uid', '==', uid).get()
    const arr = []
    getComplaintFeed.forEach(getComplaintFeed => {
        arr.push(getComplaintFeed.data())
      });
    if (getComplaintFeed.empty){
        res.status(200).send({message: "No Data"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/complaintfeed', async (req, res) => {
    const {uid} = req.body

    var whichId = ''
    const getUser = await db.collection('user').doc(uid).get()

    if(getUser.get('isManager') == true){
        whichId = 'uid'
    } else {
        whichId = 'sId'
    }

    const getComplaintFeed = await db.collection('complaint').where(whichId, '==', uid).get()
    const arr = []
    getComplaintFeed.forEach(getComplaintFeed => {
        var temp = []
        temp = getComplaintFeed.data()
        temp["cId"] = getComplaintFeed.id
        arr.push(temp)
      });

    res.status(200).send(arr)
});

router.post('/transactionfeed', async (req, res) => {
    const {uid} = req.body

    var whichId = ''
    const getUser = await db.collection('user').doc(uid).get()

    if(getUser.get('isManager') == true){
        whichId = 'sId'
    } else {
        whichId = 'uid'
    }

    const getTransactionFeed = await db.collection('transaction').where(whichId, '==', uid).get()

    const arr = []
    getTransactionFeed.forEach(getTransactionFeed => {
        var temp =[]
        temp = getTransactionFeed.data()
        temp['tId'] = getTransactionFeed.id
        arr.push(temp)
      });

    if (getTransactionFeed.empty){
        res.status(200).send({message: "No Data"})
    }else{
        res.status(200).send(arr)
    }
});

router.get('/getboardfeed', async (req, res) => {
    const getBoardFeed = await db.collection('board').where('brId', '==', '').get()
    const arr = []
    getBoardFeed.forEach(getBoardFeed => {
        var temp = []
        temp = getBoardFeed.data()
        temp["bId"] = getBoardFeed.id
        arr.push(temp)
      });

    //console.log(arr)
    if (getBoardFeed.empty){
        res.status(200).send({message: "No Data"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/getboarddetail', async (req, res) => {
    const {bId} = req.body

    const getBoardFeed = await db.collection('board').where('brId', '==', bId).orderBy('createdDate', 'asc').get()
    const arr = []
    getBoardFeed.forEach(getBoardFeed => {
        var temp = []
        temp = getBoardFeed.data()
        temp["bId"] = getBoardFeed.id
        arr.push(temp)
      });
    if (getBoardFeed.empty){
        res.status(200).send({message: "No Data"})
    }else{
        res.status(200).send(arr)
    }
});

router.post('/getdashboardmanager', async (req, res) => {
    const {uid} = req.body

    if(uid != ""){
        const checkUser = await db.collection('user').doc(uid).get()
        if(checkUser.get('isManager') == true){
            var property = []
            var roomAllCounter = 0
            var roomOccupiedCounter = 0
            var pAwaitingPayment = 0
            var pAwaitingConfirmation = 0
            var pPaidPayment = 0
            var cAwaitingReview = 0
            var cInProgress = 0
            var cCompleted = 0 

            const allProperty = await db.collection('property').where('uid', '==', uid).select('name').get()
            allProperty.forEach(allProperty => {
                property.push(allProperty.id)
            })

            const getRoomCounter = await db.collection('room').where('pId', 'in', property).get()
            getRoomCounter.forEach(getRoomCounter => {
                if(getRoomCounter.get('uid') != ""){
                    roomOccupiedCounter++
                }
                roomAllCounter++
            })

            const getTxs = await db.collection('transaction').where('sId', '==', uid).select('status').get()
            getTxs.forEach(getTxs => {
                if(getTxs.get('status') == 'Awaiting Payment'){
                    pAwaitingPayment++
                } else if(getTxs.get('status') == 'Awaiting Confirmation'){
                    pAwaitingConfirmation++
                } else if(getTxs.get('status') == 'Paid'){
                    pPaidPayment++
                }
            })

            const getComplaint = await db.collection('complaint').where('uid', '==', uid).select('status').get()
            getComplaint.forEach(getComplaint => {
                if(getComplaint.get('status') == 'Awaiting Review'){
                    cAwaitingReview++
                } else if(getComplaint.get('status') == 'In Progress'){
                    cInProgress++
                } else if(getComplaint.get('status') == 'Completed'){
                    cCompleted++
                }
            })

            res.status(200).send({
                roomAllCounter: roomAllCounter,
                roomOccupiedCounter: roomOccupiedCounter,
                pAwaitingPayment: pAwaitingPayment,
                pAwaitingConfirmation: pAwaitingConfirmation,
                pPaidPayment: pPaidPayment,
                cAwaitingReview: cAwaitingReview,
                cInProgress: cInProgress,
                cCompleted:cCompleted
            })            
        }
    } else {
        res.status(200).send({message: "not manager"})
    }
});

router.post('/getdashboardtenant', async (req, res) => {
    const {uid} = req.body

    var roomName = ""
    var roomPrice = ""
    var roomFloor = ""
    var pPrice = ""
    var pStatus = ""
    var cComplaintName = ""
    var cStatus = ""

    const getRoomCounter = await db.collection('room').where('uid', '==', uid).get()
    getRoomCounter.forEach(getRoomCounter => {
        roomName = getRoomCounter.get('name')
        roomPrice = getRoomCounter.get('price')
        roomFloor = getRoomCounter.get('floor')
    })

    const getTxs = await db.collection('transaction').where('uid', '==', uid).orderBy('createdDate', 'desc').limit(1).get()
    getTxs.forEach(getTxs => {
        pPrice = getTxs.get('amount')
        pStatus = getTxs.get('status')
    })

    const getComplaint = await db.collection('complaint').where('sId', '==', uid).orderBy('createdDate', 'desc').limit(1).get()
    getComplaint.forEach(getComplaint => {
        cComplaintName =  getComplaint.get('title')
        cStatus = getComplaint.get('status')
    })

    res.status(200).send({
        roomName: roomName,
        roomPrice: roomPrice,
        roomFloor: roomFloor,
        pPrice: pPrice,
        pStatus: pStatus,
        cComplaintName: cComplaintName,
        cStatus: cStatus
    })
});

module.exports = router;