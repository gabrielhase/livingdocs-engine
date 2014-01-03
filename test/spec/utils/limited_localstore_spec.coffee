describe 'Reset LimitedLocalstore', ->

  beforeEach ->
    @store = new LimitedLocalstore('test-store')
    @store.clear()


  it 'is empty at the beginning', ->
    index = @store.getIndex()
    expect(index.length).toEqual(0)


  it 'has a defautl limit of 10', ->
    expect(@store.limit).toEqual(10)


describe 'LimitedLocalstore', ->

  beforeEach ->
    @store = new LimitedLocalstore('test-store', 3)


  it 'saves one string item', ->
    @store.push('first')
    expect(@store.getIndex().length).toEqual(1)
    expect(@store.get()).toEqual('first')


  it 'saves a second json item', ->
    @store.push
      someField: 'someVal'
      someNestedField:
        nestedContent: 'nestedVal'
    expect(@store.getIndex().length).toEqual(2)
    expect(@store.get()).toEqual
      someField: 'someVal'
      someNestedField:
        nestedContent: 'nestedVal'



  # it 'saves a second item', ->
  #   @store.push('second')
  #   expect(@store.getIndex().length).toEqual(2)
  #   expect(@store.get()).toEqual('second')


  it 'removes the second json item', ->
    expect(@store.pop()).toEqual
      someField: 'someVal'
      someNestedField:
        nestedContent: 'nestedVal'
    expect(@store.getIndex().length).toEqual(1)
    expect(@store.get()).toEqual('first')


  it 'removes the first string item', ->
    expect(@store.pop()).toEqual('first')
    expect(@store.getIndex().length).toEqual(0)
    expect(@store.get()).toBeUndefined()


  it 'removes no item because the store is empty', ->
    expect(@store.getIndex().length).toEqual(0)
    expect(@store.pop()).toBeUndefined()


  it 'has a limit of 3', ->
    expect(@store.limit).toEqual(3)


  it 'does not add items above its limit', ->
    expect(@store.getIndex().length).toEqual(0)

    @store.push('first')
    @store.push('second')
    @store.push('third')
    @store.push('fourth') # 'first' should be removed at this point

    expect(@store.getIndex().length).toEqual(3)

    expect(@store.pop()).toEqual('fourth')
    expect(@store.pop()).toEqual('third')
    expect(@store.pop()).toEqual('second')

    expect(@store.getIndex().length).toEqual(0)
    expect(@store.pop()).toBeUndefined()


