// get health of application
exports.getLoad = (req, res) => {
    const load = req.params.load;
    req.setTimeout(0)
    //console.log(load);
    var value = 0;
    while(value < load){
        addDelay(value);
        value++;
    }
  };
  
  function addDelay(value) {
    setTimeout(function() {
        console.log("Looping count:", value);
        console.log("Current time in UTC:", new Date().toISOString());
    }, 2000 * value)
  }