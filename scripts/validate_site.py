#!/usr/bin/env python3
import json
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
PUBLIC = ROOT / "public"
errors = []

class RefParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.refs = []

    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key in {"href", "src"} and value:
                self.refs.append((tag, key, value))

def fail(message):
    errors.append(message)

def local_target(html_path, ref):
    if ref.startswith(("#", "mailto:", "tel:", "data:", "javascript:")):
        return None
    parsed = urlparse(ref)
    if parsed.scheme or parsed.netloc:
        return None
    clean = parsed.path
    if not clean:
        return None
    if clean.startswith("/"):
        return PUBLIC / clean.lstrip("/")
    return html_path.parent / clean

required = [
    PUBLIC / "index.html",
    PUBLIC / "manifest.json",
    PUBLIC / "service-worker.js",
    ROOT / "firebase.json",
    ROOT / ".firebaserc",
]
for path in required:
    if not path.exists():
        fail(f"Missing required file: {path.relative_to(ROOT)}")

for json_path in [ROOT / "firebase.json", ROOT / ".firebaserc", PUBLIC / "manifest.json"]:
    try:
        json.loads(json_path.read_text(encoding="utf-8"))
    except Exception as exc:
        fail(f"Invalid JSON in {json_path.relative_to(ROOT)}: {exc}")

for html_path in sorted(PUBLIC.rglob("*.html")):
    text = html_path.read_text(encoding="utf-8")
    if re.search(r'(?:href|src)\s*=\s*["\']=', text, re.I):
        fail(f"Malformed href/src attribute in {html_path.relative_to(ROOT)}")
    if "XXXXXXXXXXXXXXXX" in text or "entry.1234567890" in text:
        fail(f"Placeholder integration left in {html_path.relative_to(ROOT)}")

    parser = RefParser()
    try:
        parser.feed(text)
    except Exception as exc:
        fail(f"HTML parse error in {html_path.relative_to(ROOT)}: {exc}")
        continue

    for tag, attr, ref in parser.refs:
        target = local_target(html_path, ref)
        if target is None:
            continue
        if target.is_dir():
            target = target / "index.html"
        if not target.exists():
            fail(
                f"Broken local reference in {html_path.relative_to(ROOT)}: "
                f"{attr}={ref!r} -> {target.relative_to(ROOT) if target.is_relative_to(ROOT) else target}"
            )

try:
    manifest = json.loads((PUBLIC / "manifest.json").read_text(encoding="utf-8"))
    if manifest.get("display") not in {"standalone", "fullscreen", "minimal-ui"}:
        fail("PWA manifest must use an installable display mode")
    for icon in manifest.get("icons", []):
        src = icon.get("src")
        if src and not (PUBLIC / src.lstrip("/")).exists():
            fail(f"Manifest icon missing: {src}")
except Exception:
    pass

firebase_text = (ROOT / "firebase.json").read_text(encoding="utf-8")
if '"public": "public"' not in firebase_text:
    fail('firebase.json must deploy the "public" directory')

functions_path = ROOT / "functions_index.js"
if functions_path.exists():
    functions_text = functions_path.read_text(encoding="utf-8")
    if '"process.env.GEMINI_API_KEY"' in functions_text or "'process.env.GEMINI_API_KEY'" in functions_text:
        fail("functions_index.js uses a literal environment-variable name as an API key")

if errors:
    print("HomyGo validation FAILED:")
    for item in errors:
        print(f" - {item}")
    sys.exit(1)

print("HomyGo validation OK")
