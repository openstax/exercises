/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS104: Avoid inline assignments
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let base, exports;
const Ui = (function() {

  return {
    disableButton(selector) {
      $(selector).attr('disabled', 'disabled');
      $(selector).addClass('ui-state-disabled ui-button-disabled');
      return $(selector).attr('aria-disabled', true);
    },

    enableButton(selector) {
      $(selector).removeAttr('disabled');
      $(selector).removeAttr('aria-disabled');
      $(selector).removeClass('ui-state-disabled ui-button-disabled');
      return $(selector).button();
    },

    renderAndOpenDialog(html_id, content, modal_options) {
      if (modal_options == null) { modal_options = {}; }
      if ($('#' + html_id).exists()) { $('#' + html_id).remove(); }
      $("#application-body").append(content);
      $('#' + html_id).modal(modal_options);

      // Code to center the dialog
      const modalDialog = $('#' + html_id + ' .modal-dialog');
      const modalHeight = modalDialog.outerHeight();
      const userScreenHeight = window.outerHeight;

      if (modalHeight > userScreenHeight) {
        return modalDialog.css('overflow', 'auto'); //set to overflow if no fit
      } else {
        return modalDialog.css('margin-top', //center it if it does fit
                        ((userScreenHeight / 2) - (modalHeight / 2)));
      }
    },

    enableOnChecked(targetSelector, sourceSelector) {
      $(document).on('turbolinks:load', () => {
        return this.disableButton(targetSelector);
      });

      return $(sourceSelector).on('click', () => {
        if ($(sourceSelector).is(':checked')) {
          return this.enableButton(targetSelector);
        } else {
          return this.disableButton(targetSelector);
        }
      });
    },

    syntaxHighlight(code) {
      let json = typeof code === !'string' ? JSON.stringify(code, undefined, 2) : code;

      json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

      return json.replace(
        /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
        function(match) {
          let cls = 'number';
          if (/^"/.test(match)) {
            if (/:$/.test(match)) {
              cls = 'key';
            } else {
              cls = 'string';
            }
          } else if (/true|false/.test(match)) {
            cls = 'boolean';
          } else if (/null/.test(match)) {
            cls = 'null';
          }

          return '<span class="' + cls + '">' + match + '</span>';
      });
    }
  };
})();


if (((base = exports = this)).Exercises == null) { base.Exercises = {}; }
exports.Exercises.Ui = Ui;
