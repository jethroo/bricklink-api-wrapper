# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::UserInventory do
  describe '.get' do
    context 'when call is successful and the inventory was found' do
      it 'returns an UserInventory',
         vcr: { cassette_name: 'get_known_user_inventory' } do
        inventory = described_class.get(224_148_559)

        expect(inventory.inventory_id).to eq(224_148_559)
      end
    end
  end

  describe '#update' do
    describe 'when update is successful' do
      it 'returns true and updates the inventory data',
         vcr: { cassette_name: 'update_user_inventory_successfully' } do
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

  describe '.index' do
    context 'when call is successful' do
      it 'returns matching inventories',
         vcr: { cassette_name: 'get_user_inventories' } do
        inventories = described_class.index(status: 'S')

        expect(inventories.count).to eq(4)
      end

      context 'when filtering out sets' do
        it 'returns only the parts when excluding set inventories',
           vcr: { cassette_name: 'get_user_inventories_with_items_excluded' } do
          inventories = described_class.index(item_type: '-SET', status: 'S')

          expect(inventories.count).to eq(2)
          expect(inventories.map(&:item).map(&:type).uniq).to eq(['PART'])
        end

        it 'returns only the sets when including set inventories only',
           vcr: { cassette_name: 'get_user_inventories_with_items_included' } do
          inventories = described_class.index(item_type: 'SET', status: 'S')

          expect(inventories.count).to eq(2)
          expect(inventories.map(&:item).map(&:type).uniq).to eq(['SET'])
        end
      end
    end
  end

  describe '.create' do
    context 'when call is successful and the inventory was created' do
      it 'returns an UserInventory',
         vcr: { cassette_name: 'create_new_user_inventory_successfully' } do
        inventory = described_class.create(
          item: { no: '7657-1', type: 'SET' }, is_stock_room: true,
          stockroom_id: 'B', color_id: 0, quantity: 1, unit_price: '50',
          new_or_used: 'U', completeness: 'C', is_retain: false,
          remarks: 'created_via_test'
        )

        expect(inventory.inventory_id).not_to be_nil
        expect(inventory.remarks).to eq('created_via_test')
      end
    end
  end

  describe '.bulk_create' do
    context 'when call is successful and the inventory was created' do
      let(:item1) do
        { item: { no: '7657-1', type: 'SET' }, is_stock_room: true,
          color_id: 0, quantity: 1, unit_price: '50',
          new_or_used: 'U', completeness: 'C', is_retain: false,
          remarks: 'created_via_test' }
      end

      let(:item2) do
        { item: { no: '3001', type: 'PART' }, is_stock_room: true,
          color_id: 0, quantity: 1, unit_price: '50',
          new_or_used: 'U', completeness: 'C', is_retain: false,
          remarks: 'created_via_test' }
      end

      it 'returns an UserInventory',
         vcr: { cassette_name: 'bulk_create_new_user_inventory_successfully' } do
        status = described_class.bulk_create(
          [item1, item2]
        )

        expect(status).to be_truthy
      end
    end
  end
end
