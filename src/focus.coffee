# Document Focus
# --------------
# Manage the snippet or editable that is currently focused
class Focus

  constructor: ->
    @editableNode = undefined
    @snippetElem = undefined

    @snippetFocus = $.Callbacks()
    @snippetBlur = $.Callbacks()


  setFocus: (snippetElem, editableNode) ->
    if editableNode != @editableNode
      @blurEditable()
      @editableNode = editableNode

    if snippetElem != @snippetElem
      @blurSnippet()

      @snippetElem = snippetElem
      @snippetFocus.fire(@snippetElem)


  # call after browser focus change
  editableFocused: (editableNode, snippetElem) ->
    if @editableNode != editableNode
      snippetElem ||= dom.parentSnippetElem(editableNode)
      @setFocus(snippetElem, editableNode)


  # call after browser focus change
  editableBlurred: (editableNode) ->
    if @editableNode == editableNode
      @setFocus(@snippetElem, undefined)


  # call after click
  snippetFocused: (snippetElem) ->
    if @snippetElem != snippetElem
      @setFocus(snippetElem, undefined)


  blur: ->
    @setFocus(undefined, undefined)


  # Private
  # -------

  # @api private
  blurEditable: ->
    if @editableNode
      @editableNode = undefined


  # @api private
  blurSnippet: ->
    if @snippetElem
      previous = @snippetElem
      @snippetElem = undefined
      @snippetBlur.fire(previous)


