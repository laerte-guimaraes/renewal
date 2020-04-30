module Api::V1
  class ContractsController < BaseAPIController
    before_action :set_contract, only: [:show, :update, :destroy]

    def index
      @contracts = Contract.all
      render json: @contracts
    end

    def show
      render json: @contract
    end

    def create
      @contract = Contract.new(contract_params)

      if @contract.save
        render json: @contract, status: :created
      else
        render json: @contract.errors, status: :unprocessable_entity
      end
    end

    def update
      if @contract.update(contract_params)
        render json: @contract
      else
        render json: @contract.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @contract.destroy
    end

    private

    def set_contract
      @contract = Contract.find(params[:id])
    end

    def contract_params
      contract_parameters = params.require(:contract).permit(permitted_params).to_h

      contract_parameters.merge({ users: users })
    end

    def permitted_params
      [ :name ]
    end

    def users
      user_ids = params.require(:users).map do |parameter|
        parameter.permit(:user_id)
      end.pluck(:user_id)

      User.where(id: user_ids)
    end
  end
end
