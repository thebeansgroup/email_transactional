module EmailTransactional
  module Stages
    class StoreInMemcached
      def run(email)
        EmailTransactional::Stores::Memcached.instance.store_email(email)
      end
    end
  end
end
