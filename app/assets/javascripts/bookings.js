(function (window, $, undefined) {
  $(function() {

    $('#start_payment_button').on('click', function(e) {
      e.preventDefault();

      var token_triggered = false;

      // Ensure that terms are accepted
      if($('#terms_accepted').is(':checked')) {
        $('#terms_not_accepted_error').addClass('hidden');
      } else {
        $('#terms_not_accepted_error').removeClass('hidden');
        return;
      }

      showSpinner();

      var handler = StripeCheckout.configure({
        key: window.bootstrapData.stripe.key,
        token: function(token) {
          token_triggered = true;

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
            console.log(errors);
            hideSpinner();
            alert('Bookingen kunne ikke oprettes - er datoen allerede optaget?');
          });
        }
      });

      // Open Checkout with further options
      handler.open({
        amount: window.bootstrapData.stripe.amount,
        currency: "DKK",
        name: "SKRum",
        description: "Leje af fælleslokale",
        panelLabel: "Betal og book",
        email: window.bootstrapData.current_user.email,
        closed: function() { if(!token_triggered) { hideSpinner(); } }
      });
    });

    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
      hideSpinner();
    });

  });

  function showSpinner() {
    $('#start_payment_button').addClass('hidden');
    $('.three-quarters-loader').removeClass('hidden');
  }

  function hideSpinner() {
    $('.three-quarters-loader').addClass('hidden');
    $('#start_payment_button').removeClass('hidden');
  }

})(window, jQuery);
