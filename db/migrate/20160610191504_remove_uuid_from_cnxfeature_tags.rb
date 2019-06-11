class RemoveUuidFromCnxfeatureTags < ActiveRecord::Migration[4.2]
  def up
      Tag.where(Tag.arel_table[:name].matches('context-cnxfeature:%#%')).update_all("name = regexp_replace(name, '^context-cnxfeature:[\\w-]+#([\\w-]+)$', 'context-cnxfeature:\\1')")
  end

  def down
  end
end
