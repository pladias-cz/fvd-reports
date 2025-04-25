SELECT s.code as square,
       (SELECT count(*)
        FROM atlas.records rec
        WHERE rec.validation_status IN (0, 4)
          AND ST_Intersects(rec.coords_wgs, s.geom_wgs))  as pladias_1,
       (SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs)) as gbif_1,
       (SELECT count(DISTINCT rec.taxon_id)
        FROM atlas.records rec
        WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)) as pladias_2,
       (SELECT count(DISTINCT tt.pladias_taxon_id)
        FROM gbif.records gbif JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key)
        WHERE ST_Intersects(gbif.coords, s.geom_wgs)) as gbif_2,
       (SELECT count(*) FROM atlas.records rec WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs) AND EXTRACT(YEAR FROM datum) > 1999) as pladias_3_2000,
       (SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND year > 1999) as gbif_3_2000,
       (SELECT count(*) FROM atlas.records rec WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs) AND EXTRACT(YEAR FROM datum) > 2009) as pladias_3_2010,
       (SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND year > 2009) as gbif_3_2010,
       (SELECT count(DISTINCT rec.taxon_id)
        FROM atlas.records rec
        WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)  AND EXTRACT(YEAR FROM datum) > 1999) as pladias_4_2000,
       (SELECT count(DISTINCT tt.pladias_taxon_id)
        FROM gbif.records gbif JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key)
        WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND gbif.year > 1999) as gbif_4_2000,
       (SELECT count(DISTINCT rec.taxon_id)
        FROM atlas.records rec
        WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)  AND EXTRACT(YEAR FROM datum) > 2009) as pladias_4_2010,
       (SELECT count(DISTINCT tt.pladias_taxon_id)
        FROM gbif.records gbif JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key)
        WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND gbif.year > 2009) as gbif_4_2010
FROM geodata.squares_full s
         JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square