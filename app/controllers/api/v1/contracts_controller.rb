module Api::V1
  class ContractsController < BaseAPIController
    before_action :set_contract, only: %i[show update destroy]

    def index
      @contracts = Contract.all
      return_json(Response::Contract.full(@contracts), :ok)
    end

    def show
      return_json(Response::Contract.full([@contract]), :ok)
    end

    def create
      @contract = Contract.new(contract_params)

      if @contract.save
        return_json(Response::Contract.full([@contract]), :created)
      else
        return_json(@contract.errors, :unprocessable_entity)
      end
    end

    def update
      if @contract.update(contract_params)
        return_json(Response::Contract.full([@contract]), :accepted)
      else
        return_json(@contract.errors, :unprocessable_entity)
      end
    end

    def destroy
      return_deleted_response('contract', params[:id]) if @contract.destroy
    end

    private

    def set_contract
      begin
        @contract = Contract.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        return_not_found_response('contract', params[:id])
      end
    end

    def contract_params
      contract_parameters = params.require(:contract).permit(permitted_params).to_h

      contract_parameters.merge({ users: users })
    end

    def permitted_params
      %i[name]
    end

    def users
      user_ids = params.require(:users).map do |parameter|
        parameter.permit(:user_id)
      end.pluck(:user_id)

      User.where(id: user_ids)
    rescue ActionController::ParameterMissing
      []
    end
  end
end
