// import dependencies and initialize the express router
const express = require('express');
const LoadController = require('../controllers/load-controller');
const router = express.Router();

// define routes
router.get('/:load', LoadController.getLoad);


module.exports = router;
