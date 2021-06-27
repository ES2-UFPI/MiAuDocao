const express = require('express');
const router = express.Router();
const controller = require('../controllers/usuarioController');

router.post('/', controller.post);
router.get('/', controller.get);
router.get('/animais/', controller.getAnimais);
router.get('/tenho_interesse/', controller.getTenhoInteresse);

module.exports = router;