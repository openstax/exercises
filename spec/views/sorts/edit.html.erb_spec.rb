require 'rails_helper'

RSpec.describe "sorts/edit", :type => :view do
  before(:each) do
    @sort = assign(:sort, Sort.create!(
      :container => nil,
      :sortable => nil
    ))
  end

  it "renders the edit sort form" do
    render

    assert_select "form[action=?][method=?]", sort_path(@sort), "post" do

      assert_select "input#sort_container_id[name=?]", "sort[container_id]"

      assert_select "input#sort_sortable_id[name=?]", "sort[sortable_id]"
    end
  end
end
