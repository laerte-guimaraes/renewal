require 'rails_helper'

RSpec.describe Api::V1::Response::Contract, type: :module do
  context '#full' do
    let(:specified_contract) { create_list(:contract, 2) }
    let(:returned_information) { Contract.all }

    it 'retorna os dados do(s) contrato(s) especificado(s)' do
      expect(described_class.full(specified_contract)).to eq(returned_information)
    end
  end
end
