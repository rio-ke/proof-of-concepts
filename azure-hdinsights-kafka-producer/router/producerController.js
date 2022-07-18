const express = require("express");
const router = express.Router();
const producerController = require("../controller/producerController");

router.get("/", (req, res) => {
  res.send({
    status: 200,
    method: "POST",
    route: "producerController",
  });
});
router.post("/", producerController);

module.exports = router;
