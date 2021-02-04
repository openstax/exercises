/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// https://github.com/versal/sandbox-js

window.sandbox = function(options) {
  let src;
  if (options == null) { options = {}; }
  options = $.extend(true, {}, {
    html: '', css: '', js: '',
    external: { js: {}, css: {} },
    dialogs: true,
    onLog() {}
  }, options);

  const { js, html, css, external } = options;

  const iframe = $('<iframe seamless sandbox="allow-scripts allow-forms allow-top-navigation allow-same-origin">').appendTo(options.el || 'body')[0];
  const doc = iframe.contentDocument || iframe.contentWindow.document;

  const stopDialogs = "var dialogs = ['alert', 'prompt', 'confirm']; for (var i = 0; i < dialogs.length; i++) window[dialogs[i]] = function() {};";

  let scripts = [js];

  if (!options.dialogs) {
    scripts = [stopDialogs].concat(scripts);
  }

  const allScripts = (Array.from(scripts).map((script) => `(function() { ${script} })();`)).join('');
  const externalJS = (() => {
    const result = [];
    for (src of Array.from(external.js)) {
      result.push(`<script src='${src}'></script>`);
    }
    return result;
  })();

  const externalCSS = (() => {
    const result1 = [];
    for (src of Array.from(external.css)) {
      result1.push(`<link rel='stylesheet' type='text/css' href='${src}' media='screen' />`);
    }
    return result1;
  })();

  doc.open();
  doc.write(`\
${html}
${externalJS.join('')}
${externalCSS.join('')}
<script>${allScripts}</script>
<style>${css}</style>\
`
  );
  doc.close();

  return iframe;
};