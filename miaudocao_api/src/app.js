const express = require('express');
const app = express();
const router = express.Router();
const cors = require('cors');

const index = require('./routes/index');
const animalRoute = require('./routes/animalRoute');
const buscaRoute = require('./routes/buscaRoute');
const usuarioRoute = require('./routes/usuarioRoute');
const manifestarInteresseRoute = require('./routes/manifestarInteresseRoute');
const favoritoRoute = require('./routes/favoritoRoute');

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
app.use('/busca', buscaRoute);
app.use('/usuario', usuarioRoute);
app.use('/manifestar_interesse', manifestarInteresseRoute);
app.use('/favorito', favoritoRoute);

module.exports = app;