# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::Order do
  describe '.index' do
    context 'when call is successful' do
      it 'returns matching orders', :vcr do
        orders = described_class.index

        expect(orders.count).to eq(2)
        expect(orders.map { |o| o.order_id.to_s }).to eq(%w[2623649 2633919])
      end
    end
  end

  describe '.get' do
    context 'when call is successful' do
      it 'returns matching order', :vcr do
        order = described_class.get(15646315)
        expect(order).to be_a(BricklinkApiWrapper::Order)
      end
    end
  end

  describe '#items' do
    context 'when call is successful' do
      let(:order) { described_class.get(15646315) }

      it 'returns the order items', :vcr do
        expect(order.items.count).to eq(33)
      end
    end
  end
end
