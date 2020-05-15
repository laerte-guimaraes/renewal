require 'rails_helper'

RSpec.describe User, type: :model do
  context 'durante o cadastro de usuários' do
    context 'informando todos os dados corretamente' do
      let(:contract) { build(:contract) }
      let(:user) do
        build(:user, name: 'Afonso', email: 'afs@gmail.com', password: '123456', contract: contract)
      end

      before { user.save }

      it 'deve criar um novo usuário' do
        expect(User.last).to eq(user)
      end

      it 'não deve possuir erros de validação' do
        expect(user.errors).to be_empty
      end
    end

    context 'não informando email' do
      let(:contract) { build(:contract) }
      let(:user) do
        build(:user, name: 'Afonso', email: nil, password: '123456', contract: contract)
      end

      before { user.save }

      it 'não deve salvar o usuário' do
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect(user.errors.full_messages).to include('Email é obrigatório.')
      end
    end

    context 'não informando nome' do
      let(:contract) { build(:contract) }
      let(:user) do
        build(:user, name: nil, email: 'afs@gmail.com', password: '123456', contract: contract)
      end

      it 'não deve salvar o usuário' do
        try { user.save } rescue { }
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect { user.save }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'não informando senha' do
      let(:contract) { build(:contract) }
      let(:user) do
        build(:user, name: 'Afonso', email: 'afs@gmail.com', password: nil, contract: contract)
      end

      before { user.save }

      it 'não deve salvar o usuário' do
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect(user.errors.full_messages).to include('Senha é obrigatória.')
      end
    end
  end
end
