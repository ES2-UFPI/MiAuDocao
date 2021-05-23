const express = require('express');
const app = express();
const router = express.Router();
const cors = require('cors');

const index = require('./routes/index');
const animalRoute = require('./routes/animalRoute');

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true, parameterLimit: 50000 }));
app.use(cors(
    {
        allowedHeaders: ["x-access-token", "Content-Type"],
        origin: "*",
        methods: "GET,PUT,POST,DELETE,OPTIONS",
        optionsSuccessStatus: 200
    }
)
);
app.use('/', index);
app.use('/animais', animalRoute);

module.exports = app;