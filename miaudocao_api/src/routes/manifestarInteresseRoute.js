const express = require('express');
const router = express.Router();
const controller = require('../controllers/manifestarInteresseController');

router.post('/', controller.post);

module.exports = router;