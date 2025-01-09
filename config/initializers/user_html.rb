# Modified from https://github.com/rgrove/sanitize/blob/master/README.md

EMBED_URL_REGEXES = [
  /\A(?:https?:)?\/\/(?:www\.)?youtube(?:-nocookie)?\.com\//,
  /\A(?:https?:)?\/\/(?:www\.)?khanacademy\.org\//,
  /\A(?:https?:)?\/\/(?:[\w-]+\.)?cnx\.org\//,
  /\A(?:https?:)?\/\/(?:[\w-]+\.)?openstax\.org\//,
  /\A(?:https?:)?\/\/(?:[\w-]+\.)?openstaxcollege\.org\//,
  /\A(?:https?:)?\/\/phet\.colorado\.edu\//
]

embed_transformer = ->(env) do
  node      = env[:node]
  node_name = env[:node_name]

  # Don't continue if this node is already whitelisted or is not an element.
  return if env[:is_whitelisted] || !node.element?

  # Don't continue unless the node is an iframe.
  return unless node_name == 'iframe'

  # Verify that the video URL is actually a valid whitelisted domain video URL.
  return unless EMBED_URL_REGEXES.any?{ |regex| node['src'] =~ regex }

  # We're now certain that this is a whitelisted domain embed, but we still need to run
  # it through a special Sanitize step to ensure that no unwanted elements or
  # attributes that don't belong in an embed can sneak in.
  Sanitize.node!(
    node, {
      elements: %w[iframe],

      attributes: {
        'iframe'  => %w[allowfullscreen class frameborder height mozallowfullscreen
                        scrolling src width webkitallowfullscreen]
      }
    }
  )

  # Now that we're sure that this is a valid whitelisted domain embed and that there are
  # no unwanted elements or attributes hidden inside it, we can tell Sanitize
  # to whitelist the current node.
  { node_whitelist: [node] }
end

STYLE_DATA_ATTRIBUTES = %w(bullet-style type orient valign align media)
STYLE_ATTRIBUTES = STYLE_DATA_ATTRIBUTES.map { |attr| "data-#{attr}" }

UserHtml.sanitize_config = Sanitize::Config.merge(
  Sanitize::Config::RELAXED,
  add_attributes: {
    'a' => {'rel' => 'nofollow', 'target' => '_blank'}
  },
  attributes: Sanitize::Config::RELAXED[:attributes].merge(
    # :all has to be a symbol, not a string
    all: Sanitize::Config::RELAXED[:attributes][:all] + STYLE_ATTRIBUTES,
    'span' => ['data-math'],
    'div'  => ['data-math', 'align'],
    'p'    => ['align'],
  ),
  transformers: [embed_transformer]
)
