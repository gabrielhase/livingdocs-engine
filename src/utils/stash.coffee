stash = do ->
  initialized = false


  init: ->
    if not initialized
      initialized = true

      # store up to ten versions
      @store = new LimitedLocalstore('stash', 10)


  snapshot: ->
    @store.push(document.toJson())


  stash: ->
    @snapshot()
    document.reset()


  clear: ->
    @store.clear()


  delete: ->
    @store.pop()


  get: ->
    @store.get()


  getAll: ->
    allEntries = []
    for i in [0..@store.getIndex().length - 1]
      allEntries.push(@store.get(i))
    allEntries


  restore: ->
    json = @store.get()

    assert json, 'stash is empty'
    document.restore(json)


  list: ->
    entries = for obj in @store.getIndex()
      { key: obj.key, date: new Date(obj.date).toString() }

    words.readableJson(entries)
