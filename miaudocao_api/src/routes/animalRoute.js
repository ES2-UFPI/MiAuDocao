const express = require('express');
const router = express.Router();
const controller = require('../controllers/animalController');

router.post('/', controller.post);
router.get('/', controller.get);
router.get('/interessados/', controller.getInteressados);
router.post('/marcar_adotado', controller.marcarAdotado);

module.exports = router;