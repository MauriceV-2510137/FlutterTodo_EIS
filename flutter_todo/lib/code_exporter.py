from pathlib import Path
from dataclasses import dataclass

# =========================================================
# CONFIG
# =========================================================

EXCLUDE_DIRS = {
    "bin", "obj", "Debug", "Release", ".vs", "out", "_framework",
    "target", "vendor", "__pycache__", ".pytest_cache", ".venv",
    ".git", "node_modules", "HashChecker", "HashCreator", "Vendor"
}

INCLUDE_EXTENSIONS = {
    ".py", ".txt", ".env", ".js", ".ts", ".tsx", ".jsx",
    ".cs", ".json", ".yml", ".yaml", ".md", ".html", ".css",
    ".cpp", ".hpp", ".c", ".h", ".java", ".rs", ".go", ".toml", ".cmake", ".dart",
}

INCLUDE_FILES = {
}

MAX_SIZE = 2 * 1024 * 1024

# chunk size in lines (tune this if needed)
CHUNK_SIZE = 200


# =========================================================
# STATS
# =========================================================

@dataclass
class Stats:
    matched: int = 0
    processed: int = 0
    skipped: int = 0


# =========================================================
# FILTER
# =========================================================

def should_skip(file: Path, script: Path, output: Path) -> bool:
    if not file.is_file():
        return True

    for part in file.parts:
        if part in EXCLUDE_DIRS:
            return True

    if file.name in {script.name, output.name}:
        return True

    if file.name not in INCLUDE_FILES and file.suffix.lower() not in INCLUDE_EXTENSIONS:
        return True

    return False


# =========================================================
# CHUNKING
# =========================================================

def chunk_lines(lines, size):
    for i in range(0, len(lines), size):
        yield i // size, lines[i:i + size]


def write_chunk(out, rel, chunk_id, chunk_lines):
    out.write(f"FILE: {rel}\n")
    out.write(f"CHUNK {chunk_id}\n")
    out.write("".join(chunk_lines))
    out.write("\n")


# =========================================================
# CORE
# =========================================================

def main():
    root = Path(__file__).resolve().parent
    script = Path(__file__).resolve()
    output = root / f"{root.name}_ExportedCode.txt"

    stats = Stats()

    if output.exists():
        output.unlink()

    with output.open("w", encoding="utf-8") as out:
        for file in root.rglob("*"):
            if should_skip(file, script, output):
                continue

            stats.matched += 1

            try:
                if file.stat().st_size > MAX_SIZE:
                    stats.skipped += 1
                    continue
            except OSError:
                stats.skipped += 1
                continue

            rel = file.relative_to(root)

            print(f"Processing: {rel}")

            try:
                content = file.read_text(encoding="utf-8", errors="ignore")
                lines = content.splitlines(keepends=True)

                if not lines:
                    out.write(f"FILE: {rel}\nEMPTY\n\n")
                    stats.processed += 1
                    continue

                for chunk_id, chunk in chunk_lines(lines, CHUNK_SIZE):
                    write_chunk(out, rel, chunk_id, chunk)

                stats.processed += 1

            except Exception as e:
                out.write(f"FILE: {rel}\nERROR: {e}\n\n")
                stats.skipped += 1

    print("\n================ SUMMARY ================")
    print(f"Matched files : {stats.matched}")
    print(f"Processed     : {stats.processed}")
    print(f"Skipped       : {stats.skipped}")
    print("Output file   :", output.name)
    print("========================================\n")


# =========================================================
# ENTRY
# =========================================================

if __name__ == "__main__":
    try:
        main()
    except Exception:
        import traceback
        traceback.print_exc()
    finally:
        input("Press Enter to exit...")