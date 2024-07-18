require 'rails_helper'

RSpec.describe Paginators::KeysetById do
  let!(:buildings) { create_list(:building, 15) }

  describe '#call' do
    context 'when after_id is provided' do
      it 'returns paginated results after the given ID' do
        paginator = Paginators::KeysetById.new(after_id: buildings[4].id, per_page: 5)
        results = paginator.call

        expect(results.count).to eq(5)
        expect(results.first.id).to eq(buildings[5].id)
        expect(results.last.id).to eq(buildings[9].id)
      end
    end

    context 'when after_id is not provided' do
      it 'returns paginated results from the beginning' do
        paginator = Paginators::KeysetById.new(per_page: 5)
        results = paginator.call

        expect(results.count).to eq(5)
        expect(results.first.id).to eq(buildings.first.id)
        expect(results.last.id).to eq(buildings[4].id)
      end
    end
  end
end
