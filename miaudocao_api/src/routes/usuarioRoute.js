const express = require('express');
const router = express.Router();
const controller = require('../controllers/usuarioController');

router.post('/', controller.post);
router.get('/:email', controller.get);

module.exports = router;