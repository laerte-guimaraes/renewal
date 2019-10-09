require 'rails_helper'

RSpec.describe 'Na página de registro', type: :feature do
  before { visit new_user_registration_path }

  context 'visualizando os elementos da página' do
    it 'visualiza campo de email' do
      expect(page).to have_field('Email')
    end

    it 'visualiza campo de senha' do
      expect(page).to have_field('Senha')
    end

    it 'visualiza campo de confirmação de senha' do
      expect(page).to have_field('Confirme sua senha')
    end

    it 'visualiza botão para realizar o cadastro' do
      expect(page).to have_button('Faça seu cadastro')
    end

    it 'visualiza botão para voltar para a tela de login' do
      expect(page).to have_link('Voltar para o login')
    end
  end

  context 'no processo de cadastro' do
    it 'deve ser possível voltar para a tela de login' do
      click_on 'Voltar para o login'

      expect(current_path).to eq(new_user_session_path)
    end

    context 'não informando todos os campos' do
      it 'deve obrigar o preenchimento dos campos' do
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Email é obrigatório.'
        expect(page).to have_text 'Senha é obrigatória.'
      end

      it 'deve obrigar o preenchimento do email' do
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Email é obrigatório.'
      end

      it 'deve obrigar o preenchimento da senha' do
        fill_in 'Email', with: 'tester@mail.com'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Senha é obrigatória.'
      end

      it 'deve obrigar o preenchimento da confirmação de senha' do
        fill_in 'Email', with: 'tester@mail.com'
        fill_in 'Senha', with: '123456'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Confirmação de senha é inválida.'
      end
    end

    context 'informando campos inválidos' do
      it 'deve rejeitar um email inválido' do
        fill_in 'Email', with: 'failure_test'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Email é inválido.'
      end

      it 'deve rejeitar uma senha inválida' do
        fill_in 'Email', with: 'successfull@test.com'
        fill_in 'Senha', with: '1'
        fill_in 'Confirme sua senha', with: '1'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Senha é muito curta.'
      end

      it 'deve rejeitar uma confirmação de senha inválida' do
        fill_in 'Email', with: 'successfull@test.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '     /q'
        click_on 'Faça seu cadastro'

        expect(page).to have_text 'Confirmação de senha é inválida.'
      end
    end

    context 'informando todos os campos' do
      context 'com dados de um usuário já cadastrado' do
        let(:user) { create(:user) }

        it 'deve rejeitar o cadastro' do
          fill_in 'Email', with: user.email
          fill_in 'Senha', with: user.password
          fill_in 'Confirme sua senha', with: user.password
          click_on 'Faça seu cadastro'

          expect(page).to have_text 'Email já cadastrado.'
        end
      end

      context 'com dados de um novo usuário' do
        it 'deve cadastrar o usuário com sucesso' do
          fill_in 'Email', with: 'tester@renewal.com'
          fill_in 'Senha', with: '123456'
          fill_in 'Confirme sua senha', with: '123456'
          click_on 'Faça seu cadastro'

          expect(User.find_by(email: 'tester@renewal.com')).to be_present
          expect(page).to have_text 'Bem vindo! Você realizou seu registro com sucesso.'
          expect(current_path).to eq(authenticated_root_path)
        end
      end
    end
  end
end
