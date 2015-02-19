# Description:
#   Tag messages with members the members of a team
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   @frontend - Echo message to front-end team
#   hubot list <team> - lists the members of a team
#
#

module.exports = (robot) ->

  hasRole = (user, role) ->
    if user? and user.roles?
        return true if role in user.roles
    return false
    
  findUsersInRole = (role) ->
    users = []
    for own key, user of robot.brain.data.users
        if hasRole(user, role)
            users.push(user)
    users

  robot.hear /frontend (.*)/i, (msg) ->
    users = findUsersInRole("frontend")
    msg.send "#{(user.name for user in users).join(", ")}: " + msg.match[1]
