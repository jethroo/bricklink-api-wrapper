# frozen_string_literal: true

RSpec.describe Bricklink::Api do
  subject { described_class.new }
  describe '#get' do
    let(:access_token) { double('access_token', get: response) }

    context 'when the call is successful' do
      let(:response) { OpenStruct.new(code: '200', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect(subject.get('test')).to eq(OpenStruct.new(message: 'OK'))
      end
    end

    context 'when the call is not successful' do
      let(:response) { OpenStruct.new(code: '500', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect { subject.get('test') }.to raise_error(
          Bricklink::Api::RequestError, 'Expected status code 200 but got 500'
        )
      end
    end
  end

  describe '#post' do
    let(:access_token) { double('access_token', post: response) }

    context 'when the call is successful' do
      let(:response) { OpenStruct.new(code: '200', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect(subject.post('test', {})).to eq(OpenStruct.new(message: 'OK'))
      end
    end

    context 'when the call is not successful' do
      let(:response) { OpenStruct.new(code: '500', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect { subject.post('test', {}) }.to raise_error(
          Bricklink::Api::RequestError, 'Expected status code 200 but got 500'
        )
      end
    end
  end

  describe '#put' do
    let(:access_token) { double('access_token', put: response) }

    context 'when the call is successful' do
      let(:response) { OpenStruct.new(code: '200', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect(subject.put('test', {})).to eq(OpenStruct.new(message: 'OK'))
      end
    end

    context 'when the call is not successful' do
      let(:response) { OpenStruct.new(code: '500', body: '{"message":"OK"}') }

      before do
        allow(subject).to receive(:access_token).and_return(access_token)
      end

      it 'returns the parsed payload as OpenStruct' do
        expect { subject.put('test', {}) }.to raise_error(
          Bricklink::Api::RequestError, 'Expected status code 200 but got 500'
        )
      end
    end
  end
end
