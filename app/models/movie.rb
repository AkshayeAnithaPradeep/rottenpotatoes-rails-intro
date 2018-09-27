class Movie < ActiveRecord::Base
    def self.get_all_ratings
      #returns all ratings in the db
      @movies = self.all
      @ratings = Array.new
      @movies.each do |movie|
        if !@ratings.include? movie.rating
          @ratings.push(movie.rating)
        end
      end
      return @ratings
    end
end
