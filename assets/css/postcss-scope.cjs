const selectorParser = require('postcss-selector-parser');

module.exports = (opts = {}) => {
  const atRuleName = opts.atRule || 'phx-scoped';

  return {
    postcssPlugin: 'postcss-phx-scoped',
    AtRule: {
      [atRuleName](atRule) {
        const scopeAttr = atRule.params.trim();

        if (!/^\[[^\]]+\]$/.test(scopeAttr)) {
          throw atRule.error(
            `@${atRuleName} expects a single attribute selector, e.g. [data-s-abc123]`
          );
        }

        const attrNode = selectorParser().astSync(scopeAttr).first.first;

        atRule.walkRules(rule => {
          const processor = selectorParser(root => {
            root.each(sel => {
              if (sel.type !== 'selector') return;

              findInsertPoints(sel)
                .reverse()
                .forEach(node => sel.insertAfter(node, attrNode.clone()));
            });
          });

          rule.selector = processor.processSync(rule.selector);
        });

        atRule.replaceWith(atRule.nodes);
      }
    }
  };
};

function findInsertPoints(selector) {
  const points = [];
  let lastBase = null;

  selector.each(node => {
    if (node.type === 'combinator') {
      if (lastBase) points.push(lastBase);
      lastBase = null;
    } else if (node.type === 'pseudo' && node.value.startsWith('::')) {
      if (lastBase) points.push(lastBase);
      lastBase = null;
    } else {
      lastBase = node;
    }
  });

  if (lastBase) points.push(lastBase);
  return points;
}

module.exports.postcss = true;
