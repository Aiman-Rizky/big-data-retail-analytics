from __future__ import annotations

import argparse
import csv
import sys
import time
from pathlib import Path

from pyspark import StorageLevel
from pyspark.sql import functions as F

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.config import get_paths, validate_source_files  # noqa: E402
from src.spark_pipeline import (  # noqa: E402
    aggregate_outputs,
    create_spark,
    read_sources,
    transform_sources,
)


def main() -> None:
    parser = argparse.ArgumentParser(description="Benchmark PySpark pada beberapa ukuran data")
    parser.add_argument("--include-full", action="store_true")
    parser.add_argument("--master", default="local[*]")
    args = parser.parse_args()

    paths = get_paths("retail_contaminated_dataset")
    validate_source_files(paths)
    paths.validation_dir.mkdir(parents=True, exist_ok=True)
    benchmark_root = paths.output_dir / "parquet" / "benchmark"

    spark = create_spark(args.master)
    sources = read_sources(spark, paths.source_dir)
    sizes: list[int | None] = [10_000, 100_000, 1_000_000]
    if args.include_full:
        sizes.append(None)

    rows: list[dict[str, object]] = []
    for size in sizes:
        label = "full" if size is None else str(size)
        sales_subset = sources["sales"] if size is None else sources["sales"].limit(size)
        subset_sources = {**sources, "sales": sales_subset}

        started = time.perf_counter()
        enriched = transform_sources(subset_sources).persist(StorageLevel.MEMORY_AND_DISK)
        actual_rows = enriched.count()
        transform_seconds = time.perf_counter() - started

        started = time.perf_counter()
        monthly = aggregate_outputs(enriched)["monthly_sales"]
        monthly.count()
        aggregate_seconds = time.perf_counter() - started

        target = benchmark_root / f"rows_{label}"
        started = time.perf_counter()
        enriched.write.mode("overwrite").parquet(str(target))
        write_seconds = time.perf_counter() - started

        started = time.perf_counter()
        readback_rows = spark.read.parquet(str(target)).count()
        readback_seconds = time.perf_counter() - started
        if readback_rows != actual_rows:
            raise ValueError(f"Read-back mismatch untuk {label}: {readback_rows} != {actual_rows}")

        rows.append(
            {
                "requested_rows": label,
                "actual_rows": actual_rows,
                "transform_seconds": round(transform_seconds, 3),
                "aggregate_seconds": round(aggregate_seconds, 3),
                "write_parquet_seconds": round(write_seconds, 3),
                "readback_seconds": round(readback_seconds, 3),
            }
        )
        enriched.unpersist()

    result_path = paths.validation_dir / "performance_results.csv"
    with result_path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)

    print(f"Hasil benchmark disimpan di {result_path}")
    spark.stop()


if __name__ == "__main__":
    main()

