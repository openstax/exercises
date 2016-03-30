require "rails_helper"

RSpec.describe UserHtml do
  it 'modifies ActiveRecord::Base' do
    expect(ActiveRecord::Base).to respond_to(:user_html)
  end

  it 'converts url\'s to html anchors with rel="nofollow" and target="_blank"' do
    content = 'Here is a cool link: http://www.example.com.'
    expect(described_class.link_and_sanitize(content)).to(
      eq 'Here is a cool link: <a href="http://www.example.com" ' +
         'rel="nofollow" target="_blank">http://www.example.com</a>.'
    )
  end

  it 'adds rel="nofollow" and target="_blank" to existing html anchors' do
    content = 'Here is a cooler link: <a href="https://www.example.com">Example</a>.'
    expect(described_class.link_and_sanitize(content)).to(
      eq 'Here is a cooler link: <a href="https://www.example.com" ' +
         'rel="nofollow" target="_blank">Example</a>.'
    )
  end

  it 'removes script tags' do
    content = 'Have a cup of <script>1337 $cr1pt</script>.'
    expect(described_class.link_and_sanitize(content)).to eq 'Have a cup of 1337 $cr1pt.'
  end

  it 'allows iframes to whitelisted domains' do
    youtube_content = '<iframe width="560" height="315" ' +
                      'src="https://www.youtube.com/embed/Xp6V_lO1ZKA" frameborder="0" ' +
                      'allowfullscreen></iframe>'
    expected_youtube_content = '<iframe width="560" height="315" ' +
                               'src="https://www.youtube.com/embed/Xp6V_lO1ZKA" frameborder="0" ' +
                               'allowfullscreen=""></iframe>'

    expect(described_class.link_and_sanitize(youtube_content)).to eq expected_youtube_content

    khan_content = \
      "<a style=\"color: #111; font-family: helvetica;\" target=\"_blank\" " +
      "href=\"https://www.khanacademy.org/video/monty-hall-problem?utm_campaign=embed\">\n" +
      "<b>The Monty Hall problem</b>: Here we have a presentation and analysis of the famous " +
      "thought experiment: the \"Monty Hall\" problem! This is fun.\n" +
      "</a><br/>\n" +
      "<iframe frameborder=\"0\" scrolling=\"no\" width=\"560\" height=\"355\" " +
      "src=\"https://www.khanacademy.org/embed_video?v=Xp6V_lO1ZKA\" allowfullscreen " +
      "webkitallowfullscreen mozallowfullscreen></iframe>"

    expected_khan_content = \
      "<a style=\"color: #111; font-family: helvetica;\" " +
      "href=\"https://www.khanacademy.org/video/monty-hall-problem?utm_campaign=embed\" " +
      "rel=\"nofollow\" target=\"_blank\">\n" +
      "<b>The Monty Hall problem</b>: Here we have a presentation and analysis of the famous " +
      "thought experiment: the \"Monty Hall\" problem! This is fun.\n" +
      "</a><br>\n" +
      "<iframe frameborder=\"0\" scrolling=\"no\" width=\"560\" height=\"355\" " +
      "src=\"https://www.khanacademy.org/embed_video?v=Xp6V_lO1ZKA\" allowfullscreen=\"\" " +
      "webkitallowfullscreen=\"\" mozallowfullscreen=\"\"></iframe>"

    expect(described_class.link_and_sanitize(khan_content)).to eq expected_khan_content
  end

  it 'removes iframes to non-whitelisted domains' do
    content = "Funny cat videos: <iframe src=\"http://mal.icio.us\">"
    expect(described_class.link_and_sanitize(content)).to eq 'Funny cat videos: '
  end
end
