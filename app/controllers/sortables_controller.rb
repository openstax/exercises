class SortablesController < ApplicationController
  before_filter :get_sortables

  # POST /sortables/sort
  def sort
    @sortable_classes.each_with_index {|c, i| c.sort(@sorted_ids[i])}

    respond_to do |format|
      format.js
    end
  end

  protected

  def get_sortables
    @sortable_classes = []
    @sorted_ids = []
    params.each do |k, v|
      next unless v.is_a? Array
      sortable_class = k.to_s.classify.constantize
      @sortable_classes << sortable_class
      @sorted_ids << v
    end
  end
end
