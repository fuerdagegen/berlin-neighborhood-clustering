WITH neighborhood_centroids AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        neighborhood,
        district,
        ST_Transform(
            ST_Centroid(
                ST_SetSRID(
                    ST_GeomFromWKB(decode(geometry, 'hex')),
                    4326
                )
            ),
            25833
        ) AS centroid_geom
    FROM berlin_source_data.neighborhoods
    WHERE geometry IS NOT NULL
),

atm_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.atms
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

bakery_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.bakeries
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

bus_stop_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.bus_stops
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

dental_office_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.dental_offices
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

doctor_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.doctors
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

hospital_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.hospitals
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

kindergarten_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.kindergartens
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

park_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.parks
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

pharmacy_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.pharmacies
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

playground_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.playgrounds
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

school_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.schools
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

spaeti_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.spaetis
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

supermarket_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.supermarkets
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

tram_stop_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.tram_stops
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

transport_station_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.transport_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

bank_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.banks
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

emergency_station_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.emergency_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

fire_station_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.emergency_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
      AND LOWER(COALESCE(station_type, '')) = 'fire'
),

food_market_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.food_markets
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

gas_station_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.gas_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

gas_station_electric_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.gas_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
      AND LOWER(COALESCE(fuel_electricity, '')) = 'yes'
),

government_office_points AS (
    SELECT
        ST_Transform(
            ST_SetSRID(
                ST_GeomFromWKB(decode(geometry, 'hex')),
                4326
            ),
            25833
        ) AS geom
    FROM berlin_source_data.government_offices
    WHERE geometry IS NOT NULL
),

library_points AS (
    SELECT
        ST_Transform(
            ST_SetSRID(
                ST_GeomFromWKB(decode(geometry, 'hex')),
                4326
            ),
            25833
        ) AS geom
    FROM berlin_source_data.libraries
    WHERE geometry IS NOT NULL
),

mall_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.malls
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

petstore_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.petstores
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

police_station_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.emergency_stations
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
      AND LOWER(COALESCE(station_type, '')) = 'police'
),

pool_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.pools
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

recycling_point_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.recycling_points
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

transport_station_entrance_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.transport_station_entrances
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

veterinary_clinic_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.veterinary_clinics
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

vocational_school_points AS (
    SELECT ST_Transform(ST_SetSRID(ST_GeomFromText(geometry), 4326), 25833) AS geom
    FROM berlin_source_data.vocational_schools
    WHERE geometry IS NOT NULL
      AND TRIM(geometry) ~* '^POINT\s*\('
),

atm_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_atm_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM atm_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

bakery_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_bakery_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM bakery_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

bus_stop_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_bus_stop_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM bus_stop_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

dental_office_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_dental_office_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM dental_office_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

doctor_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_doctor_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM doctor_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

hospital_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS dist_1_hospital_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM hospital_points ORDER BY n.centroid_geom <-> geom LIMIT 1
    ) p
    GROUP BY n.neighborhood_id
),

kindergarten_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_kindergarten_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM kindergarten_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

park_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_park_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM park_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

pharmacy_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_pharmacy_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM pharmacy_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

playground_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_playground_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM playground_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

school_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_school_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM school_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

spaeti_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_spaeti_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM spaeti_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

supermarket_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_supermarket_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM supermarket_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

tram_stop_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_tram_stop_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM tram_stop_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

transport_station_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_5_transport_station_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM transport_station_points ORDER BY n.centroid_geom <-> geom LIMIT 5
    ) p
    GROUP BY n.neighborhood_id
),

bank_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_bank_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM bank_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

emergency_station_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS dist_1_emergency_station_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM emergency_station_points ORDER BY n.centroid_geom <-> geom LIMIT 1
    ) p
    GROUP BY n.neighborhood_id
),

fire_station_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS dist_1_fire_station_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM fire_station_points ORDER BY n.centroid_geom <-> geom LIMIT 1
    ) p
    GROUP BY n.neighborhood_id
),

food_market_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_food_market_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM food_market_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

gas_station_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_gas_station_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM gas_station_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

gas_station_electric_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_gas_station_electric_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM gas_station_electric_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

government_office_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_government_office_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM government_office_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

library_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_library_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM library_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

mall_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_mall_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM mall_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

petstore_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_petstore_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM petstore_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

police_station_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS dist_1_police_station_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM police_station_points ORDER BY n.centroid_geom <-> geom LIMIT 1
    ) p
    GROUP BY n.neighborhood_id
),

pool_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_pool_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM pool_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

recycling_point_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_recycling_point_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM recycling_point_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

transport_station_entrance_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_transport_station_entrance_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM transport_station_entrance_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

veterinary_clinic_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_veterinary_clinic_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM veterinary_clinic_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
),

vocational_school_distances AS (
    SELECT n.neighborhood_id, AVG(ST_Distance(n.centroid_geom, p.geom)) AS avg_dist_3_vocational_school_m
    FROM neighborhood_centroids n
    CROSS JOIN LATERAL (
        SELECT geom FROM vocational_school_points ORDER BY n.centroid_geom <-> geom LIMIT 3
    ) p
    GROUP BY n.neighborhood_id
)

SELECT
    n.neighborhood_id,
    n.neighborhood,
    n.district,

    ad.avg_dist_5_atm_m,
    bd.avg_dist_5_bakery_m,
    bsd.avg_dist_5_bus_stop_m,
    dod.avg_dist_3_dental_office_m,
    dd.avg_dist_3_doctor_m,
    hd.dist_1_hospital_m,
    kd.avg_dist_3_kindergarten_m,
    pkd.avg_dist_3_park_m,
    pd.avg_dist_5_pharmacy_m,
    pgd.avg_dist_3_playground_m,
    scd.avg_dist_3_school_m,
    spd.avg_dist_5_spaeti_m,
    sd.avg_dist_5_supermarket_m,
    trd.avg_dist_5_tram_stop_m,
    tsd.avg_dist_5_transport_station_m,
    bad.avg_dist_3_bank_m,
    esd.dist_1_emergency_station_m,
    fsd.dist_1_fire_station_m,
    fmd.avg_dist_3_food_market_m,
    gsd.avg_dist_3_gas_station_m,
    gsed.avg_dist_3_gas_station_electric_m,
    god.avg_dist_3_government_office_m,
    ld.avg_dist_3_library_m,
    md.avg_dist_3_mall_m,
    ped.avg_dist_3_petstore_m,
    psd.dist_1_police_station_m,
    pld.avg_dist_3_pool_m,
    rpd.avg_dist_3_recycling_point_m,
    tsed.avg_dist_3_transport_station_entrance_m,
    vcd.avg_dist_3_veterinary_clinic_m,
    vsd.avg_dist_3_vocational_school_m

FROM neighborhood_centroids n
LEFT JOIN atm_distances ad ON n.neighborhood_id = ad.neighborhood_id
LEFT JOIN bakery_distances bd ON n.neighborhood_id = bd.neighborhood_id
LEFT JOIN bus_stop_distances bsd ON n.neighborhood_id = bsd.neighborhood_id
LEFT JOIN dental_office_distances dod ON n.neighborhood_id = dod.neighborhood_id
LEFT JOIN doctor_distances dd ON n.neighborhood_id = dd.neighborhood_id
LEFT JOIN hospital_distances hd ON n.neighborhood_id = hd.neighborhood_id
LEFT JOIN kindergarten_distances kd ON n.neighborhood_id = kd.neighborhood_id
LEFT JOIN park_distances pkd ON n.neighborhood_id = pkd.neighborhood_id
LEFT JOIN pharmacy_distances pd ON n.neighborhood_id = pd.neighborhood_id
LEFT JOIN playground_distances pgd ON n.neighborhood_id = pgd.neighborhood_id
LEFT JOIN school_distances scd ON n.neighborhood_id = scd.neighborhood_id
LEFT JOIN spaeti_distances spd ON n.neighborhood_id = spd.neighborhood_id
LEFT JOIN supermarket_distances sd ON n.neighborhood_id = sd.neighborhood_id
LEFT JOIN tram_stop_distances trd ON n.neighborhood_id = trd.neighborhood_id
LEFT JOIN transport_station_distances tsd ON n.neighborhood_id = tsd.neighborhood_id
LEFT JOIN bank_distances bad ON n.neighborhood_id = bad.neighborhood_id
LEFT JOIN emergency_station_distances esd ON n.neighborhood_id = esd.neighborhood_id
LEFT JOIN fire_station_distances fsd ON n.neighborhood_id = fsd.neighborhood_id
LEFT JOIN food_market_distances fmd ON n.neighborhood_id = fmd.neighborhood_id
LEFT JOIN gas_station_distances gsd ON n.neighborhood_id = gsd.neighborhood_id
LEFT JOIN gas_station_electric_distances gsed ON n.neighborhood_id = gsed.neighborhood_id
LEFT JOIN government_office_distances god ON n.neighborhood_id = god.neighborhood_id
LEFT JOIN library_distances ld ON n.neighborhood_id = ld.neighborhood_id
LEFT JOIN mall_distances md ON n.neighborhood_id = md.neighborhood_id
LEFT JOIN petstore_distances ped ON n.neighborhood_id = ped.neighborhood_id
LEFT JOIN police_station_distances psd ON n.neighborhood_id = psd.neighborhood_id
LEFT JOIN pool_distances pld ON n.neighborhood_id = pld.neighborhood_id
LEFT JOIN recycling_point_distances rpd ON n.neighborhood_id = rpd.neighborhood_id
LEFT JOIN transport_station_entrance_distances tsed ON n.neighborhood_id = tsed.neighborhood_id
LEFT JOIN veterinary_clinic_distances vcd ON n.neighborhood_id = vcd.neighborhood_id
LEFT JOIN vocational_school_distances vsd ON n.neighborhood_id = vsd.neighborhood_id

ORDER BY n.neighborhood_id;