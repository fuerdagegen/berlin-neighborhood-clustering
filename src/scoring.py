from IPython.display import display
import pandas as pd


def rank_clusters_for_preference(
    df_with_clusters,
    cluster_col,
    X_original,
    preference_features,
):
    """
    Rank clusters by how well they match a given set of preference features.
    """

    preference_features = list(dict.fromkeys(preference_features))

    preference_features = [
        col for col in preference_features
        if col in X_original.columns
    ]

    print("Preference features used for scoring:")
    display(pd.DataFrame({"feature": preference_features}))

    df_scoring = X_original[preference_features].copy()

    distance_cols = [
        col for col in df_scoring.columns
        if "_dist_" in col or col.startswith("dist_")
    ]

    for col in distance_cols:
        df_scoring[col] = -df_scoring[col]

    df_scoring = (df_scoring - df_scoring.mean()) / df_scoring.std()

    cluster_scores = (
        pd.concat([df_with_clusters[[cluster_col]], df_scoring], axis=1)
        .groupby(cluster_col)[preference_features]
        .mean()
        .mean(axis=1)
        .sort_values(ascending=False)
    )

    best_cluster = cluster_scores.idxmax()

    print("Cluster ranking for this preference scenario:")
    display(cluster_scores)

    print(f"Best-matching cluster: {best_cluster}")

    return cluster_scores, best_cluster, df_scoring