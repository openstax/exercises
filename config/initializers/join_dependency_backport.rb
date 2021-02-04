# https://github.com/rails/rails/pull/41152
# Remove in Rails 6.1.2+
ActiveRecord::Associations::JoinDependency.class_exec do
  def make_constraints(parent, child, join_type)
    foreign_table = parent.table
    foreign_klass = parent.base_klass
    child.join_constraints(foreign_table, foreign_klass, join_type, alias_tracker) do |reflection|
      table, terminated = @joined_tables[reflection]
      root = reflection == child.reflection

      if table && (!root || !terminated)
        @joined_tables[reflection] = [table, root] if root
        next table, true
      end

      table_name = @references[reflection.name.to_sym]&.to_s

      table = alias_tracker.aliased_table_for(reflection.klass.arel_table, table_name) do
        name = reflection.alias_candidate(parent.table_name)
        root ? name : "#{name}_join"
      end

      @joined_tables[reflection] ||= [table, root] if join_type == Arel::Nodes::OuterJoin
      table
    end.concat child.children.flat_map { |c| make_constraints(child, c, join_type) }
  end
end
