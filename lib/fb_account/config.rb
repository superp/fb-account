module FbAccount
  class Config
    class << self
      attr_accessor :app_id, :app_secret

      def setup
        yield(self)
      end
    end
  end
end