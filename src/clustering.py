from IPython.display import display
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.cluster import KMeans
from sklearn.metrics import (
    silhouette_score,
    silhouette_samples,
    davies_bouldin_score,
    calinski_harabasz_score,
)


def evaluate_kmeans(X_matrix, k_values, random_state=42):
    results = []

    for k in k_values:
        model = KMeans(n_clusters=k, random_state=random_state, n_init=20)
        labels = model.fit_predict(X_matrix)

        results.append({
            "model": "kmeans",
            "k": k,
            "silhouette_score": silhouette_score(X_matrix, labels),
            "davies_bouldin_score": davies_bouldin_score(X_matrix, labels),
            "calinski_harabasz_score": calinski_harabasz_score(X_matrix, labels),
        })

    return pd.DataFrame(results)


def compute_kmeans_elbow(X_matrix, k_values, random_state=42):
    rows = []

    for k in k_values:
        model = KMeans(n_clusters=k, random_state=random_state, n_init=20)
        model.fit(X_matrix)

        rows.append({
            "k": k,
            "inertia": model.inertia_,
        })

    return pd.DataFrame(rows)


def interpret_kmeans_solution(
    df_input,
    X_matrix,
    X_original,
    gdf_neighborhoods,
    feature_cols,
    selected_k,
    profile_features=None,
    random_state=42,
    show_labels=False,
    label_column="neighborhood",
    label_fontsize=6,
):
    """
    Fit and inspect one KMeans solution.
    """

    model = KMeans(
        n_clusters=selected_k,
        random_state=random_state,
        n_init=20,
    )

    labels = model.fit_predict(X_matrix)

    df_result = df_input.copy()
    df_result[f"cluster_kmeans_k{selected_k}"] = labels

    cluster_col = f"cluster_kmeans_k{selected_k}"

    silhouette_avg = silhouette_score(X_matrix, labels)
    sample_silhouette_values = silhouette_samples(X_matrix, labels)

    print(f"KMeans solution for k={selected_k}")
    print(f"Average silhouette score: {silhouette_avg:.3f}")

    fig, ax = plt.subplots(figsize=(9, 6))
    y_lower = 10

    for i in range(selected_k):
        ith_cluster_silhouette_values = sample_silhouette_values[labels == i]
        ith_cluster_silhouette_values.sort()

        size_cluster_i = ith_cluster_silhouette_values.shape[0]
        y_upper = y_lower + size_cluster_i

        ax.fill_betweenx(
            np.arange(y_lower, y_upper),
            0,
            ith_cluster_silhouette_values,
            alpha=0.7,
        )

        ax.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))
        y_lower = y_upper + 10

    ax.axvline(x=silhouette_avg, linestyle="--")
    ax.set_xlabel("Silhouette coefficient")
    ax.set_ylabel("Cluster")
    ax.set_title(f"Silhouette plot for KMeans (k={selected_k})")
    ax.set_yticks([])
    plt.show()

    cluster_sizes = (
        df_result[cluster_col]
        .value_counts()
        .sort_index()
        .reset_index()
    )
    cluster_sizes.columns = ["cluster", "n_neighborhoods"]

    print("Cluster sizes")
    display(cluster_sizes)

    df_profile = pd.concat(
        [df_result[["neighborhood_id", "neighborhood", "district", cluster_col]], X_original],
        axis=1,
    )

    cluster_profile_full = (
        df_profile.groupby(cluster_col)[feature_cols]
        .mean()
        .round(3)
    )

    print("Cluster centroids in original feature space")
    display(cluster_profile_full.head(20))

    if profile_features is None:
        profile_features = feature_cols.copy()

    profile_features = [col for col in profile_features if col in X_original.columns]

    cluster_profile = (
        df_profile.groupby(cluster_col)[profile_features]
        .mean()
        .round(3)
    )

    print("Presentation-ready cluster profile")
    display(cluster_profile)

    cluster_profile_z = cluster_profile.copy()

    for col in cluster_profile_z.columns:
        mean_col = X_original[col].mean()
        std_col = X_original[col].std()

        if std_col != 0:
            cluster_profile_z[col] = (cluster_profile_z[col] - mean_col) / std_col
        else:
            cluster_profile_z[col] = 0

    cluster_profile_z = cluster_profile_z.round(2)

    print("Relative cluster profile (z-score vs city average)")
    display(cluster_profile_z)

    top_n = 10
    top_features_per_cluster = []

    for cluster_id in cluster_profile_z.index:
        cluster_series = cluster_profile_z.loc[cluster_id].sort_values(ascending=False)

        top_positive = cluster_series.head(top_n).reset_index()
        top_positive.columns = ["feature", "z_score_vs_city_avg"]
        top_positive["cluster"] = cluster_id
        top_positive["direction"] = "higher"

        top_negative = cluster_series.tail(top_n).sort_values().reset_index()
        top_negative.columns = ["feature", "z_score_vs_city_avg"]
        top_negative["cluster"] = cluster_id
        top_negative["direction"] = "lower"

        top_features_per_cluster.append(top_positive)
        top_features_per_cluster.append(top_negative)

    top_features_per_cluster = pd.concat(top_features_per_cluster, ignore_index=True)

    print("Top distinguishing features per cluster")
    display(top_features_per_cluster)

    cluster_membership = (
        df_result[["neighborhood", "district", cluster_col]]
        .sort_values([cluster_col, "district", "neighborhood"])
        .reset_index(drop=True)
    )

    print("Neighborhood membership by cluster")
    display(cluster_membership)

    gdf_clusters = gdf_neighborhoods.merge(
        df_result[["neighborhood_id", cluster_col]],
        on="neighborhood_id",
        how="left",
    )

    fig, ax = plt.subplots(figsize=(10, 10))

    gdf_clusters.plot(
        column=cluster_col,
        categorical=True,
        legend=True,
        linewidth=0.5,
        edgecolor="black",
        ax=ax,
    )

    if show_labels:
        for _, row in gdf_clusters.iterrows():
            if row.geometry is not None and not row.geometry.is_empty:
                centroid = row.geometry.centroid
                ax.text(
                    centroid.x,
                    centroid.y,
                    str(row[label_column]),
                    fontsize=label_fontsize,
                    ha="center",
                    va="center",
                )

    ax.set_title(f"Berlin neighborhoods by KMeans cluster (k={selected_k})")
    ax.set_axis_off()
    plt.show()

    return {
        "df_result": df_result,
        "cluster_sizes": cluster_sizes,
        "cluster_profile_full": cluster_profile_full,
        "cluster_profile": cluster_profile,
        "cluster_profile_z": cluster_profile_z,
        "top_features_per_cluster": top_features_per_cluster,
        "cluster_membership": cluster_membership,
        "silhouette_avg": silhouette_avg,
        "sample_silhouette_values": sample_silhouette_values,
    }