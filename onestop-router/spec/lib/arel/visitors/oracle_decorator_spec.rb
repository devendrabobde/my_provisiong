require 'spec_helper'

module Arel
  module Visitors
    describe Oracle do
      let!(:visitor) { Oracle.new Table.engine.connection }

      it "transforms like queries to be case-insensitive" do
        sql = visitor.accept Nodes::Matches.new(Arel.sql('reenhanced'), Arel.sql('awesome'))
        sql.should == "UPPER(reenhanced) LIKE AWESOME"
      end
    end
  end
end
