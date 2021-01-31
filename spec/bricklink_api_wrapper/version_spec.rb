# frozen_string_literal: true

RSpec.describe BricklinkApiWrapper::Version do
  it 'has a version number' do
    expect(BricklinkApiWrapper::Version::VERSION).not_to be nil
  end
end
