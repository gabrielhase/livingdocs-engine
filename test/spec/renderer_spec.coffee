describe 'renderer', ->

  beforeEach ->
    @tree = new SnippetTree()
    @fragment = $('<div>')
    @renderer = new Renderer(snippetTree: @tree, rootNode: @fragment)


  describe 'for a few snippets', ->

    beforeEach ->
      row = test.getSnippet('row')
      @tree.append(row)
      @title = test.getSnippet('title')
      @title.set('title', 'Singing in the Rain')
      row.append('main', @title)


    it 'renders row and title snippet', ->
      expect( $(@fragment).find(".#{ docClass.snippet }").length).toEqual(2)


    it 'inserts ui element after each container', ->
      @tree.eachContainer (container) =>
        container.ui().append($('<div>cornify!</div>'))

      # ui element for root
      expect( $(@fragment).children(':last').hasClass(docClass.interface) ).toEqual(true)

      # ui elements for row containers
      $rowContainers = $(@fragment).find("[#{ docAttr.container }]")
      expect( $rowContainers.children(".#{ docClass.interface }").length ).toEqual(2)


    it 'inserts ui element before the title snippet', ->
      @title.ui().before($('<div>cornify!</div>'))
      $title = $(@fragment).find(".#{ docClass.snippet } .#{ docClass.snippet }")
      expect($title.prev(".#{ docClass.interface }").length).toEqual(1)
      expect($title.next(".#{ docClass.interface }").length).toEqual(0)


    it 'inserts ui element after the title snippet', ->
      @title.ui().after($('<div>cornify!</div>'))
      $title = $(@fragment).find(".#{ docClass.snippet } .#{ docClass.snippet }")
      expect($title.prev(".#{ docClass.interface }").length).toEqual(0)
      expect($title.next(".#{ docClass.interface }").length).toEqual(1)

    it 'destroys ui element', ->
      @title.ui().after($('<div>cornify!</div>'))
      expect( $(@fragment).find(".#{ docClass.interface }").length ).toEqual(1)
      @title.remove()
      expect( $(@fragment).find(".#{ docClass.interface }").length ).toEqual(0)
