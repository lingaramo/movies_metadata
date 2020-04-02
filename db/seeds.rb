# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user = User.create!(name: 'John Doe', email: 'john@doe.com', password: 123456, role: :user)
User.create!(name: 'Admin', email: 'admin@email.com', password: 123456, role: :admin)

[
  'Absurdist/surreal/whimsical',
  'Action',
  'Adventure',
  'Comedy',
  'Crime',
  'Drama',
  'Fantasy',
  'Historical',
  'Historical fiction',
  'Horror',
  'Magical realism',
  'Mystery',
  'Paranoid fiction',
  'Philosophical',
  'Political',
  'Romance',
  'Saga',
  'Satire',
  'Science fiction',
  'Social',
  'Speculative',
  'Thriller',
  'Urban',
  'Western'
].each do |genre|
  Genre.create!(name: genre)
end

genres = Genre.where(name: %w[Action Adventure Fantasy])

movie = Movie.new(
  name: 'Avatar',
  synopsis: "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
  minutes: 162,
  preview_video_url: 'https://www.youtube.com/watch?v=6ziBFh3V1aM'
)
movie.save!
movie.genres << genres
movie.scores.create!(user: user, score: 89)

movie = Movie.new(
  name: 'Pirates of the Caribbean: The Curse of the Black Pearl',
  synopsis: "Blacksmith Will Turner teams up with eccentric pirate \"Captain\" Jack Sparrow to save his love, the governor's daughter, from Jack's former pirate allies, who are now undead.",
  minutes: 143,
  preview_video_url: 'https://www.youtube.com/watch?v=naQr0uTrH_s'
)
movie.save!
movie.genres << genres
movie.scores.create!(user: user, score: 92)

movie = Movie.new(
  name: 'Trainspotting',
  synopsis: "Renton, deeply immersed in the Edinburgh drug scene, tries to clean up and get out, despite the allure of the drugs and influence of friends.",
  minutes: 93,
  preview_video_url: 'https://www.youtube.com/watch?v=8LuxOYIpu-I'
)
movie.save!
movie.genres << Genre.where(name: 'Drama')
movie.scores.create!(user: user, score: 96)
