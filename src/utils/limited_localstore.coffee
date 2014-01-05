# LimitedLocalstore is a wrapper around localstore that
# saves only a limited number of entries and discards
# the oldest ones after that.
#
# You should only ever create one instance by `key`.
# The limit can change between sessions,
# it will just discard all entries until the limit is met
class LimitedLocalstore

  constructor: (@key, @limit) ->
    @limit ||= 10
    @index = undefined


  compress: (obj) ->
    if typeof obj == 'object'
      str = JSON.stringify(obj)
    else
      str = obj
    LZString.compress(str)


  decompress: (obj) ->
    str = LZString.decompress(obj)
    try
      JSON.parse(str)
    catch e
      str


  push: (obj) ->
    reference =
      key: @nextKey()
      date: Date.now()

    index = @getIndex()
    while index.length + 1 > @limit
      removeRef = index[0]
      index.splice(0, 1)
      localstore.remove(removeRef.key)

    try
      localstore.set(reference.key, @compress(obj))
      # update index when entering worked
      index.push(reference)
      localstore.set("#{ @key }--index", index)
    catch e
      if index.length > 1 # leave at least one revision
        removeRef = index[0]
        index.splice(0, 1)
        localstore.remove(removeRef.key)
        return @push(obj) # try again
      else
        log 'The document is too large to be stored in localstorage'
        return false # failure

    return true # success

  pop: ->
    index = @getIndex()
    if index && index.length
      reference = index.pop()
      value = @decompress(localstore.get(reference.key))
      localstore.remove(reference.key)
      @setIndex()
      value
    else
      undefined


  get: (num) ->
    index = @getIndex()
    if index && index.length
      num ?= index.length - 1
      reference = index[num]
      value = @decompress(localstore.get(reference.key))
    else
      undefined


  clear: ->
    index = @getIndex()
    while reference = index.pop()
      localstore.remove(reference.key)

    @setIndex()


  getIndex: ->
    @index ||= localstore.get("#{ @key }--index") || []
    @index


  setIndex: ->
    if @index
      localstore.set("#{ @key }--index", @index)


  nextKey: ->
    # just a random key
    addendum = Math.floor(Math.random() * 1e16).toString(32)
    "#{ @key }-#{ addendum }"






