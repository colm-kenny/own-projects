CREATE VIEW Exceptions AS
SELECT DISTINCT artist_name, album_name
FROM song_artist JOIN artists USING (artist_id)
JOIN song_album USING (song_id)
JOIN albums USING (album_id)
LEFT JOIN album_artist ON album_artist.album_id = song_album.album_id AND album_artist.artist_id = song_artist.artist_id
WHERE album_artist.artist_id IS NULL;


CREATE VIEW AlbumInfo AS
SELECT album_name, list_of_artists, date_of_release, total_length
FROM albums INNER JOIN (SELECT GROUP_CONCAT(DISTINCT artist_name SEPARATOR ', ') AS list_of_artists, album_id FROM artists INNER JOIN album_artist USING (artist_id) GROUP BY album_id) AS sub1 USING (album_id) 
INNER JOIN (SELECT ROUND(SUM(song_length),2) AS total_length, album_id 
FROM songs INNER JOIN song_album USING (song_id) GROUP BY album_id) AS sub2 USING (album_id);

DELIMITER //
CREATE TRIGGER CheckReleaseDate
AFTER INSERT
ON song_album
FOR EACH ROW
BEGIN
    IF (SELECT date_of_release FROM songs WHERE song_id = NEW.song_id ) > (SELECT date_of_release FROM albums WHERE album_id = NEW.album_id) THEN
    	UPDATE songs SET date_of_release = (SELECT date_of_release FROM albums WHERE albums.album_id = NEW.album_id)
        WHERE song_id = NEW.song_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddTrack(A INT(10), S INT(10))
BEGIN
IF (SELECT EXISTS(SELECT album_id FROM albums WHERE album_id = A))
	AND (SELECT EXISTS(SELECT song_id FROM songs WHERE song_id = S))
THEN
	INSERT INTO song_album(song_id, album_id, track_no)
    	SELECT S, A, (SELECT MAX(track_no) + 1 FROM song_album WHERE album_id = A);
END IF;
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION GetTrackList(A INT)
RETURNS VARCHAR(250) DETERMINISTIC
BEGIN
DECLARE Track_List VARCHAR(250) DEFAULT"";
SELECT GROUP_CONCAT(song_name SEPARATOR ', ') INTO Track_List
FROM songs INNER JOIN song_album USING (song_id)
WHERE album_id = A
ORDER BY track_no;
RETURN Track_List;
END //
DELIMITER ;