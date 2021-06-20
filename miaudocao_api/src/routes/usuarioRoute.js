const express = require('express');
const router = express.Router();
const controller = require('../controllers/usuarioController');

router.post('/', controller.post);
router.get('/', controller.get);
router.get('/animais/', controller.getAnimais);

module.exports = router;