moviesRating = LOAD '/data/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);
moviesDetails = LOAD '/data/u.item' USING PigStorage('|')
	AS (movieID:int, movieTitle:chararray, releaseDate:chararray);
moviesDetails = FOREACH moviesDetails GENERATE movieID,movieTitle, ToUnixTime(ToDate(releaseDate, 'dd-MMM-yyyy')) AS releaseTime;
ratingsByMovie = GROUP moviesRating BY movieID;
avgRatings = FOREACH ratingsByMovie GENERATE group As movieID,AVG(moviesRating.rating) AS avgRating;
higherMovies = FILTER avgRatings BY avgRating > 4.5;
fullNames = JOIN higherMovies BY movieID , moviesDetails BY movieID ;

sortedData = ORDER fullNames BY moviesDetails::releaseTime;
DUMP sortedData;

/*
DESCRIBE moviesRating;
DESCRIBE moviesDetails;
DESCRIBE groupedRating;
DESCRIBE avgRatings;
*/