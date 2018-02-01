# Due to weird interactions between Squeel and ActiveRecord,
# we need this patch to be able to use .count in the exercises search
# Otherwise, the grep method call will throw an exception and the count will fail
# https://github.com/rails/rails/blob/master/activerecord/lib/active_record/relation/calculations.rb
ActiveRecord::Calculations.class_exec do
  private

  def perform_calculation(operation, column_name, options = {})
    operation = operation.to_s.downcase

    # If #count is used with #distinct / #uniq it is considered distinct.
    # (eg. relation.distinct.count)
    distinct = self.distinct_value

    if operation == "count"
      column_name ||= select_for_count

      outer_join = !arel.ast.grep(Arel::Nodes::OuterJoin).empty? rescue true
      distinct = true if outer_join

      column_name = primary_key if column_name == :all && distinct
      distinct = nil if column_name =~ /\s*DISTINCT[\s(]+/i
    end

    if group_values.any?
      execute_grouped_calculation(operation, column_name, distinct)
    else
      execute_simple_calculation(operation, column_name, distinct)
    end
  end
end
