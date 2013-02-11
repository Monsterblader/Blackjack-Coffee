###
  You'll probably want to define some kind of Card model.

  If you need to define a collection of cards as well, you could also put that in 
  this file if you want to.
###
class window.Card extends Backbone.Model
  initialize: ->
    name: ""
    suit: ""
    value: ""

class window.Deck extends Backbone.Collection
  model: Card
  shuffle: (newDeck) ->
    alert "Shuffling deck"
    @deckIndex = 0
    _.shuffle newDeck
  sizeDeck: (lastCard = 52) ->
    @deckSize = lastCard + 2
    deckOrder = []
    for num in [2..@deckSize]
      deckOrder[num] = num
    @playDeck = @shuffle deckOrder
  initialize: ->

class Hand
  constructor: (dealer) ->
    @cards = []
    @total = 0
    @aces = false
    @dealer = dealer
  addCard: (card) ->
    debugger
    @cards.push card
    if card.get("name") is "A"
      @aces = true
    @total += card.get "value"
  getCard: (i)->
    @cards[i]
  last: ->
    @cards[@cards.length - 1]
  showDealer: ->
    @dealer = false
  getTotal: ->
    if @dealer
      @cards[0].get "value"
    else if @aces
      @total + 10
    else
      @total