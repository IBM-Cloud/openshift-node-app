// get health of application
exports.getLoad = (req, res, next) => {
  const load = req.params.load;
  res.setHeader("Content-Type", "text/html; charset=UTF-8");
  res.writeHead(200);
  req.setTimeout(0);
  var value = 1;
  async function addDelay() {
    res.write("Sending request...\n");
    while (value < load) {
      await sleep(1000);
      //console.log("Current time in UTC:", new Date().toISOString());
      res.write("Server responded" + " at " + new Date().toISOString() + "\n");
      value++;
    }
    res.end();
  }
  addDelay();
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
