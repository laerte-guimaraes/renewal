require 'rails_helper'

RSpec.describe Api::V1::Response::Contracts, type: :module do
  context '#full' do
    let(:sample_objects) { create_list(:contract, 2) }
    let(:first_object) { sample_objects.first }
    let(:last_object) { sample_objects.last }
    let(:sample_json) do
      [
        {
          created_at: first_object.created_at,
          id: first_object.id,
          name: first_object.name,
          users: first_object.users
        },
        {
          created_at: last_object.created_at,
          id: last_object.id,
          name: last_object.name,
          users: last_object.users
        }
      ]
    end

    it 'retorna um json dos contratos' do
      expect(described_class.full(sample_objects)).to eq(sample_json)
    end
  end

  context '#full_parameters' do
    it 'retorna os parâmetros definidos para retorno' do
      expect(described_class.send(:full_parameters)).to eq(%i[id name created_at users])
    end
  end
end
