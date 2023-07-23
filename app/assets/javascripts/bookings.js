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

      var elForm = $('#booking_form')

      $.post(
        elForm.attr('action'),
        elForm.serialize()
      ).done(function(result) {
        var stripe = Stripe(window.bootstrapData.stripe.key);
        stripe.redirectToCheckout({
          // Make the id field from the Checkout Session creation API response
          // available to this file, so you can provide it as parameter here
          // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
          sessionId: result.stripe_session_id
        }).then(function (result) {
          // If `redirectToCheckout` fails due to a browser or network
          // error, display the localized error message to your customer
          // using `result.error.message`.
          console.log(result.error.message);
          hideSpinner();
          alert('Bookingen kunne ikke oprettes - der skete en uventet fejl.');
          });
      }).fail(function(errors) {
        console.log(errors);
        hideSpinner();
        alert('Bookingen kunne ikke oprettes - er datoen allerede optaget?');
      });
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
