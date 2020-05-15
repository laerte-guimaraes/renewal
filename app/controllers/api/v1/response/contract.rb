module Api::V1::Response
  class Contract < ContractSerializer
    class << self
      def full(objects)
        objects
      end
    end
  end
end
