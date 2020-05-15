require 'rails_helper'

RSpec.describe Api::V1::ContractsController, type: :controller do
  context '#index' do
    let(:contract) { Contract.first }
    let(:response) { get_with_authentication(:index) }

    it 'retorna os dados dos contratos cadastrados' do
      json_response = JSON.parse(response.body).shift

      expect(json_response['id']).to eq(contract.id)
      expect(json_response['name']).to eq(contract.name)
      expect(json_response['created_at'].to_date).to eq(contract.created_at.to_date)
      expect(json_response['users']).to eq(JSON.parse(contract.users.to_json))
    end

    it 'retorna o status http 200' do
      expect(response.status).to eq(200)
    end
  end

  context '#show' do
    let(:contract) { create(:contract) }
    let(:response) { get_with_authentication(:show, { id: contract.id }) }

    context 'especificado um contrato já existente' do
      it 'retorna os dados do contrato especificado' do
        json_response = JSON.parse(response.body).shift

        expect(json_response['id']).to eq(contract.id)
        expect(json_response['name']).to eq(contract.name)
        expect(json_response['created_at'].to_date).to eq(contract.created_at.to_date)
        expect(json_response['users']).to eq(JSON.parse(contract.users.to_json))
      end

      it 'retorna o status http 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'especificado um contrato não existente' do
      let(:response) { get_with_authentication(:show, { id: 0 }) }

      it 'retorna que o contato especificado não existe' do
        expected_response = { 'Não encontrado' => 'Contrato ID:0' }
        json_response = JSON.parse(response.body)

        expect(expected_response).to eq(json_response)
      end

      it 'retorna o status http 404' do
        expect(response.status).to eq(404)
      end
    end
  end

  context '#create' do
    context 'com os parâmetros válidos' do
      let(:contract) { Contract.last }
      let(:name) { 'McDonalds' }
      let(:response) { post_with_authentication(:create, { name: name }) }

      it 'cria um novo contrato' do
        expect { response }.to change { Contract.count }
      end

      it 'retorna os dados do contrato criado' do
        json_response = JSON.parse(response.body).shift

        expect(json_response['id']).to eq(contract.id)
        expect(json_response['name']).to eq(name)
        expect(json_response['created_at'].to_date).to eq(contract.created_at.to_date)
        expect(json_response['users']).to eq(JSON.parse(contract.users.to_json))
      end

      it 'retorna o status http 201' do
        expect(response.status).to eq(201)
      end

      context 'associando um usuário' do
        let(:user) { create(:user) }
        let(:response) do
          post_with_authentication(:create, { name: name, users: [ user_id: user.id ] })
        end

        it 'retorna os dados do usuário associado com o contrato' do
          json_response = JSON.parse(response.body).shift['users'].shift.sort
          user_in_json = JSON.parse(user.reload.to_json).sort

          expect(json_response).to eq(user_in_json)
        end
      end
    end

    context 'sem os parâmetros válidos' do
      let(:name) { ' ' }
      let!(:response) { post_with_authentication(:create, { name: name }) }

      it 'não crie um novo contrato' do
        expect { response }.not_to change { Contract.count }
      end

      it 'retorna os erros de criação do contrato' do
        expected_response = { 'name' => [ 'é obrigatório.' ] }
        json_response = JSON.parse(response.body)

        expect(expected_response).to eq(json_response)
      end

      it 'retorna o status http 422' do
        expect(response.status).to eq(422)
      end
    end
  end

  context '#update' do
    let(:contract) { create(:contract) }

    context 'com os parâmetros válidos' do
      let(:name) { 'McDonalds' }
      let(:response) { put_with_authentication(:update, { id: contract.id, name: name }) }

      it 'retorna os dados do contrato atualizado' do
        json_response = JSON.parse(response.body).shift

        expect(json_response['id']).to eq(contract.id)
        expect(json_response['name']).to eq(name)
        expect(json_response['created_at'].to_date).to eq(contract.created_at.to_date)
        expect(json_response['users']).to eq(JSON.parse(contract.users.to_json))
      end

      it 'retorna o status http 202' do
        expect(response.status).to eq(202)
      end
    end

    context 'com parâmetros inválidos' do
      let(:response) { put_with_authentication(:update, { id: contract.id, name: ' ' }) }

      it 'não atualiza o contrato' do
        expect { response }.not_to change { contract.updated_at }
      end

      it 'retorna os erros de atualização do contrato' do
        expected_response = { 'name' => [ 'é obrigatório.' ] }
        json_response = JSON.parse(response.body)

        expect(expected_response).to eq(json_response)
      end

      it 'retorna o status http 422' do
        expect(response.status).to eq(422)
      end
    end
  end


  context '#destroy' do
    let(:contract) { create(:contract) }
    let(:response) { delete_with_authentication(:destroy, { id: contract.id }) }

    context 'especificado um contrato existente' do
      it 'apaga o contrato especificado' do
        expect(Contract.count).to be_zero
      end

      it 'retorna a mensagem que o contrato foi deletado' do
        expected_response = { 'Deletado' => "Contrato ID:#{contract.id}" }
        json_response = JSON.parse(response.body)

        expect(expected_response).to eq(json_response)
      end

      it 'retorna o status http 202' do
        expect(response.status).to eq(202)
      end
    end

    context 'especificado um contrato não existente' do
      let(:response) { delete_with_authentication(:destroy, { id: 0 }) }

      it 'retorna que o contato especificado não existe' do
        expected_response = { 'Não encontrado' => 'Contrato ID:0' }
        json_response = JSON.parse(response.body)

        expect(expected_response).to eq(json_response)
      end

      it 'retorna o status http 404' do
        expect(response.status).to eq(404)
      end
    end
  end
end
