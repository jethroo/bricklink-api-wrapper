# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::Order do
  describe '.index' do
    context 'when call is successful' do
      it 'returns matching inventories', :vcr do
        orders = described_class.index

        expect(orders.count).to eq(2)
        expect(orders.map { |o| o.order_id.to_s }).to eq(%w[2623649 2633919])
      end
    end
  end
end
