$(document).on('ready page: load', function(){  // ensures that the entire DOM is loaded before we begin selecting and setting up listeners
  $('#search-form').submit(function(event){ //Every time there is an event JQ, you receive an event callback (Don't necessarily have to use it, however)
    event.preventDefault();                   // Stops full out HTTP request... Prevents the default form submit request
    var searchValue = $('#search').val();

    $.getScript('/products?search=' + searchValue);

  });

    //////////////////////////////////////////
    // $.ajax equivalent: scripts get run automatically
    // $.ajax({
    //   url: '/products?search=' + searchValue,
    //   type: 'GET',
    //   dataType: 'script'
    // });
    //////////////////////////////////////////

    ///////////////////////////
    //SHORTHAND GET REQUEST
    // $.get('/products?search=' + searchValue)
      //.done(function(data) {
          //$('#products').html(data);
        //});



    /*We’re not going to change any of this existing code to add the endless scrolling,
    we’ll add it all through JavaScript. This way the page will fall back to the traditional
    pagination behaviour when JavaScript is disabled.*/

    $(window).scroll(function() {   //Listener for the scroll event
      var url = $('.pagination span.next').children().attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50){
      //   console.log($('.pagination span.next').children().attr('href'));    // Kimanari generates this span... need to fetch the next page of results
      //   $.getScript($('.pagination span.next').children().attr('href'));    // triggers the ProductController’s index action, passing in correct page, expects JS to be returned (index.js.erb view)
        $('.pagination').text("Fetching more products...");
        return $.getScript(url);
      }
    });
});

