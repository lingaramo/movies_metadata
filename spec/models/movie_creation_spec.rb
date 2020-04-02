# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieCreation do
  let(:attrs) { {} }
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

    context "when genre_ids is blank" do
      it do
        expect(subject.valid?).to eq(false)
        expect(subject.errors.full_messages).to include("Genre ids can't be blank")
      end
    end

    context 'when all attributes are correct' do
      let(:adventure) { create(:genre, name: 'Adventure') }
      let(:comedy) { create(:genre, name: 'Comedy') }
      let(:sci_fi) { create(:genre, name: 'Sci-Fi') }

      let(:attrs) do
        {
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
          name: 'Back to the future',
          minutes: 116,
          synopsis: 'Marty McFly, a 17-year-old high school student, is accidentally sent thirty years into the past in a time-traveling DeLorean by his close friend, the eccentric scientist Doc Brown.',
          preview_video_url: 'https://www.youtube.com/watch?v=qvsgGtivCgs',
          genre_ids: [adventure.id, comedy.id, sci_fi.id]
        }
      end

      it { expect(subject.save).to eq(true) }

      it do
        expect { subject.save }.to change { Movie.count }.by(1)

        movie = subject.movie
        expect(movie.genres.pluck(:id)).to match_array(Genre.ids)
      end
    end
  end
end
