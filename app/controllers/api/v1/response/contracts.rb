module Api::V1::Response
  module Contracts
    module_function

    def full(objects)
      objects.map do |object|
        full_parameters.each_with_object({}) do |parameter, response|
          response.merge!(parameter => object.send(parameter))
        end
      end
    end

    def full_parameters
      %i[id name created_at users]
    end

    private_class_method :full_parameters
  end
end
