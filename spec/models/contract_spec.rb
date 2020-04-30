require 'rails_helper'

RSpec.describe Contract, type: :model do
  context 'durante o cadastro de um contrato' do
    context 'informando todos os dados corretamente' do
      let(:user) { build(:user) }
      let(:contract) { build(:contract, name: 'Renewal', users: [user]) }

      before { contract.save }

      it 'deve criar um novo contrato' do
        expect(Contract.last).to eq(contract)
      end

      it 'não deve possuir erros de validação' do
        expect(contract.errors).to be_empty
      end
    end

    context 'não informando nome' do
      let(:user) { build(:user) }
      let(:contract) { build(:contract, name: '', users: [user]) }

      before { contract.save }

      it 'não deve salvar o usuário' do
        expect(Contract.last).not_to be_present
      end
    end

    context 'não informando um usuário' do
      let(:contract) { build(:contract, name: 'Renewal') }
      before { contract.save }

      it 'deve criar um novo contrato' do
        expect(Contract.last).to eq(contract)
      end

      it 'não deve possuir erros de validação' do
        expect(contract.errors).to be_empty
      end

      it 'não deve possuir relação com nenhum usuário' do
        expect(contract.users).to be_empty
      end
    end
  end
end
