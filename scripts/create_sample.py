from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path

import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.config import get_paths, validate_source_files  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(description="Membuat sampel kecil untuk pengujian cepat")
    parser.add_argument("--rows", type=int, default=10_000)
    parser.add_argument(
        "--variant",
        choices=["retail_clean_dataset", "retail_contaminated_dataset"],
        default="retail_contaminated_dataset",
    )
    args = parser.parse_args()
    if args.rows <= 0:
        raise ValueError("--rows harus lebih besar dari nol")

    paths = get_paths(args.variant)
    validate_source_files(paths)
    destination = PROJECT_ROOT / "data" / "sample"
    destination.mkdir(parents=True, exist_ok=True)

    sales = pd.read_csv(paths.source_dir / "sales_transactions.csv", nrows=args.rows)
    sales.to_csv(destination / "sales_transactions_sample.csv", index=False)

    for name in [
        "store_master.csv",
        "sku_master.csv",
        "customer_master.csv",
        "promotions.csv",
        "inventory_snapshot.csv",
        "sku_inventory_flags.csv",
    ]:
        shutil.copy2(paths.source_dir / name, destination / name)

    print(f"Sampel {len(sales):,} baris disimpan di {destination}")


if __name__ == "__main__":
    main()

