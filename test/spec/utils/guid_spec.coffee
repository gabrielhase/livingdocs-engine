describe 'guid util', ->

  it 'create a string', ->
    expect(typeof guid.next() == 'string').toBe(true)


  it 'creates unique ids if asked for many new ids rapidly', ->
    unique = {}
    for index in [0..100]
      if unique[id = guid.next()] then doubleEntry = true else unique[id] = id

    expect(doubleEntry).toBeUndefined()


  it 'prepends user prefix', ->
    id = guid.next('peyerluk')
    prefix = id.split('-')[0]
    expect(prefix).toEqual('peyerluk')


