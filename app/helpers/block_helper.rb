# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module BlockHelper

  def section_block(&block)
    presenter = SectionBlock.new(self, block)
  end

  def table_block(&block)
    presenter = TableBlock.new(self, block)
  end

  def table_row_block(&block)
    presenter = TableRowBlock.new(self, block)
  end

  def table_cell_block(&block)
    presenter = TableCellBlock.new(self, block)
  end

end