module Api::V1::Response
  class Contracts
    class << self
      def full(objects)
        objects.map do |object|
          full_parameters.each_with_object({}) do |parameter, response|
            response.merge!(parameter => object.send(parameter))
          end
        end
      end

      private

      def full_parameters
        %i[id name created_at users]
      end
    end
  end
end
