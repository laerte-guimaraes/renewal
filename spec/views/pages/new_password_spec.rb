require 'rails_helper'

RSpec.describe 'Na página de recuperação de senha', type: :feature do
  before { visit new_user_password_path }

  context 'visualizando os elementos da página' do
    it 'visualiza campo de email' do
      expect(page).to have_field('Email')
    end

    it 'visualiza botão para redefinir a senha' do
      expect(page).to have_button('Redefinir senha')
    end

    it 'visualiza botão para voltar para a tela de login' do
      expect(page).to have_link('Voltar para o login')
    end
  end

  context 'no processo de recuperação de senha' do
    it 'deve ser possível voltar para a tela de login' do
      click_on 'Voltar para o login'

      expect(current_path).to eq(new_user_session_path)
    end

    context 'não informando um email' do
      it 'deve obrigar o preenchimento dos campos' do
        click_on 'Redefinir senha'

        expect(page).to have_text 'Email é obrigatório'
      end
    end

    context 'informando um email' do
      let(:user) { create(:user) }

      it 'deve rejeitar um email inválido' do
        fill_in 'Email', with: 'failure_test'
        click_on 'Redefinir senha'

        expect(page).to have_text 'Email não encontrado'
      end

      it 'deve rejeitar um email não cadastrado' do
        fill_in 'Email', with: 'unregistered@test.com'
        click_on 'Redefinir senha'

        expect(page).to have_text 'Email não encontrado'
      end

      it 'deve aceitar um email cadastrado' do
        fill_in 'Email', with: user.email
        click_on 'Redefinir senha'

        expect(page).to have_text 'Dentro de minutos, '\
          'você receberá um email com as instruções de redefinição da sua senha.'
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
