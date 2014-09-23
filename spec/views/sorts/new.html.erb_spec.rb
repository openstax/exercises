require 'rails_helper'

RSpec.describe "sorts/new", :type => :view do
  before(:each) do
    assign(:sort, Sort.new(
      :container => nil,
      :sortable => nil
    ))
  end

  it "renders new sort form" do
    render

    assert_select "form[action=?][method=?]", sorts_path, "post" do

      assert_select "input#sort_container_id[name=?]", "sort[container_id]"

      assert_select "input#sort_sortable_id[name=?]", "sort[sortable_id]"
    end
  end
end
