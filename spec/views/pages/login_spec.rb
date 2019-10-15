require 'rails_helper'

RSpec.describe 'Na página de login', type: :feature do
  before { visit unauthenticated_root_path }

  context 'visualizando os elementos da página' do
    it 'visualiza a mensagem de boas vindas' do
      expect(page).to have_content('Olá! Faça seu login para continuar.')
    end

    it 'visualiza link para cadastro' do
      expect(page).to have_link('Faça seu cadastro')
    end

    it 'visualiza campo de email' do
      expect(page).to have_field('Email')
    end

    it 'visualiza campo de senha' do
      expect(page).to have_field('Senha')
    end

    it 'visualiza botão para login' do
      expect(page).to have_button('Login')
    end

    it 'visualiza link para recuperação de senha' do
      expect(page).to have_link('Esqueceu sua senha?')
    end
  end

  context 'no processo de login' do
    it 'deve ser possível acessar a tela de cadastro' do
      click_on 'Faça seu cadastro'

      expect(current_path).to eq(new_user_registration_path)
    end

    it 'deve ser possível acessar a tela de recuperação de senha' do
      click_on 'Esqueceu sua senha?'

      expect(current_path).to eq(new_user_password_path)
    end

    context 'não informando todos os campos' do
      it 'deve obrigar o preenchimento dos campos' do
        click_on 'Login'

        expect(page).to have_text 'Email ou senha inválidos.'
      end

      it 'deve obrigar o preenchimento da senha' do
        fill_in 'Email', with: 'tester@mail.com'
        click_on 'Login'

        expect(page).to have_text 'Email ou senha inválidos.'
      end

      it 'deve obrigar o preenchimento do email' do
        fill_in 'Senha', with: '123456'
        click_on 'Login'

        expect(page).to have_text 'Email ou senha inválidos.'
      end
    end

    context 'informando campos inválidos' do
      it 'deve rejeitar um email inválido' do
        fill_in 'Email', with: 'failure_test'
        fill_in 'Senha', with: '123456'
        click_on 'Login'

        expect(page).to have_text 'Email ou senha inválidos.'
      end

      it 'deve rejeitar uma senha inválida' do
        fill_in 'Email', with: 'successfull@test.com'
        fill_in 'Senha', with: '     /q'
        click_on 'Login'

        expect(page).to have_text 'Email ou senha inválidos.'
      end
    end

    context 'informando todos os campos' do
      context 'com dados de um usuário não cadastrado' do
        it 'não deve permitir o login' do
          fill_in 'Email', with: 'unregistered@test.com'
          fill_in 'Senha', with: '123456'
          click_on 'Login'

          expect(page).to have_text 'Email ou senha inválidos.'
          expect(current_path).to eq(new_user_session_path)
        end
      end

      context 'com dados de um usuário cadastrado' do
        let(:user) { create(:user) }

        it 'deve logar com sucesso' do
          fill_in 'Email', with: user.email
          fill_in 'Senha', with: user.password
          click_on 'Login'

          expect(page).to have_text 'Login efetuado com sucesso.'
        end
      end
    end
  end  
end
