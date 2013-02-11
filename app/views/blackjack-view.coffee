###
  This is how you define a class in coffeescript. Internally it does what
  Backbone.View.extend does.

  You need to explicitly define your class as a property of the global window
  object, because coffeescript is always executed in an anonymous function scope 
  instead of the global scope. 
  
  You can still normally access the class as BlackjackView everywhere, though.
###
class window.BlackjackView extends Backbone.View

  events:
    "click #hit-button": "hit"
    "click #stand-button": "stand"
    "click #reset-button": "reset"
    "click #decks-button": "setup"

  ###
    In the constructor you'll want to define the variables that contain the
    state of the game. Some examples that could be useful are already in there.

    Remember, in coffeescript you use an @ instead of this.
  ###
  setup: ->
    lastCard = $("#numofDecks").val() * 52 - 1
    newDeck = []
    for num in [0..lastCard]
      switch num % 13
        when 0
          name = "A"
          value = 1
        when 10
          name = "J"
          value = 10
        when 11
          name = "Q"
          value = 10
        when 12
          name = "K"
          value = 10
        else name = value = num % 13 + 1
      switch Math.floor num / 13
        when 0 then suit = "S"
        when 1 then suit = "H"
        when 2 then suit = "D"
        else "C"
      newDeck[num] = new Card name: name, suit: suit, value: value
    @deck = new Deck newDeck
    @deck.sizeDeck lastCard
    console.log @deck
    alert "game starting"
    # this is how you call a member function
    @reset()
    
  initialize: ->
  ###
    This function is meant to reset the game state whenever a new round starts.
  
    You'll probably want to set some instance properties, render 
  ###
  reset: ->
    $("span").remove ".cards"
    @playerHand = new Hand false
    @dealerHand = new Hand true
    console.log @deck.deckIndex
    @playerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
    console.log @deck.deckIndex
    @dealerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
    console.log @deck.deckIndex
    @playerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
    console.log @deck.deckIndex
    @dealerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
    @render true, @dealerHand.getCard 0
    @render false, @playerHand.getCard 0
    @render false, @playerHand.getCard 1

  ###
    Give the player another card. If the player has 21, they lose. If they have
    21 points exactly, they win and if they have less than 21 points they can decide
    to hit or stand again.
  ###
  hit: ->
    @playerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
    @render false, @playerHand.last()
    if @playerHand.getTotal() is 21
      alert "You won.  Don't push your luck."
      if @deck.deckIndex > @deck.deckSize * 0.9
        @deck.shuffle()
      @reset()
    if @playerHand.getTotal() > 21
      alert "You bust.  Loser"
      if @deck.deckIndex > @deck.deckSize * 0.9
        @deck.shuffle()
      @reset()

  ###
    Reveal the dealer's face down card. Give the dealer cards until they have 17
    points or more. If the dealer has over 21 points or the player has more points
    than the dealer (but less than 21), the player wins. 
  ###
  stand: ->
    @dealerHand.showDealer()
    @render true, @dealerHand.getCard 1
    debugger
    while @dealerHand.getTotal() < 17
      @dealerHand.addCard @deck.get ["c" + @deck.playDeck[@deck.deckIndex++]]
      @render true, @dealerHand.last()
    if (@dealerHand.getTotal() > 21) or (@playerHand.getTotal() > @dealerHand.getTotal())
      alert "You won.  Even a blind squirrel will find a nut."
    else if @dealerHand.getTotal() > @playerHand.getTotal()
      alert "You lost.  Loser"
    else if @dealerHand.getTotal() is @playerHand.getTotal()
      alert "Push.  How boring"
    if @deck.deckIndex > @deck.deckSize * 0.9
      @deck.shuffle()
    @reset()

  render: (isDealer, card)->
    if isDealer
      $("#dealerCards").append "<span class='cards'>#{card.get 'name'}#{card.get 'suit'}</span>"
    else
      $("#playerCards").append "<span class='cards'>#{card.get 'name'}#{card.get 'suit'}</span>"
    $("#dealer-score").text @dealerHand.getTotal()
    $("#player-score").text @playerHand.getTotal()
    $(".cards").css color: "red"

