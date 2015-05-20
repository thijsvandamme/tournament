-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


CREATE TABLE players (player_id serial PRIMARY KEY, players_name varchar(100));
CREATE TABLE matches (match_id serial PRIMARY KEY, match_player int REFERENCES players(player_id), match_result int DEFAULT 0);
