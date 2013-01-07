require '/assets/chromemock.js'
require '/assets/chrome/lib.js'
require '/assets/chrome/infobar.js'

describe 'Autosave', ->
  beforeEach ->
    @deferred = jQuery.Deferred()
    spyOn(Extension.prototype, 'send').andReturn(@deferred)
    @el = $('<div/>')
    window.infobar = @infobar = new Infobar('1', @el)

  describe 'when keypair is locked', ->
    beforeEach ->
      @deferred.resolve false
      # @infobar.render()

    it 'renders unlock view', ->
      expect(@el.text()).toMatch(/Unlock/)

  describe 'when keypair is unlocked', ->
    beforeEach ->
      @deferred.resolve true
      # @infobar.render()

    it 'renders autosave view', ->
      expect(@el.text()).toMatch(/save/)
      expect(@el.text()).not.toMatch(/Unlock/)

  describe 'dismiss', ->
    it 'closes the window', ->
      spyOn(parent, 'postMessage')
      @infobar.dismiss()
      expect(window.postMessage).toHaveBeenCalled()
