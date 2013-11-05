require 'spec_helper'

describe ActiveRecord::Migration do
  context "irreversible migration methods" do
    # Prevents calling methods that would create non-backwards compatible changes
    # All changes made by migrations should be able to execute on older versions
    # of the application, in case the database is updated but the code is not.
    #
    # This means changes that remove columns or drop tables cannot function, as the
    # older version of the code will not work properly.
    #
    # The best way to think about this is by answering this question:
    #   "If I run this migration, will the code from yesterday still work?"
    #
    # If the answer to that question is "No", then it should raise an error.
    #
    # Errors can be disabled if ActiveRecord::Migration.allow_destruction = true
    #
    let(:irreversible_methods) { { drop_table:     1,
                                   remove_column:  2,
                                   remove_columns: 2,
                                   rename_column:  3,
                                   rename_table:   2 } }

    it "raises an ActiveRecord::IrreversibleMigration error when any of the destructive methods are called" do
      irreversible_methods.each do |method, arity|
        arguments = [:foo] * arity
        expect { subject.send(method, *arguments) }.to raise_error(ActiveRecord::IrreversibleMigration, "Destructive methods are not allowed unless ActiveRecord::Migration.allow_destruction = true")
      end
    end

    context "with destructive methods enabled" do
      before { ActiveRecord::Migration.allow_destruction = true }

      it "does not raise an ActiveRecord::IrreversibleMigration error when any of the destructive methods are called" do
        irreversible_methods.each do |method, arity|
          arguments = [:foo] * arity
          expect { subject.send(method, *arguments) }.to_not raise_error(ActiveRecord::IrreversibleMigration, "Destructive methods are not allowed unless ActiveRecord::Migration.allow_destruction = true")
        end
      end

    end
  end
end
