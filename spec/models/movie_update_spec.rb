# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieUpdate do
  let(:genres) { create_list(:genre, 3) }
  let!(:movie) { create(:movie, genres: genres) }
  let(:attrs) { { id: movie.id } }

  subject { described_class.new(attrs) }

  describe '#valid?' do
    context 'when name is not provided' do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Name can't be blank")
      end
    end

    context 'when synopsis is not provided' do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Synopsis can't be blank")
      end
    end

    context 'when minutes is not provided' do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Minutes can't be blank")
      end
    end

    context 'when minutes is not valid' do
      let(:attrs) { { minutes: 0 } }

      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include('Minutes must be greater than 0')
      end
    end

    context 'when preview_video_url is not provided' do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Preview video url can't be blank")
      end
    end

    context "when genre_ids don't exists" do
      let(:attrs) { { genre_ids: [9999] } }

      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include('Genre ids not valid')
      end
    end

    context 'when genre_ids is blank' do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Genre ids can't be blank")
      end
    end

    context 'when id is incorrect' do
      let(:attrs) { { id: 0 } }

      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Movie can't be blank")
      end
    end

    context 'when all attributes are correct' do
      let(:adventure) { create(:genre, name: 'Adventure') }
      let(:comedy) { create(:genre, name: 'Comedy') }
      let(:sci_fi) { create(:genre, name: 'Sci-Fi') }

      let(:attrs) do
        {
          id: movie.id,
          name: 'Back to the future',
          minutes: 116,
          synopsis: 'Marty McFly, a 17-year-old high school student, is accidentally sent thirty years into the past in a time-traveling DeLorean by his close friend, the eccentric scientist Doc Brown.',
          preview_video_url: 'https://www.youtube.com/watch?v=qvsgGtivCgs',
          genre_ids: [adventure.id, comedy.id, sci_fi.id]
        }
      end

      it { expect(subject.valid?).to eq(true) }
    end
  end

  describe '#save' do
    context 'when all attributes are correct' do
      let(:adventure) { create(:genre, name: 'Adventure') }
      let(:comedy) { create(:genre, name: 'Comedy') }
      let(:sci_fi) { create(:genre, name: 'Sci-Fi') }

      let(:attrs) do
        {
          id: movie.id,
          name: 'Back to the future',
          minutes: 116,
          synopsis: 'Marty McFly, a 17-year-old high school student, is accidentally sent thirty years into the past in a time-traveling DeLorean by his close friend, the eccentric scientist Doc Brown.',
          preview_video_url: 'https://www.youtube.com/watch?v=qvsgGtivCgs',
          genre_ids: [adventure.id, comedy.id, sci_fi.id]
        }
      end

      it { expect(subject.save).to eq(true) }

      it do
        expect { subject.save }
          .to change { movie.reload.name }.to(attrs[:name])
          .and change { movie.minutes }.to(attrs[:minutes])
          .and change { movie.synopsis }.to(attrs[:synopsis])
          .and change { movie.preview_video_url }.to(attrs[:preview_video_url])
          .and change { movie.genre_ids }.to(attrs[:genre_ids])
      end
    end
  end
end
