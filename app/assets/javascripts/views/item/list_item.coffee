Item.Views ?= {}

class Item.Views.ListItem extends Backbone.View
  template: 'templates/item/list_item'
  className: 'item'

  constructor: ->
    super
    @model.on 'change', @render, @

  serialize: ->
    this.model.toJSON()