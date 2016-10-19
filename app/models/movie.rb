class Movie < ActiveRecord::Base
       @all_ratings = ['G', 'PG', 'PG-13', 'R']

   def self.put_ratings 
        @all_ratings
    end
      def self.ratingfilter(rating)
        Movie.where('rating in (?)', rating)
    end
end
