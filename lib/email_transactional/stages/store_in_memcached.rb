module EmailTransactional
  module Stages
    class StoreInMemcached
      def run(email)
        EmailTransactional::MemcachedStore.instance.store_email(email)
      end
    end
  end
end
