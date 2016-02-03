module EmailTransactional
  module Stages
    class StoreInMemcached
      def run(email)
        EmailTransactional::Store.instance.store_email(email)
      end
    end
  end
end
