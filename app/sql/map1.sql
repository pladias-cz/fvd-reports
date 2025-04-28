SELECT ST_AsText(geom) as wkt_geom,
       (total - pladias_2) AS pocet
FROM (SELECT s.geom_wgs                                                as geom,
             --Q2 Pladias
             (SELECT count(DISTINCT rec.taxon_id)
              FROM atlas.records rec
              WHERE rec.validation_status IN (0, 4)
                AND ST_Intersects(rec.coords_wgs, s.geom_wgs))         as pladias_2,

             --Q2 union, that is unique taxa across both sources
             (SELECT count(DISTINCT tt.pladias_taxon_id)
              FROM gbif.records gbif
                       JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key)
              WHERE ST_Intersects(gbif.coords, s.geom_wgs))            as gbif_2,

             (SELECT COUNT(*) AS total_unique_taxa
              FROM (SELECT rec.taxon_id AS taxon
                    FROM atlas.records rec
                    WHERE rec.validation_status IN (0, 4)
                      AND ST_Intersects(rec.coords_wgs, s.geom_wgs)

                    UNION

                    SELECT tt.pladias_taxon_id
                    FROM gbif.records gbif
                             JOIN gbif.taxa tt ON tt.taxon_key = gbif.taxon_key
                    WHERE ST_Intersects(gbif.coords, s.geom_wgs)) sub) as total

      FROM geodata.quadrants_full s
               JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

      WHERE r.id = 3) subquery