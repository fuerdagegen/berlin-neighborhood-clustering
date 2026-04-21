# Berlin neighborhood clustering

## TL;DR

This project builds a geospatial pipeline for feature engineering and clustering to uncover latent neighborhood structure in Berlin.

It shows that urban similarity is not fixed, but depends on user preferences.

Using spatial features, accessibility metrics, and feature weighting, the analysis identifies:

- a baseline structure of central, intermediate, and peripheral neighborhoods
- nightlife as a dominant structural signal
- transport as a reinforcing accessibility gradient
- family-related features as a filter rather than a driver

The pipeline extends clustering toward **preference-aware neighborhood similarity**, combining:

- feature engineering from raw geospatial data
- unsupervised learning (K-means, PCA)
- user-intent weighting across feature groups

Clustering and preference logic are partially modularized into reusable Python modules for experimentation and reuse.

---

## Key findings

![Berlin neighborhood clusters](assets/kmeans_clusters_map.png)

The analysis reveals a clear and interpretable structure in Berlin’s neighborhood space:

- baseline clustering (k = 3) separates central, intermediate, and peripheral neighborhoods  
- nightlife is the strongest structural signal, isolating a compact urban core  
- transport reinforces an existing accessibility gradient rather than reshaping it  
- family-related features act as a filter rather than a primary segmentation axis  
- combined user preferences produce realistic, multi-criteria neighborhood groupings  

These results show how clustering can move from exploratory analysis toward **preference-aware neighborhood recommendation**.

---

## Example outputs

### PCA projection of neighborhood feature space

![PCA projection](assets/pca_projection.png)

The PCA projection shows clear separation between clusters, confirming that the feature space captures meaningful differences in neighborhood structure.

---

### Silhouette analysis

![Silhouette plot](assets/silhouette_plot.png)

The silhouette plot confirms good separation for the k = 3 solution, with most neighborhoods forming well-defined clusters.

---

## Project structure

The repository is structured to separate data extraction, feature engineering, exploratory analysis, and reusable modeling logic.

```text
berlin-neighborhood-clustering/
│
├── assets/
│   ├── kmeans_clusters_map.png
│   ├── pca_projection.png
│   └── silhouette_plot.png
│
├── data/
│   ├── neighborhood_features_clustered.csv
│   ├── neighborhood_features_counts.csv
│   ├── neighborhood_features_exploration.csv
│   └── population_data.csv
│
├── notebooks/
│   ├── 01_data_exploration.ipynb
│   └── 02_neighborhood_clustering_analysis.ipynb
│
├── sql/
│   ├── create_neighborhood_amenity_counts.sql
│   └── create_neighborhood_proximity_features.sql
│
├── src/
│   ├── __init__.py
│   ├── clustering.py
│   ├── weighting.py
│   └── scoring.py
│
├── .gitignore
└── README.md
```

---

### Folder overview

#### data/

Contains intermediate and final feature tables used for modeling.

- `neighborhood_features_counts.csv`  
  raw neighborhood-level amenity counts  

- `neighborhood_features_exploration.csv`  
  fully engineered feature table  

- `population_data.csv`  
  population data used for per-capita normalization  

---

#### notebooks/

Contains exploratory workflows, feature engineering, and clustering interpretation.

- `01_data_exploration.ipynb`  
  - loads SQL outputs  
  - performs feature engineering and normalization  
  - explores correlations and data quality  
  - exports the final modeling-ready feature table  

- `02_neighborhood_clustering_analysis.ipynb`  
  - performs clustering analysis (K-means, PCA)  
  - evaluates cluster quality  
  - interprets neighborhood typologies  
  - explores user-intent weighting scenarios  

The notebooks remain the primary interface for analysis and interpretation.

---

#### sql/

Contains PostGIS-based feature extraction logic.

- `create_neighborhood_amenity_counts.sql`  
  generates raw neighborhood-level amenity counts  

- `create_neighborhood_proximity_features.sql`  
  generates centroid-based proximity metrics  

---

#### src/

Contains reusable Python modules extracted from the clustering workflow.

This folder separates stable, reusable logic from notebook-based experimentation.

- `clustering.py`  
  K-means evaluation, clustering diagnostics, and interpretation helpers  

- `weighting.py`  
  feature weighting, sensitivity analysis, and weighted clustering workflows  

- `scoring.py`  
  preference-based scoring and cluster ranking  

---

Feature engineering logic is intentionally **not** included in `src/`.

Transformations depend on feature-specific semantic decisions, such as:

- raw counts vs normalized features  
- spatial density (`per sq km`)  
- population-normalized density (`per 1,000`)  
- area share  
- centroid-based proximity (with varying k)  

These decisions are explored and validated in the notebooks rather than abstracted into a generic pipeline.

Future iterations may formalize this layer once transformation rules stabilize.

---

## How to reproduce the analysis

This project relies on internal geospatial source tables (`berlin_source_data`) used for feature generation.

Since these raw layers are not publicly available, the full SQL pipeline cannot be executed outside the original environment.

However, the project remains fully reproducible from the feature engineering stage onward.

This separation reflects a common real-world setup where raw data pipelines are not publicly shareable, but modeling layers remain portable and reproducible.

To reproduce the analysis:

1. load the prepared dataset  
   `data/neighborhood_features_exploration.csv`

2. run the clustering workflow  
   `notebooks/02_neighborhood_clustering_analysis.ipynb`

This includes:

- K-means clustering  
- PCA projection  
- cluster evaluation  
- user-intent weighting experiments  

The provided dataset represents the complete modeling input used for all results in this repository.

---

## Project objective

The objective of this project is to engineer an interpretable neighborhood-level feature space for Berlin and use it to discover urban typologies through clustering.

The unit of analysis is the Berlin **Ortsteil** (neighborhood).

---

## Intended clustering perspectives

The engineered feature space is designed to support multiple neighborhood perspectives, including:

- **accessibility and transport**
  - public transport stops  
  - station proximity  
  - bike lane infrastructure  
  - walkable service access  

- **family and residential services**
  - kindergartens  
  - schools  
  - playgrounds  
  - parks  
  - healthcare access  

- **nightlife and social infrastructure**
  - spaetis  
  - venues  
  - social clubs  
  - theaters  
  - cinemas  
  - nightlife density  

- **culture and tourism**
  - galleries  
  - museums  
  - hotels  
  - cultural venues  
  - entertainment hubs  

- **housing and urban pressure**
  - long-term listings  
  - housing price signals  
  - milieuschutz areas  

These perspectives are embedded into the feature space so that unsupervised methods can identify latent neighborhood archetypes.

---

## Data sources

Primary source layers are stored in:

`berlin_source_data`

Additional demographic data was sourced from:

https://daten.odis-berlin.de/de/dataset/ortsteile/

For faster iteration during the proof of concept, population data was imported as a local CSV file instead of being loaded into SQL.

The file used in this project is:

```text
/data/population_data.csv
```

One data issue was identified:

- **Schlachtensee** exists as a separate neighborhood in newer administrative versions  

For speed, its population was temporarily redistributed across:

- Zehlendorf  
- Nikolassee  

This assumption should be revisited in future versions.

---

### Data availability

The raw geospatial layers used for feature generation are not included in this repository.

They originate from an internal PostGIS database and were used to build the initial feature tables.

To ensure reproducibility, all downstream analysis is based on exported datasets available in `/data/`.

This reflects a common real-world setup where raw data pipelines are not publicly shareable, while modeling layers remain portable and reproducible.

---

## Feature engineering approach

The feature space combines:

- spatial density (per sq km)  
- population-normalized density (per 1,000 residents)  
- land-use shares  
- centroid-based proximity metrics  
- accessibility ratios  

The goal is to balance interpretability and modeling readiness, ensuring features reflect meaningful urban structure rather than raw scale effects.

---

## Why raw counts are not suitable for modeling

Raw amenity counts were intentionally excluded from the final modeling features because they are structurally biased and not comparable across neighborhoods.

Absolute counts are influenced by multiple scale effects, including:

- neighborhood area  
- population size  
- degree of urbanization  

As a result, highly urban districts tend to show larger counts simply due to the concentration of amenities and activities. Larger neighborhoods may also accumulate higher counts due to their physical extent.

Raw counts therefore mix together:

- urban intensity  
- neighborhood size  
- service concentration  

This makes them unsuitable as direct clustering features, as the model would primarily separate neighborhoods by scale rather than by functional urban profile.

To ensure comparability and interpretability, count-based features were transformed into normalized representations such as:

- amenities per km²  
- amenities per 1,000 residents  
- land-use shares  
- centroid-based proximity metrics  

Raw counts were retained only for initial inspection and data quality checks.

---

## Data quality and scope decisions

Before feature engineering, all source layers were audited.

A key distinction was identified between:

- structured fields  
- noisy free-text fields  

### Included

Structured signals such as:

- counts  
- accessibility flags  
- capacities  
- areas  
- numeric attributes  
- categorical amenity types  

### Excluded

Fields such as:

- `opening_hours`  
- `operating_hours`  
- free-text descriptions  

were intentionally excluded due to inconsistency and lack of standardization.

Examples included:

- `24/7`  
- `Mo-Fr 08:00-18:00`  
- `see website`  

These fields remain strong candidates for future work on temporal and liveliness features.

---

## Feature transformations

### Spatial density

Used for point-based urban infrastructure and activity layers.

Formula:

```python
feature_per_sq_km = feature_count / area_sq_km
```

Examples:

- bus stops
- tram stops
- doctors
- supermarkets
- nightlife venues
- schools
- universities

---

### Population density

Used for resident-facing services.

Formula:

```python
feature_per_1000 = feature_count / population * 1000
```

Examples:

- kindergarten
- school
- vocational school
- kindergarten capacity
- long-term housing listings

---

### Area share

Used for land-use features.

Formula:

```python
share = feature_area / neighborhood_area
```

Examples:

- parks
- playgrounds
- milieuschutz zones

Bike lanes were approximated as:

```python
bike_lane_length_m / sq_km
```

A road-share denominator would be preferable in future versions.

---

### Accessibility ratio

A simplified accessibility score was created as:

```python
accessible amenities / total amenities
```

This is intentionally a high-level proxy.

It should not yet be interpreted as a rigorous urban accessibility index.

---

### Proximity features

For frequent-use amenities, accessibility was modeled through distance from the neighborhood centroid.

This was preferred over density alone.

Different `k` values were used depending on amenity frequency.

#### k = 1
Rare amenities:

- hospitals
- fire stations
- police stations

#### k = 3
Medium-frequency services:

- schools
- libraries
- malls
- doctors

#### k = 5
High-frequency daily services:

- bakery
- ATM
- supermarket
- spaeti
- transport stations

This was based on exploratory tests.

For bakeries, increasing `k` had little effect on compute time but increasingly diluted locality.

This led to the final heuristic:

- `1` rare
- `3` medium
- `5` frequent

---

## SQL and notebook workflow

### SQL

Two separate SQL scripts are used:

- amenity counts
- proximity features

Simpler spatial calculations such as neighborhood area are performed in Python.

---

### Intermediate outputs

Counts are stored in:

`/data/neighborhood_features_counts.csv`

Final modeling-ready table:

`/data/neighborhood_features_exploration.csv`

---

## Data issues found during exploration

Several important issues were identified.

### ID formatting

Some neighborhood IDs were stored as:

- `123`

instead of:

- `0123`

This was corrected using zero-padding.

---

### Missing data

Issues identified and corrected:

- empty vocational school table
- incomplete schools table
- NULL hospital neighborhood IDs
- missing short-term listing IDs

---

### Tram stop anomalies

Some tram stops appeared in neighborhoods without tram infrastructure.

This strongly suggested OSM labeling issues.

These records are currently being corrected.

---

### Boundary mismatch

The Schlachtensee boundary issue remains open.

Future versions should align all sources to a single boundary definition.

---

## Correlation insights

Three clear latent urban dimensions emerged.

### 1. Healthcare and daily services

Examples:

- dental offices ↔ doctors
- pharmacies ↔ supermarkets
- kindergartens ↔ pharmacies

This likely captures:

- residential density
- daily-life convenience
- family-oriented services

---

### 2. Culture and nightlife

Examples:

- theaters ↔ venues
- galleries ↔ museums
- social clubs ↔ spaetis

This captures:

- nightlife
- tourism
- culture
- evening economy

---

### 3. Accessibility and centrality

Distance correlations reveal a strong service-access dimension.

Examples:

- bakery ↔ pharmacy
- pharmacy ↔ supermarket
- spaeti ↔ transport stations

This likely separates:

- highly walkable inner districts
- moderately connected residential zones
- peripheral neighborhoods

---

## Clustering and user-intent analysis

The feature space was used to explore both:

- baseline clustering structure  
- user-intent driven similarity through feature weighting  

Baseline clustering reveals a structure driven by accessibility, service density, and urban centrality.

User-intent weighting shows that different feature groups play very different roles:

- nightlife strongly reshapes the structure  
- family mainly acts as a filter  
- transport sharpens an existing accessibility gradient  
- combined preferences produce realistic, multi-criteria neighborhood groupings

---

### Practical takeaway

Neighborhood similarity is not fixed but depends on user priorities.

- some dimensions (nightlife) create strong structural splits  
- others (family) mainly filter the existing structure  
- combined preferences produce more realistic, multi-criteria neighborhood groupings  

This shows how clustering can evolve from exploratory analysis into a foundation for user-driven recommendation systems.

---

## Future work

The current feature table provides a strong proof-of-concept foundation, but several important extensions could significantly improve modeling quality and interpretability.

---

### Move from Ortsteile to LOR units

A strong next step would be to move from **Ortsteile** to **Lebensweltlich orientierte Räume (LOR)** as the spatial unit of analysis.

Source:  
https://daten.odis-berlin.de/de/dataset/lor_bezirksregionen_2021/

LORs are smaller planning units used by Berlin’s district administrations for urban analysis and public service planning.

Compared with Ortsteile, they offer:

- finer spatial granularity
- more homogeneous population groups
- better alignment with local urban patterns

Berlin is divided into **143 Bezirksregionen (LOR units)**, each covering on average around **25,000 residents**.

Using LORs instead of Ortsteile would likely improve:

- neighborhood comparability
- clustering precision
- local accessibility analysis
- typology detection

The current Ortsteil level may still be too coarse for some urban signals, especially in mixed-use central districts.

---

### Improve bike lane normalization

Bike lanes are currently normalized as:

`bike lane length / sq km`

This is a useful first proxy, but not the ideal denominator.

A better future metric would be:

`bike lane length / total road length`

This would produce a true **bike lane share of street infrastructure**, which is more interpretable for mobility analysis.

This requires integrating a street network layer.

---

### Enrich semantic feature granularity

Several categories are currently aggregated at a high level.

Future iterations should split these into more granular semantic features.

Examples include:

- **religious institutions by denomination or religion**
  - church
  - mosque
  - synagogue
  - temple

- **schools by type**
  - primary
  - secondary
  - vocational
  - specialized schools

- **medical services by specialty**
  - general practitioners
  - pediatricians
  - dentists
  - specialists

- **venue and cultural spaces by subtype**
  - concert venues
  - cinemas
  - galleries
  - museums
  - clubs

This would allow the model to better capture neighborhood identity beyond general amenity density.

---

### Normalize temporal activity signals

Opening hours were intentionally excluded in this proof of concept.

A future step would be to normalize these fields into structured temporal features such as:

- 24/7 availability
- evening activity
- weekend availability
- late-night services

This would help capture signals such as:

- nightlife intensity
- convenience infrastructure
- neighborhood liveliness

---

### Dimensionality reduction and clustering

The current feature table has already been used as the input layer for initial unsupervised learning and neighborhood typology discovery.

K-means clustering and user-intent weighting experiments reveal that Berlin’s neighborhood structure is largely driven by:

- accessibility and transport connectivity  
- service density and urban intensity  
- specialized dimensions such as nightlife concentration  

These experiments demonstrate that clustering can capture both:

- baseline urban structure  
- and user-driven similarity through feature weighting  

However, several extensions could significantly improve interpretability and modeling depth.

Natural next steps include:

- **PCA**
  - dimensionality reduction  
  - identification of dominant latent factors  

- **UMAP / t-SNE for visualization**
  - non-linear embeddings  
  - improved understanding of cluster geometry  

- **Alternative clustering methods**
  - hierarchical clustering  
  - density-based approaches  

- **Stability and robustness analysis**
  - cluster consistency across subsamples  
  - sensitivity to feature selection  

- **Refinement of user-intent modeling**
  - continuous weighting across feature groups  
  - neighborhood-level scoring instead of cluster-level ranking  

The objective remains to identify latent neighborhood archetypes such as:

- highly connected central districts  
- family-oriented residential zones  
- nightlife and tourism hubs  
- low-density peripheral neighborhoods  

This is what we mean by **neighborhood typology discovery**:

identifying groups of neighborhoods that share similar urban characteristics based on the engineered feature space, and extending this toward user-driven similarity and recommendation.

---

## Closing note

This project demonstrates how unsupervised learning can move beyond static segmentation toward user-aware similarity, bridging exploratory analysis and recommendation systems.