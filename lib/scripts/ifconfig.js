// Description
//   A Hubot script to respond hubot's ip address
//
// Configuration:
//   None
//
// Commands:
//   hubot ifconfig - respond hubot's ip address
//
// Author:
//   bouzuya <m@bouzuya.net>
//
module.exports = function(robot) {
  return robot.respond(/ifconfig$/i, function(res) {
    return res.http('http://checkip.amazonaws.com').get()(function(err, _, body) {
      if (err != null) {
        return res.send('hubot-ifconfig: error');
      }
      return res.send(body.trim());
    });
  });
};
