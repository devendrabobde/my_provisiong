Arel::Visitors::Oracle.class_eval do

  private
  def visit_Arel_Nodes_Matches(o)
    "UPPER(#{visit o.left}) LIKE #{visit o.right.upcase}"
  end
end
