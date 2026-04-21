WITH neighborhoods AS (
    SELECT DISTINCT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        neighborhood,
        district
    FROM berlin_source_data.neighborhoods
),

atms AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS atm_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(accessibility::text, '')) = 'accessible'
        ) AS atm_accessible_count
    FROM berlin_source_data.atms
    GROUP BY 1
),

bakeries AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS bakery_count
    FROM berlin_source_data.bakeries
    GROUP BY 1
),

banks AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS bank_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) IN ('true', 'yes')
        ) AS bank_accessible_count
    FROM berlin_source_data.banks
    GROUP BY 1
),

bike_lanes AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        SUM(COALESCE(length_m, 0)) AS bike_lane_length_m
    FROM berlin_source_data.bike_lanes
    GROUP BY 1
),

bouldering_spots AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS bouldering_spot_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(accessibility::text, '')) = 'wheelchair accessible'
        ) AS bouldering_accessible_count
    FROM berlin_source_data.bouldering_spots
    GROUP BY 1
),

bus_stops AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS bus_stop_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) IN ('true', 'yes')
        ) AS bus_stop_accessible_count
    FROM berlin_source_data.bus_stops
    GROUP BY 1
),

dental_offices AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS dental_office_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(accessibility::text, '')) LIKE '%wheelchair: yes%'
        ) AS dental_office_accessible_count
    FROM berlin_source_data.dental_offices
    GROUP BY 1
),

diplomatic_missions AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS diplomatic_mission_count
    FROM berlin_source_data.diplomatic_missions
    GROUP BY 1
),

doctors AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS doctor_count
    FROM berlin_source_data.doctors
    GROUP BY 1
),

emergency_stations AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS emergency_station_count,
        COUNT(*) FILTER (WHERE LOWER(COALESCE(station_type::text, '')) = 'police') AS police_station_count,
        COUNT(*) FILTER (WHERE LOWER(COALESCE(station_type::text, '')) = 'fire') AS fire_station_count
    FROM berlin_source_data.emergency_stations
    GROUP BY 1
),

exhibition_centers AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS exhibition_center_count
    FROM berlin_source_data.exhibition_centers
    GROUP BY 1
),

food_markets AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS food_market_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(accessibility::text, '')) = 'ja'
        ) AS food_market_accessible_count
    FROM berlin_source_data.food_markets
    GROUP BY 1
),

galleries AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS gallery_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) = 'yes'
        ) AS gallery_accessible_count
    FROM berlin_source_data.galleries
    GROUP BY 1
),

gas_stations AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS gas_station_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(fuel_electricity::text, '')) = 'yes'
        ) AS gas_station_electric_count
    FROM berlin_source_data.gas_stations
    GROUP BY 1
),

government_offices AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS government_office_count
    FROM berlin_source_data.government_offices
    GROUP BY 1
),

hospitals AS (
    SELECT
        n.neighborhood_id,
        COUNT(h.*) AS hospital_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(h.wheelchair::text, '')) IN ('true', 'yes')
        ) AS hospital_accessible_count
    FROM berlin_source_data.hospitals h
    JOIN neighborhoods n
      ON LOWER(TRIM(h.neighborhood)) = LOWER(TRIM(n.neighborhood))
    GROUP BY 1
),

hotels AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS hotel_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(accessibility::text, '')) = 'wheelchair access'
        ) AS hotel_accessible_count
    FROM berlin_source_data.hotels
    GROUP BY 1
),

kindergartens AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS kindergarten_count,
        SUM(COALESCE(capacity, 0)) AS kindergarten_capacity
    FROM berlin_source_data.kindergartens
    GROUP BY 1
),

libraries AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS library_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_accessible::text, '')) = 'yes'
        ) AS library_accessible_count
    FROM berlin_source_data.libraries
    GROUP BY 1
),

long_term_listings AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS long_term_listing_count,
        AVG(price_euro) AS long_term_avg_price_euro
    FROM berlin_source_data.long_term_listings
    GROUP BY 1
),

malls AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS mall_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) = 'yes'
        ) AS mall_accessible_count
    FROM berlin_source_data.malls
    GROUP BY 1
),

milieuschutz AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        SUM(COALESCE(area_ha, 0)) AS milieuschutz_area_ha
    FROM berlin_source_data.milieuschutz_protection_zones
    GROUP BY 1
),

museums AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS museum_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) = 'yes'
        ) AS museum_accessible_count
    FROM berlin_source_data.museums
    GROUP BY 1
),

night_clubs AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS night_club_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) = 'yes'
        ) AS night_club_accessible_count
    FROM berlin_source_data.night_clubs
    GROUP BY 1
),

parking_spaces AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS parking_space_count,
        SUM(COALESCE(capacity, 0)) AS parking_capacity,
        SUM(COALESCE(capacity_disabled, 0)) AS parking_disabled_capacity
    FROM berlin_source_data.parking_spaces
    GROUP BY 1
),

parks AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        SUM(COALESCE(area_sq_m, 0)) AS park_area_sq_m
    FROM berlin_source_data.parks
    GROUP BY 1
),

petstores AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS petstore_count
    FROM berlin_source_data.petstores
    GROUP BY 1
),

pharmacies AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS pharmacy_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_accessible::text, '')) = 'yes'
        ) AS pharmacy_accessible_count
    FROM berlin_source_data.pharmacies
    GROUP BY 1
),

playgrounds AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        SUM(COALESCE(area_sq_m, 0)) AS playground_area_sq_m
    FROM berlin_source_data.playgrounds
    GROUP BY 1
),

pools AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS pool_count
    FROM berlin_source_data.pools
    GROUP BY 1
),

public_artworks AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS public_artwork_count
    FROM berlin_source_data.public_artworks
    GROUP BY 1
),

recycling_points AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS recycling_point_count
    FROM berlin_source_data.recycling_points
    GROUP BY 1
),

religious_institutions AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS religious_institution_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_accessible::text, '')) = 'yes'
        ) AS religious_institution_accessible_count
    FROM berlin_source_data.religious_institutions
    GROUP BY 1
),

research_institutes AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS research_institute_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) = 'yes'
        ) AS research_institute_accessible_count
    FROM berlin_source_data.research_institutes
    GROUP BY 1
),

schools AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS school_count
    FROM berlin_source_data.schools
    GROUP BY 1
),

short_term_listings AS (
    SELECT
        n.neighborhood_id,
        COUNT(st.*) AS short_term_listing_count
    FROM berlin_source_data.short_term_listings st
    JOIN neighborhoods n
      ON LOWER(TRIM(st.neighborhood)) = LOWER(TRIM(n.neighborhood))
    GROUP BY 1
),

social_clubs AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS social_club_count
    FROM berlin_source_data.social_clubs_activities
    GROUP BY 1
),

spaetis AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS spaeti_count
    FROM berlin_source_data.spaetis
    GROUP BY 1
),

supermarkets AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS supermarket_count
    FROM berlin_source_data.supermarkets
    GROUP BY 1
),

theaters AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS theater_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair::text, '')) = 'yes'
        ) AS theater_accessible_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(place_type::text, '')) = 'cinema'
        ) AS cinema_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(place_type::text, '')) = 'theater'
        ) AS stage_theater_count
    FROM berlin_source_data.theaters
    GROUP BY 1
),

tram_stops AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS tram_stop_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) IN ('true', 'yes')
        ) AS tram_stop_accessible_count
    FROM berlin_source_data.tram_stops
    GROUP BY 1
),

transport_station_entrances AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS transport_station_entrance_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) = 'yes'
        ) AS transport_station_entrance_accessible_count
    FROM berlin_source_data.transport_station_entrances
    GROUP BY 1
),

transport_stations AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS transport_station_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) = 'yes'
        ) AS transport_station_accessible_count
    FROM berlin_source_data.transport_stations
    GROUP BY 1
),

universities AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS university_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) = 'yes'
        ) AS university_accessible_count
    FROM berlin_source_data.universities
    GROUP BY 1
),

venues AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS venue_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_accessible::text, '')) = 'yes'
        ) AS venue_accessible_count
    FROM berlin_source_data.venues
    GROUP BY 1
),

veterinary_clinics AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS veterinary_clinic_count
    FROM berlin_source_data.veterinary_clinics
    GROUP BY 1
),

vocational_schools AS (
    SELECT
        LPAD(neighborhood_id::text, 4, '0') AS neighborhood_id,
        COUNT(*) AS vocational_school_count,
        COUNT(*) FILTER (
            WHERE LOWER(COALESCE(wheelchair_access::text, '')) = 'yes'
        ) AS vocational_school_accessible_count
    FROM berlin_source_data.vocational_schools
    GROUP BY 1
)

SELECT
    n.neighborhood_id,
    n.neighborhood,
    n.district,

    COALESCE(a.atm_count, 0) AS atm_count,
    COALESCE(a.atm_accessible_count, 0) AS atm_accessible_count,

    COALESCE(bak.bakery_count, 0) AS bakery_count,

    COALESCE(b.bank_count, 0) AS bank_count,
    COALESCE(b.bank_accessible_count, 0) AS bank_accessible_count,

    COALESCE(bl.bike_lane_length_m, 0) AS bike_lane_length_m,

    COALESCE(bs.bouldering_spot_count, 0) AS bouldering_spot_count,
    COALESCE(bs.bouldering_accessible_count, 0) AS bouldering_accessible_count,

    COALESCE(bus.bus_stop_count, 0) AS bus_stop_count,
    COALESCE(bus.bus_stop_accessible_count, 0) AS bus_stop_accessible_count,

    COALESCE(dent.dental_office_count, 0) AS dental_office_count,
    COALESCE(dent.dental_office_accessible_count, 0) AS dental_office_accessible_count,

    COALESCE(dm.diplomatic_mission_count, 0) AS diplomatic_mission_count,

    COALESCE(doc.doctor_count, 0) AS doctor_count,

    COALESCE(es.emergency_station_count, 0) AS emergency_station_count,
    COALESCE(es.police_station_count, 0) AS police_station_count,
    COALESCE(es.fire_station_count, 0) AS fire_station_count,

    COALESCE(ex.exhibition_center_count, 0) AS exhibition_center_count,

    COALESCE(fm.food_market_count, 0) AS food_market_count,
    COALESCE(fm.food_market_accessible_count, 0) AS food_market_accessible_count,

    COALESCE(gal.gallery_count, 0) AS gallery_count,
    COALESCE(gal.gallery_accessible_count, 0) AS gallery_accessible_count,

    COALESCE(gs.gas_station_count, 0) AS gas_station_count,
    COALESCE(gs.gas_station_electric_count, 0) AS gas_station_electric_count,

    COALESCE(go.government_office_count, 0) AS government_office_count,

    COALESCE(h.hospital_count, 0) AS hospital_count,
    COALESCE(h.hospital_accessible_count, 0) AS hospital_accessible_count,

    COALESCE(ho.hotel_count, 0) AS hotel_count,
    COALESCE(ho.hotel_accessible_count, 0) AS hotel_accessible_count,

    COALESCE(kg.kindergarten_count, 0) AS kindergarten_count,
    COALESCE(kg.kindergarten_capacity, 0) AS kindergarten_capacity,

    COALESCE(lib.library_count, 0) AS library_count,
    COALESCE(lib.library_accessible_count, 0) AS library_accessible_count,

    COALESCE(lt.long_term_listing_count, 0) AS long_term_listing_count,
    lt.long_term_avg_price_euro,

    COALESCE(ma.mall_count, 0) AS mall_count,
    COALESCE(ma.mall_accessible_count, 0) AS mall_accessible_count,

    COALESCE(ms.milieuschutz_area_ha, 0) AS milieuschutz_area_ha,

    COALESCE(mu.museum_count, 0) AS museum_count,
    COALESCE(mu.museum_accessible_count, 0) AS museum_accessible_count,

    COALESCE(nc.night_club_count, 0) AS night_club_count,
    COALESCE(nc.night_club_accessible_count, 0) AS night_club_accessible_count,

    COALESCE(ps.parking_space_count, 0) AS parking_space_count,
    COALESCE(ps.parking_capacity, 0) AS parking_capacity,
    COALESCE(ps.parking_disabled_capacity, 0) AS parking_disabled_capacity,

    COALESCE(pk.park_area_sq_m, 0) AS park_area_sq_m,

    COALESCE(pt.petstore_count, 0) AS petstore_count,

    COALESCE(ph.pharmacy_count, 0) AS pharmacy_count,
    COALESCE(ph.pharmacy_accessible_count, 0) AS pharmacy_accessible_count,

    COALESCE(pg.playground_area_sq_m, 0) AS playground_area_sq_m,

    COALESCE(po.pool_count, 0) AS pool_count,

    COALESCE(pa.public_artwork_count, 0) AS public_artwork_count,

    COALESCE(rp.recycling_point_count, 0) AS recycling_point_count,

    COALESCE(ri.religious_institution_count, 0) AS religious_institution_count,
    COALESCE(ri.religious_institution_accessible_count, 0) AS religious_institution_accessible_count,

    COALESCE(rins.research_institute_count, 0) AS research_institute_count,
    COALESCE(rins.research_institute_accessible_count, 0) AS research_institute_accessible_count,

    COALESCE(sc.school_count, 0) AS school_count,

    COALESCE(st.short_term_listing_count, 0) AS short_term_listing_count,

    COALESCE(scl.social_club_count, 0) AS social_club_count,

    COALESCE(sp.spaeti_count, 0) AS spaeti_count,

    COALESCE(sm.supermarket_count, 0) AS supermarket_count,

    COALESCE(th.theater_count, 0) AS theater_count,
    COALESCE(th.theater_accessible_count, 0) AS theater_accessible_count,
    COALESCE(th.cinema_count, 0) AS cinema_count,
    COALESCE(th.stage_theater_count, 0) AS stage_theater_count,

    COALESCE(ts.tram_stop_count, 0) AS tram_stop_count,
    COALESCE(ts.tram_stop_accessible_count, 0) AS tram_stop_accessible_count,

    COALESCE(tse.transport_station_entrance_count, 0) AS transport_station_entrance_count,
    COALESCE(tse.transport_station_entrance_accessible_count, 0) AS transport_station_entrance_accessible_count,

    COALESCE(tst.transport_station_count, 0) AS transport_station_count,
    COALESCE(tst.transport_station_accessible_count, 0) AS transport_station_accessible_count,

    COALESCE(u.university_count, 0) AS university_count,
    COALESCE(u.university_accessible_count, 0) AS university_accessible_count,

    COALESCE(v.venue_count, 0) AS venue_count,
    COALESCE(v.venue_accessible_count, 0) AS venue_accessible_count,

    COALESCE(vc.veterinary_clinic_count, 0) AS veterinary_clinic_count,

    COALESCE(vs.vocational_school_count, 0) AS vocational_school_count,
    COALESCE(vs.vocational_school_accessible_count, 0) AS vocational_school_accessible_count

FROM neighborhoods n
LEFT JOIN atms a ON n.neighborhood_id = a.neighborhood_id
LEFT JOIN bakeries bak ON n.neighborhood_id = bak.neighborhood_id
LEFT JOIN banks b ON n.neighborhood_id = b.neighborhood_id
LEFT JOIN bike_lanes bl ON n.neighborhood_id = bl.neighborhood_id
LEFT JOIN bouldering_spots bs ON n.neighborhood_id = bs.neighborhood_id
LEFT JOIN bus_stops bus ON n.neighborhood_id = bus.neighborhood_id
LEFT JOIN dental_offices dent ON n.neighborhood_id = dent.neighborhood_id
LEFT JOIN diplomatic_missions dm ON n.neighborhood_id = dm.neighborhood_id
LEFT JOIN doctors doc ON n.neighborhood_id = doc.neighborhood_id
LEFT JOIN emergency_stations es ON n.neighborhood_id = es.neighborhood_id
LEFT JOIN exhibition_centers ex ON n.neighborhood_id = ex.neighborhood_id
LEFT JOIN food_markets fm ON n.neighborhood_id = fm.neighborhood_id
LEFT JOIN galleries gal ON n.neighborhood_id = gal.neighborhood_id
LEFT JOIN gas_stations gs ON n.neighborhood_id = gs.neighborhood_id
LEFT JOIN government_offices go ON n.neighborhood_id = go.neighborhood_id
LEFT JOIN hospitals h ON n.neighborhood_id = h.neighborhood_id
LEFT JOIN hotels ho ON n.neighborhood_id = ho.neighborhood_id
LEFT JOIN kindergartens kg ON n.neighborhood_id = kg.neighborhood_id
LEFT JOIN libraries lib ON n.neighborhood_id = lib.neighborhood_id
LEFT JOIN long_term_listings lt ON n.neighborhood_id = lt.neighborhood_id
LEFT JOIN malls ma ON n.neighborhood_id = ma.neighborhood_id
LEFT JOIN milieuschutz ms ON n.neighborhood_id = ms.neighborhood_id
LEFT JOIN museums mu ON n.neighborhood_id = mu.neighborhood_id
LEFT JOIN night_clubs nc ON n.neighborhood_id = nc.neighborhood_id
LEFT JOIN parking_spaces ps ON n.neighborhood_id = ps.neighborhood_id
LEFT JOIN parks pk ON n.neighborhood_id = pk.neighborhood_id
LEFT JOIN petstores pt ON n.neighborhood_id = pt.neighborhood_id
LEFT JOIN pharmacies ph ON n.neighborhood_id = ph.neighborhood_id
LEFT JOIN playgrounds pg ON n.neighborhood_id = pg.neighborhood_id
LEFT JOIN pools po ON n.neighborhood_id = po.neighborhood_id
LEFT JOIN public_artworks pa ON n.neighborhood_id = pa.neighborhood_id
LEFT JOIN recycling_points rp ON n.neighborhood_id = rp.neighborhood_id
LEFT JOIN religious_institutions ri ON n.neighborhood_id = ri.neighborhood_id
LEFT JOIN research_institutes rins ON n.neighborhood_id = rins.neighborhood_id
LEFT JOIN schools sc ON n.neighborhood_id = sc.neighborhood_id
LEFT JOIN short_term_listings st ON n.neighborhood_id = st.neighborhood_id
LEFT JOIN social_clubs scl ON n.neighborhood_id = scl.neighborhood_id
LEFT JOIN spaetis sp ON n.neighborhood_id = sp.neighborhood_id
LEFT JOIN supermarkets sm ON n.neighborhood_id = sm.neighborhood_id
LEFT JOIN theaters th ON n.neighborhood_id = th.neighborhood_id
LEFT JOIN tram_stops ts ON n.neighborhood_id = ts.neighborhood_id
LEFT JOIN transport_station_entrances tse ON n.neighborhood_id = tse.neighborhood_id
LEFT JOIN transport_stations tst ON n.neighborhood_id = tst.neighborhood_id
LEFT JOIN universities u ON n.neighborhood_id = u.neighborhood_id
LEFT JOIN venues v ON n.neighborhood_id = v.neighborhood_id
LEFT JOIN veterinary_clinics vc ON n.neighborhood_id = vc.neighborhood_id
LEFT JOIN vocational_schools vs ON n.neighborhood_id = vs.neighborhood_id
ORDER BY n.district, n.neighborhood;