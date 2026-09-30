"""Use a fake 1Password CLI to verify failed reads preserve the Age key."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class AgeKeyTest(unittest.TestCase):
    def test_age_key_write(self):
        for failure in (True, False):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                key = root / "keys.txt"
                key.write_text("existing-test-key")
                op = root / "op"
                op.write_text("#!/bin/sh\nprintf replacement-test-key\nexit " +
                              ("1" if failure else "0") + "\n")
                op.chmod(0o755)
                result = subprocess.run(
                    [shutil.which("task"), "-t", str(REPO / "Taskfile.yaml"),
                     "generate-age-key", f"OP={op}", f"AGE_KEY_FILE={key}"],
                    capture_output=True, text=True, env=os.environ,
                )
                self.assertEqual(result.returncode == 0, not failure, result.stderr)
                self.assertEqual(key.read_text(),
                                 "existing-test-key" if failure else "replacement-test-key")
                if not failure:
                    self.assertEqual(key.stat().st_mode & 0o777, 0o600)
                self.assertEqual(sorted(p.name for p in root.iterdir()), ["keys.txt", "op"])


if __name__ == "__main__":
    unittest.main()
