# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot image me <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.
#   hubot image[0-8] me <query> - Does 0 to 8 `image me`
#   hubot animate[0-8] me <query> - Does 0 to 8 `animate me`
#   hubot mustache me <url> - Adds a mustache to the specified URL.
#   hubot mustache me <query> - Searches Google Images for the specified query and mustaches it.

# Multi notes: 
#   There's a maximum of 8 because that's the max for Google Image results. Need to page if we want more.

module.exports = (robot) ->

  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /animate( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], true, (url) ->
      msg.send url

  robot.respond /(image|img)([0-9]+)( me)? (.*)/i, (msg) ->
    num = parseInt(msg.match[2])
    imageMulti msg, msg.match[4], (urls) ->
      msg.send url for url in urls.slice(0, num)

  robot.respond /animate([0-9]+)( me)? (.*)/i, (msg) ->
    num = parseInt(msg.match[1])
    imageMulti msg, msg.match[3], true, (urls) ->
      msg.send url for url in urls.slice(0, num)

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    type = Math.floor(Math.random() * 6)
    mustachify = "http://mustachify.me/#{type}?src="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe msg, imagery, false, true, (url) ->
        msg.send "#{mustachify}#{url}"

imageFetch = (msg, query, animated, faces, cb) ->
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        cb images
        
imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  imageFetch msg, query, animated, faces, (images) ->
    image = msg.random images
    cb "#{image.unescapedUrl}#.png"

imageMulti = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  imageFetch msg, query, animated, faces, (images) ->
    cb ("#{image.unescapedUrl}#.png" for image in images)
