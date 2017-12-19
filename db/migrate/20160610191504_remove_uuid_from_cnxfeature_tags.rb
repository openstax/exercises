class RemoveUuidFromCnxfeatureTags < ActiveRecord::Migration
  def up
    Tag.where {name.like 'context-cnxfeature:%#%'}.update_all("name = regexp_replace(name, '^context-cnxfeature:[\\w-]+#([\\w-]+)$', 'context-cnxfeature:\\1')")
  end

  def down
  end
end
