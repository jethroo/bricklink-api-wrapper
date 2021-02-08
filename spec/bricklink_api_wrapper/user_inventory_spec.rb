# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::UserInventory do
  describe '.get' do
    context 'when call is successful and the inventory was found' do
      it 'returns an UserInventory' do
        VCR.use_cassette('get_known_user_inventory') do
          inventory = described_class.get(224_148_559)

          expect(inventory.inventory_id).to eq(224_148_559)
        end
      end
    end
  end

  describe '#update' do
    describe 'when update is successful' do
      it 'returns true and updates the inventory data' do
        VCR.use_cassette('update_user_inventory_successfully') do
          inventory = described_class.get(202_746_732)

          expect(inventory.inventory_id).to eq(202_746_732)
          expect(inventory.remarks).to eq('test')

          update_result = inventory.update(
            remarks: 'price updated',
            quantity: '+1',
            unit_price: '45.000'
          )

          expect(update_result).to be_truthy
          expect(inventory.remarks).to eq('price updated')
          expect(inventory.quantity).to eq(2)
          expect(inventory.unit_price).to eq('45.0000')
        end
      end
    end
  end

  describe '.index' do
    context 'when call is successful' do
      it 'returns matching inventories' do
        VCR.use_cassette('get_user_inventories') do
          inventories = described_class.index(status: 'S')

          expect(inventories.count).to eq(4)
        end
      end

      context 'when filtering out sets' do
        it 'returns the only parts when excluding set inventories' do
          VCR.use_cassette('get_user_inventories_with_items_excluded') do
            inventories = described_class.index(item_type: '-SET', status: 'S')

            expect(inventories.count).to eq(2)
            expect(inventories.map(&:item).map(&:type).uniq).to eq(['PART'])
          end
        end

        it 'returns the only sets when including set inventories only' do
          VCR.use_cassette('get_user_inventories_with_items_included') do
            inventories = described_class.index(item_type: 'SET', status: 'S')

            expect(inventories.count).to eq(2)
            expect(inventories.map(&:item).map(&:type).uniq).to eq(['SET'])
          end
        end
      end
    end
  end
end
