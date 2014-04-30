module Extensions
  module UUID
    extend ActiveSupport::Concern

    included do

      before_create :generate_uuid

      def generate_uuid
        self.id = UUIDTools::UUID.random_create.to_s
      end
    end
  end
end
