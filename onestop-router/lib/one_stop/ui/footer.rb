module OneStop
  module UI
    class Footer < ActiveAdmin::Component
      def build
        super(id: "footer")
        para "Copyright DrFirst, Inc. #{Date.today.year}, All Rights Reserved."
      end
    end
  end
end
