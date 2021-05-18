const express = require('express');
const app = express();
const router = express.Router();

const index = require('./routes/index');
const animalRoute = require('./routes/animalRoute');

app.use(express.json());
app.use('/', index);
app.use('/animais', animalRoute);

module.exports = app;