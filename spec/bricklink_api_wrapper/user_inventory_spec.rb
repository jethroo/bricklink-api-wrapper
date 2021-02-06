# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::UserInventory do
  describe '.get' do
    context 'when call successful and inventory found' do
      it 'returns an UserInventory' do
        VCR.use_cassette('get_known_user_inventory') do
          inventory = described_class.get(224_148_559)

          expect(inventory.data.inventory_id).to eq(224_148_559)
        end
      end
    end
  end
end
