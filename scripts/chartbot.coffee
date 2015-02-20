# Description:
#   Chartbot gives you charts. Only a couple for now.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot chartme - show a random chart

charts = [
  "https://cloud.githubusercontent.com/assets/129330/6306202/75759978-b8ff-11e4-934d-d53ae0033663.png",
  "https://cloud.githubusercontent.com/assets/129330/6306287/443d069c-b900-11e4-998e-8c1ae6e0a621.png",
  "https://cloud.githubusercontent.com/assets/129330/6306306/63039122-b900-11e4-8d6a-58cfbb99090a.png",
  "https://cloud.githubusercontent.com/assets/129330/6306319/79193278-b900-11e4-82d0-64dca8dab7e9.png",
  "https://cloud.githubusercontent.com/assets/129330/6306325/811513ac-b900-11e4-9c2d-2ad107878ac7.png"
]

module.exports = (robot) ->

  robot.respond /chartme( *)(.*)/i, (msg) ->
    msg.send charts[Math.floor(Math.random() * charts.length)]
