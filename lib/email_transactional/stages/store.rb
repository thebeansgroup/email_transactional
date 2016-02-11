module EmailTransactional
  module Stages
    class Store
      def initialize(store)
        @store = store
      end

      def run(email)
        @store.store_email(email)
        email
      end
    end
  end
end
