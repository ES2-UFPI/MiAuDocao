const express = require('express');
const router = express.Router();
const controller = require('../controllers/favoritoController');

router.post('/', controller.post);
router.get('/:user_id/all', controller.get);

module.exports = router;