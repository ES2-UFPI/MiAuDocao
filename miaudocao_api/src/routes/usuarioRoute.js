const express = require('express');
const router = express.Router();
const controller = require('../controllers/usuarioController');
const notificacaoController = require('../controllers/notificacaoController');

router.post('/', controller.post);
router.get('/', controller.get);
router.get('/animais/', controller.getAnimais);
router.get('/tenho_interesse/', controller.getTenhoInteresse);
router.get('/:id/notificacoes/', notificacaoController.get);

module.exports = router;