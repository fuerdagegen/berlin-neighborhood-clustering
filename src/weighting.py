import pandas as pd

from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score, adjusted_rand_score

from src.clustering import evaluate_kmeans


def apply_group_weights(
    X_scaled,
    feature_cols,
    group_feature_map,
    group_weights,
):
    X_weighted = X_scaled.copy()
    feature_index = {col: i for i, col in enumerate(feature_cols)}

    for group_name, features in group_feature_map.items():
        weight = group_weights.get(group_name, 1.0)

        for feature in features:
            if feature in feature_index:
                idx = feature_index[feature]
                X_weighted[:, idx] = X_weighted[:, idx] * weight

    return X_weighted


def weight_stability_analysis(
    X_scaled,
    feature_cols,
    group_feature_map,
    target_group,
    weight_values,
    k=3,
    random_state=42,
):
    baseline_model = KMeans(n_clusters=k, random_state=random_state, n_init=20)
    baseline_labels = baseline_model.fit_predict(X_scaled)

    rows = []

    for w in weight_values:
        group_weights = {g: 1.0 for g in group_feature_map.keys()}
        group_weights[target_group] = w

        X_weighted = apply_group_weights(
            X_scaled=X_scaled,
            feature_cols=feature_cols,
            group_feature_map=group_feature_map,
            group_weights=group_weights,
        )

        weighted_model = KMeans(n_clusters=k, random_state=random_state, n_init=20)
        weighted_labels = weighted_model.fit_predict(X_weighted)

        rows.append({
            "weight": w,
            "silhouette_score": silhouette_score(X_weighted, weighted_labels),
            "ari_vs_baseline": adjusted_rand_score(baseline_labels, weighted_labels),
        })

    return pd.DataFrame(rows)


def run_group_weighted_kmeans_diagnostics(
    X_scaled,
    feature_cols,
    group_feature_map,
    target_group,
    weight,
    k_values,
):
    group_weights = {g: 1.0 for g in group_feature_map.keys()}
    group_weights[target_group] = weight

    X_weighted = apply_group_weights(
        X_scaled=X_scaled,
        feature_cols=feature_cols,
        group_feature_map=group_feature_map,
        group_weights=group_weights,
    )

    results = evaluate_kmeans(X_weighted, k_values)

    return X_weighted, results