const express = require('express');
const router = express.Router();
const controller = require('../controllers/animalController');
const controller = require('../controllers/animalController');

router.post('/', controller.post);
router.get('/', controller.get);
router.get('/interessados/', controller.getInteressados);
router.put('/marcar_adotado/', controller.marcarAdotado);
router.post('/:id/pergunta/', perguntaController.post);
router.get('/:id/pergunta/all', perguntaController.getAll);
router.get('/:id/pergunta/:id_pergunta', perguntaController.get);
router.put('/:id/pergunta/:id_pergunta/responder', perguntaController.put);

module.exports = router;