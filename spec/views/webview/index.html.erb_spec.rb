require 'rails_helper'

RSpec.describe "webview/index", :type => :view do
  it "renders the webview" do
    @path = '/my/path'
    @name = 'My Name'

    render

    expect(rendered).to include("<script type='text/javascript' defer>var path = '#{@path}', name = '#{@name}'")#;</script>")
    expect(rendered).to include("<script type='text/javascript' src='http://localhost:8001/dist/exercises.js' defer></script>")
    expect(rendered).to include("<link rel='stylesheet' href='http://localhost:8001/dist/exercises.css' />")
  end
end
