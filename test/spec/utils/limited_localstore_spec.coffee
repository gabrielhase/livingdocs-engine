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
    @json =
      someField: 'someVal'
      someNestedField:
        nestedContent: 'nestedVal'


  it 'saves one string item', ->
    @store.push('first')
    expect(@store.getIndex().length).toEqual(1)
    expect(@store.get()).toEqual('first')


  it 'saves a second json item', ->
    @store.push(@json)
    expect(@store.getIndex().length).toEqual(2)
    expect(@store.get()).toEqual(@json)


  it 'did not overwrite the first item', ->
    expect(@store.get(0)).toEqual('first')


  it 'saves a third json item as a variant of the second', ->
    @json.someNestedField.nestedContent = 'modifiedNestedVal'
    @store.push(@json)
    expect(@store.getIndex().length).toEqual(3)
    expect(@store.get()).toEqual(@json)


  it 'removes the third json item', ->
    expect(@store.pop()).toEqual
      someField: 'someVal'
      someNestedField:
        nestedContent: 'modifiedNestedVal'
    expect(@store.getIndex().length).toEqual(2)
    expect(@store.get()).toEqual(@json)


  it 'removes the second json item', ->
    expect(@store.pop()).toEqual(@json)
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


