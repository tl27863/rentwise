const dotenv = require('dotenv')
const cors = require('cors')
const express = require('express')
const app = express();
app.use(cors());

const authRoute = require('./routes/auth');
const writeDataRoute = require('./routes/writedata');
const getDataRoute = require('./routes/getdata')
const notificationService = require('./routes/notification')

dotenv.config();

app.use(express.json());

app.use('/api/user', authRoute)
app.use('/api/request', getDataRoute)
app.use('/api/post', writeDataRoute)
app.use('/api/ns', notificationService)

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => console.log(`API Up on port ${PORT}`));