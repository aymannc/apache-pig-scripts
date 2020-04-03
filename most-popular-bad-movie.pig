moviesRating = LOAD '/data/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);
moviesDetails = LOAD '/data/u.item' USING PigStorage('|')
	AS (movieID:int, movieTitle:chararray, releaseDate:chararray);

groupedMovies = Group moviesRating By movieID ;
moviesAvgRating = FOREACH groupedMovies GENERATE group as movieID , AVG(moviesRating.rating) as avgRating, COUNT(moviesRating.rating) as ratingCount ;

worstMovies = FILTER moviesAvgRating BY avgRating < 2.0;
DESCRIBE moviesAvgRating;
DESCRIBE worstMovies;

worstMovies = Order worstMovies By ratingCount DESC;
results = Join worstMovies by movieID , moviesDetails by movieID;

DUMP results;