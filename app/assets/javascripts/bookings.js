(function (window, $, undefined) {
  $(function() {

    $('#start_payment_button').on('click', function(e) {
      e.preventDefault();

      var handler = StripeCheckout.configure({
        key: window.bootstrapData.stripe.key,
        token: function(token) {
          $.post(
            '/bookings.json',
            {
              stripeToken: token.id,
              booking: {
                booking_date: window.bootstrapData.current_booking_date
              }
            }
          ).done(function(booking) {
            location.href = '/bookings/' + booking.id;
          }).fail(function(errors) {
            alert('Bookingen kunne ikke oprettes - er datoen allerede optaget?');
          });
        }
      });

      // Ensure that terms are accepted
      if($('#terms_accepted').is(':checked')) {
        $('#terms_not_accepted_error').addClass('hidden');
      } else {
        $('#terms_not_accepted_error').removeClass('hidden');
        return;
      }

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
