select
    s.code as square,
    (SELECT count(*) FROM atlas.records rec WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)) as pladias_records,
    (SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs)) as gbif_records

from geodata.squares_full s
         JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square