require 'rails_helper'

RSpec.describe Api::V1::BaseAPIController, type: :controller do
  subject { described_class.new }

  context '#return_json' do
    let(:response_body) { {'Transação': 'Processada'} }
    let(:response_status) { :ok }

    it 'renderiza um json com body e status http enviados' do
      expect(subject).to receive(:render).with(json: response_body, status: response_status)

      subject.return_json(response_body, response_status)
    end
  end

  context '#return_unauthorized_response' do
    let(:response_body) { {'Erro' => 'Token de Autenticação Inválido'} }
    let(:response_status) { :unauthorized }

    it 'renderiza um json com body e status http pré-definidos' do
      expect(subject).to receive(:return_json).with(response_body, response_status)

      subject.return_unauthorized_response
    end
  end

  context '#return_invalid_content_type_response' do
    let(:response_body) { {'Erro' => 'Content-Type deve ser application/json'} }
    let(:response_status) { :precondition_failed }

    it 'renderiza um json com body e status http pré-definidos' do
      expect(subject).to receive(:return_json).with(response_body, response_status)

      subject.return_invalid_content_type_response
    end
  end

  context '#return_not_found_response' do
    let(:response_body) { {'Não encontrado' => 'Contrato ID:1'} }
    let(:response_status) { :not_found }

    it 'renderiza um json com body e status http pré-definidos' do
      expect(subject).to receive(:return_json).with(response_body, response_status)

      subject.return_not_found_response('contract', '1')
    end
  end

  context '#return_deleted_response' do
    let(:response_body) { {'Deletado' => 'Contrato ID:1'} }
    let(:response_status) { :accepted }

    it 'renderiza um json com body e status http pré-definidos' do
      expect(subject).to receive(:return_json).with(response_body, response_status)

      subject.return_deleted_response('contract', '1')
    end
  end

  context '#require_authentication!' do
    context 'com um token de autenticação válido' do
      before { allow(subject).to receive(:valid_authentication_token?).and_return(true) }

      it 'permite a conexão' do
        expect(subject.send(:require_authentication!)).to be_nil
      end
    end

    context 'com um token de autenticação inválido' do
      before { allow(subject).to receive(:valid_authentication_token?).and_return(false) }

      it 'retorna um erro de conexão não autorizada' do
        expect(subject).to receive(:return_unauthorized_response)

        subject.send(:require_authentication!)
      end
    end
  end

  context '#require_json_content_type!' do
    context 'com um tipo de conteúdo válido' do
      before { allow(subject).to receive(:valid_content_type?).and_return(true) }

      it 'permite a conexão' do
        expect(subject.send(:require_json_content_type!)).to be_nil
      end
    end

    context 'com um tipo de conteúdo inválido' do
      before { allow(subject).to receive(:valid_content_type?).and_return(false) }

      it 'retorna um erro de conteúdo inválido' do
        expect(subject).to receive(:return_invalid_content_type_response)

        subject.send(:require_json_content_type!)
      end
    end
  end

  context '#valid_content_type?' do
    let(:request) { ActionDispatch::Request.new(url: nil) }

    before { allow(subject).to receive(:request).and_return(request) }

    context 'caso o tipo de conteúdo no header seja válido' do
      before do
        allow(request).to receive(:headers).and_return({ 'Content-Type' => 'application/json' })
      end

      it 'retorna verdadeiro' do
        expect(subject.send(:valid_content_type?)).to be_truthy
      end
    end

    context 'caso o tipo de conteúdo no header seja inválido' do
      before { allow(request).to receive(:headers).and_return({ 'Content-Type' => 'text' }) }

      it 'retorna falso' do
        expect(subject.send(:valid_content_type?)).to be_falsey
      end
    end
  end

  context '#valid_authentication_token?' do
    let(:request) { ActionDispatch::Request.new(url: nil) }

    before do
      allow(subject).to receive(:request).and_return(request)
      allow(request).to receive(:headers)
        .and_return({ HTTP_AUTHENTICATION_TOKEN: access_token })
    end

    context 'com um token de autenticação válido' do
      let(:access_token) { create(:user).authentication_token }

      it 'retorna verdadeiro' do
        expect(subject.send(:valid_authentication_token?)).to be_truthy
      end
    end

    context 'com um token de autenticação inválido' do
      let(:access_token) { 'falseaccesstoken' }

      it 'retorna falso' do
        expect(subject.send(:valid_authentication_token?)).to be_falsey
      end
    end
  end
end
