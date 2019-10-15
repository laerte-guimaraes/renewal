require 'rails_helper'

RSpec.describe User, type: :model do
  context 'durante o cadastro de usuários' do
    context 'informando todos os dados corretamente' do
      let(:user) { build(:user, name: 'Afonso', email: 'afs@gmail.com', password: '123456') }
      before { user.save }

      it 'deve criar um novo usuário' do
        expect(user.save).to be_truthy
        expect(User.last).to eq(user)
      end

      it 'não deve possuir erros de validação' do
        expect(user.errors).to be_empty
      end
    end

    context 'não informando email' do
      let(:user) { build(:user, name: 'Afonso', email: nil, password: '123456') }
      before { user.save }

      it 'não deve salvar o usuário' do
        expect(user.save).to be_falsey
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect(user.errors.full_messages).to include('Email é obrigatório.')
      end
    end

    context 'não informando nome' do
      let(:user) { build(:user, name: nil, email: 'afs@gmail.com', password: '123456') }

      it 'não deve salvar o usuário' do
        try { user.save } rescue { }
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect { user.save }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'não informando senha' do
      let(:user) { build(:user, name: 'Afonso', email: 'afs@gmail.com', password: nil) }
      before { user.save }

      it 'não deve salvar o usuário' do
        expect(user.save).to be_falsey
        expect(User.last).not_to be_present
      end

      it 'deve possuir erros de validação' do
        expect(user.errors.full_messages).to include('Senha é obrigatória.')
      end
    end
  end
end
