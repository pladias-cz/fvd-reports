# fvd-reports
Shiny reports for FVD project researchers


1) kolik je udaju na ctverec celkem v celem uzemi
```sql
select 
	s.code as square, 
	(SELECT count(*) FROM atlas.records rec WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)) as pladias_records,
	(SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs)) as gbif_records 
	
from geodata.squares_full s 
JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square

```
2) kolik je taxonu na ctverec celkem v celem uzemi
```sql
select 
	s.code as square, 
	(SELECT count(DISTINCT rec.taxon_id) 
		FROM atlas.records rec 
		WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)) as taxa_from_pladias,
	(SELECT count(DISTINCT tt.pladias_taxon_id) 
		FROM gbif.records gbif JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key) 
		WHERE ST_Intersects(gbif.coords, s.geom_wgs)) as taxa_from_gbif
from geodata.squares_full s 
JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square

```
3) kolik je udaju na ctverec celkem od roku 2000 do 2025(2010-2025) v celem uzemi
```sql
select 
	s.code as square, 
	(SELECT count(*) FROM atlas.records rec WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs) AND EXTRACT(YEAR FROM datum) > 2009) as pladias_records,
	(SELECT count(*) FROM gbif.records gbif WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND year > 2009) as gbif_records 
	
from geodata.squares_full s 
JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square

```
4) kolik je taxonů na čtverec celkem od roku 2000 do 2025(2010-2025) v celem uzemi
```sql
select 
	s.code as square, 
	(SELECT count(DISTINCT rec.taxon_id) 
		FROM atlas.records rec 
		WHERE rec.validation_status IN (0,4) AND ST_Intersects(rec.coords_wgs, s.geom_wgs)  AND EXTRACT(YEAR FROM datum) > 2009) as taxa_from_pladias,
	(SELECT count(DISTINCT tt.pladias_taxon_id) 
		FROM gbif.records gbif JOIN gbif.taxa tt ON (tt.taxon_key = gbif.taxon_key) 
		WHERE ST_Intersects(gbif.coords, s.geom_wgs) AND gbif.year > 2009) as taxa_from_gbif
from geodata.squares_full s 
JOIN geodata.regions r ON (ST_Intersects(r.geom, s.geom_wgs))

WHERE r.id = 3
ORDER BY square
```
