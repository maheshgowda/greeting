$.fn.greetingAutocomplete = function (options) {
  'use strict';

  // Default options
  options = options || {};
  var multiple = typeof(options.multiple) !== 'undefined' ? options.multiple : true;

  function formatGreeting(greeting) {
    return Select2.util.escapeMarkup(greeting.name);
  }

  this.select2({
    minimumInputLength: 3,
    multiple: multiple,
    initSelection: function (element, callback) {
      $.get(Spree.routes.greetings_api, {
        ids: element.val().split(','),
        token: Spree.api_key
      }, function (data) {
        callback(multiple ? data.greetings : data.greetings[0]);
      });
    },
    ajax: {
      url: Spree.routes.greetings_api,
      datatype: 'json',
      cache: true,
      data: function (term, page) {
        return {
          q: {
            name_or_master_sku_cont: term,
          },
          m: 'OR',
          token: Spree.api_key
        };
      },
      results: function (data, page) {
        var greetings = data.greetings ? data.greetings : [];
        return {
          results: greetings
        };
      }
    },
    formatResult: formatGreeting,
    formatSelection: formatGreeting
  });
};

$(document).ready(function () {
  $('.greeting_picker').greetingAutocomplete();
});
