# README

* Configuration
  Clone this repo.

  Inside this folder, run `bundle`

* Database initialization
  Postgresql should be installed locally

  `rails db:setup`

* How to run the test suite

  `bundle exec rspec`

* Description
  * Authentication
    For authentication I chose `devise-token-auth`. Includes all the power of `devise` gem, plus a token-based authentication strategy.

    Authentication starts with a post request to `/auth/sign_in` with a body that includes `email` and `password`.
    The authentication token is provided in the headers of the response and should be included in all the following
    requests to be authenticated.
    The required headers are `'access-token', 'expiry', 'token-type', 'uid', 'client'`. (Don't forget `"content-type": "application/json"`)

    https://devise-token-auth.gitbook.io/devise-token-auth/

  * Authorization
    Pundit gem provides a simple OO way to create policies to grant authorizations to user.

    https://github.com/varvet/pundit

  * API
    To version the api, the routes are preceded by `/api/v1`.

    Admin endpoints
    - To create movies use post `/api/v1/movies`; requires a body with `name, synopsis, minutes, preview_video_url, genre_ids`.
    - To update movies use put `/api/v1/movies/:id`; requires a body with `name, synopsis, minutes, preview_video_url, genre_ids`.
    - delete `/api/v1/movies/:id` to destroy a movie.

    User endpoints
    - To create a score, use post `/api/v1/movies/:movie_id/scores`; requires a body with `score` between 0 and 100.
    - To delete a score, use post `/api/v1/movies/:movie_id/scores/:id`; only the creator of the score can destroy.

    Public endpoints (even unauthenticated request can query these endpoints)
    - get `/api/v1/movies?movie_ids=1,2,3`. `movie_ids` is required by definition, otherwise response will be blank 🤷
    - get `/api/v1/movies/:id`

* Testing the API
  The first step is to initialize a server locally. To do this, run `rails server`.
  The server will available in http://localhost:3000, but this can vary in some cases. Make sure about this for the following examples.
  You can use your favorite client for api testing. Public endpoints can be tested without being authenticated.

  - Authentication
    You have to do a post request to `http://localhost:3000/auth/sign_in`, including in the headers `"content-type": "application/json"` and a body with `email` and `password`.
    The seed file created two users. One with an `admin` role, and the other with a `user` role.
    user: email: `john@doe.com`, password: `123456`
    admin: email: `admin@email.com`, password: `123456`

    Take from the response headers `'access-token', 'expiry', 'token-type', 'uid', 'client'` and use them in every request you want to be authenticated.

    Alternatively, use the following code snippet to simplify the use of the authentication headers.

    It requires `httparty`. Make sure you have it installed `gem install httparty`

    ```ruby
    require 'httparty'

    class MovieMetadata
      BASE_URL = 'http://localhost:3000'
      AUTH_HEADERS_KEYS = ['access-token', 'expiry', 'token-type', 'uid', 'client', 'content-type']

      def initialize(email, password)
        return if email.nil? || password.nil?

        authenticate(email, password)
      end

      def authenticate(email, password)
        response = HTTParty.post(
          BASE_URL + '/auth/sign_in',
          body: {email: email, password: password}.to_json,
          headers: { "content-type": "application/json" }
        )

        headers = response.headers
        @authentication_headers = headers.select { |k, _| AUTH_HEADERS_KEYS.include?(k) }.transform_values(&:first)
      end

      def authentication_headers
        @authentication_headers || {}
      end

      def get(path)
        response = HTTParty.get(
          BASE_URL + path,
          headers: authentication_headers
        )

        pretty_print(response)
      end

      def put(path, body)
        response = HTTParty.put(
          BASE_URL + path,
          body: body.to_json,
          headers: authentication_headers
        )

        pretty_print(response)
      end

      def post(path, body)
        response = HTTParty.post(
          BASE_URL + path,
          body: body.to_json,
          headers: authentication_headers
        )

        pretty_print(response)
      end

      def delete(path)
        response = HTTParty.delete(
          BASE_URL + path,
          headers: authentication_headers
        )

        response.code
      end

      private

      def pretty_print(response)
        puts JSON.pretty_generate(JSON.parse(response.body))
      end
    end

    # Some of these values assume that the db was build from the seed file

    # Examples:
    #
    # user = MovieMetadata.new('john@doe.com', 123456)
    # user.get('/api/v1/movies?movie_ids=1,2,3')
    # user.get('/api/v1/movies/1')
    # user.delete('/api/v1/movies/2/scores/2')
    # user.post('/api/v1/movies/2/scores', {score: 100})
    #
    # admin = MovieMetadata.new('admin@email.com', 123456)
    # admin.get('/api/v1/movies?movie_ids=1,2,3')
    # admin.get('/api/v1/movies/1')
    # body = { name: 'Another movie', synopsis: 'Synopsis', minutes: 123, preview_video_url: 'www.youtube.com', genre_ids: [1,2,3] }
    # admin.post('/api/v1/movies', body)
    # admin.put('/api/v1/movies/4', body.merge(minutes: 200))
    # admin.get('/api/v1/movies/4')
    # admin.delete('/api/v1/movies/4')
    ```
* ERD

  Check `erd.pdf` to see a diagram generated by `rails-erd` gem.
