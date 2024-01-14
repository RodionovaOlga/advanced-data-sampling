CREATE TABLE IF NOT EXISTS Genres (
  genre_id serial PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Musicians (
  musician_id serial PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Genres_musicians (
  genre_musician_id serial PRIMARY KEY,
  musician_id integer references Musicians(musician_id),
  genre_id integer references genre(genre_id) 
);

CREATE TABLE IF NOT EXISTS Albums (
  album_id serial PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  release_year integer NOT NULL
);

CREATE TABLE IF NOT EXISTS Musicians_albums (
  musician_album_id serial PRIMARY KEY,
  musician_id integer references Musicians(musician_id),
  album_id integer references Albums(album_id) 
);

CREATE TABLE IF NOT EXISTS Tracks (
  track_id serial PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  duration integer NOT NULL,
  album_id integer references Albums(album_id)
);

CREATE TABLE IF NOT EXISTS Collections (
  collection_id serial PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  release_year integer NOT NULL
);

CREATE TABLE IF NOT EXISTS Tracks_collections (
  track_collection_id serial PRIMARY KEY,
  track_id integer references Tracks(track_id),
  collection_id integer references Collections(collection_id)
);

select name, duration 
from tracks
where duration = (SELECT MAX(duration) FROM tracks);

select name 
from tracks
where duration >= 210;

select name 
from collections
where release_year between 2018 and 2020;

select name 
from musicians
where name not like '% %';

select name 
from tracks
where name like '%My%' or name like '%Мой%';

select genre.name, musicians.name 
from genre left join musicians 
on genre.genre_id = musicians.musician_id;

select count(g.genre_id), g.name 
from genre g 
left join genres_musicians gm on g.genre_id = gm.genre_id
group by g.name;

select count(a.album_id), a.name 
from albums a
left join tracks t  on t.album_id = a.album_id
where a.release_year between 2019 and 2020
group by a.name;

select avg(t.duration), a.name
from tracks t  
left join albums a on t.album_id = a.album_id 
group by a.name
order by avg(t.duration) asc;

select m.name, a.release_year 
from musicians m 
left join musicians_albums ma ON m.musician_id = ma.musician_id 
left join albums a on a.album_id = ma.album_id 
where a.release_year != 2020
group by m.name, a.release_year
order by a.release_year asc;

select c.name, m.name
from collections c 
left join tracks_collections tc on c.collection_id = tc.collection_id 
left join tracks t on tc.track_id = t.track_id 
left join albums a on t.album_id = a.album_id 
left join musicians_albums ma on a.album_id = ma.album_id 
left join musicians m on ma.musician_id = m.musician_id 
where m.name = 'Ariana Grande'
group by c.name, m.name;
