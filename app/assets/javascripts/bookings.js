(function (window, $, undefined) {
  var currentBookingDate = null;

  $(function() {
      var handler = StripeCheckout.configure({
        key: window.bootstrapData.stripe.key,
        token: function(token) {
          $.post(
            '/bookings.json',
            {
              stripeToken: token.id,
              booking: {
                booking_date: currentBookingDate
              }
            }
          ).done(function() {
            location.reload();
          }).fail(function(errors) {
            alert('Bookingen kunne oprettes - er datoen allerede optaget?');
          });
        },
        closed: function() {
          currentBookingDate = null;
        }
      });

    $('.bookable-date').on('click', function(e) {
      e.preventDefault();

      if (currentBookingDate) {
        return;
      }

      currentBookingDate = e.target.attributes.date.value;

      // Open Checkout with further options
      handler.open({
        amount: window.bootstrapData.stripe.amount,
        currency: "DKK",
        name: "SKRum",
        description: "Leje af fælleslokale",
        panelLabel: "Betal og book"
      });
    });

    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
    });
  });

})(window, jQuery);
