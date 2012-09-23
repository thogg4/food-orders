window.foodOrdersModel = ->
  @showOrderPage = ko.observable true
  @showListPage = ko.observable false

  @clickOrderPage = ->
    @showOrderPage true
    @showListPage false
    false

  @clickListPage = ->
    @showListPage true
    @showOrderPage false
    false



  # Orders functions
  @burgersQuantity = ko.observable 0
  @calculateBurgersPrice = =>
    2.5*@burgersQuantity()

  @friesQuantity = ko.observable 0
  @calculateFriesPrice = =>
    1*@friesQuantity()

  @drinksQuantity = ko.observable 0
  @calculateDrinksPrice = =>
    1.5*@drinksQuantity()

  @grandTotal = ko.computed ->
    accounting.formatMoney @calculateBurgersPrice() + @calculateFriesPrice() + @calculateDrinksPrice()
  , @

  @grandTotalJustNumber = ko.computed ->
    @calculateBurgersPrice() + @calculateFriesPrice() + @calculateDrinksPrice()
  , @


  # List functions
  @loadOrdersArray = =>
    $.ajax
      url: '/orders'
      dataType: 'json'
      type: 'GET'
      context: @
      success: (data) =>
        $.each data, (i, v) =>
          @ordersArray.push v
        false

    false

  @ordersArray = ko.observableArray([])






  # Saving functions
  @saveOrder = =>
    order = {burgers: @burgersQuantity(), fries: @friesQuantity(), drinks: @drinksQuantity(), total: @grandTotalJustNumber()}
    $.ajax
      url: '/order'
      data: order
      dataType: 'json'
      type: 'POST'
      success: (data) =>
        # clear quantity fields
        @burgersQuantity(0)
        @friesQuantity(0)
        @drinksQuantity(0)

        @flashMessage(data.message)
        @ordersArray.push order


  @flashMessage = (message) ->
    $('.flash').show().html(message)
    setTimeout ->
      $('.flash').fadeOut(2000)
    , 4000

  @





$ ->
  m = new foodOrdersModel()
  ko.applyBindings m
  m.loadOrdersArray()

