module ActiveRecord
  module DisableDestructiveMigrations
    def self.included(base)
      base.class_eval do
        cattr_accessor :allow_destruction

        [ :drop_table, :remove_column, :remove_columns, :rename_column, :rename_table ].each do |method|
            define_method method do |*args|
              if self.class.allow_destruction != true
                raise ActiveRecord::IrreversibleMigration,
                      "Destructive methods are not allowed unless ActiveRecord::Migration.allow_destruction = true"
              else
                super
              end
            end

          end
      end
    end
  end
end

ActiveRecord::Migration.send(:include, ActiveRecord::DisableDestructiveMigrations)
