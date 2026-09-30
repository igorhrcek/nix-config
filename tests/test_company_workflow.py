"""Exercise the real Taskfile without rebuilding or changing the machine."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
TASK = shutil.which("task")


class CompanyWorkflowTest(unittest.TestCase):
    def run_workflow(self, failure="", target="company-build"):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            log = root / "events"
            commands = {
                "nix": 'if [ "$1" = build ]; then stage=build; else stage=update; fi',
                "brew": 'stage="trust:$*"',
                "sudo": "stage=switch",
                "record": "stage=stamp",
                "task": "stage=secrets",
            }
            for name, body in commands.items():
                script = root / name
                script.write_text(
                    "#!/bin/sh\nset -e\n" + body + '\n'
                    'echo "$stage" >> "$EVENT_LOG"\n'
                    '[ "$stage" != "$FAIL_STAGE" ]\n'
                )
                script.chmod(0o755)
            taskfile = (REPO / "Taskfile.yaml").read_text().replace(
                "/run/current-system/sw/bin/ml-record-applied", str(root / "record")
            )
            (root / "Taskfile.yaml").write_text(taskfile)
            result = subprocess.run(
                [TASK, target, "OS=Darwin", "HOSTNAME=Netrunner"], cwd=root,
                env={**os.environ, "PATH": f"{root}:{os.environ['PATH']}",
                     "EVENT_LOG": str(log), "FAIL_STAGE": failure},
                capture_output=True, text=True,
            )
            return result.returncode, log.read_text().splitlines()

    def test_success_records_only_after_activation(self):
        code, events = self.run_workflow()
        self.assertEqual(code, 0)
        self.assertEqual(events, ["update", "build", "trust:trust --formula ddev/ddev/ddev",
                                  "trust:trust vitobotta/hetzner_k3s", "switch", "stamp"])

    def test_failure_stops_workflow(self):
        stages = ["update", "build", "trust:trust --formula ddev/ddev/ddev",
                  "trust:trust vitobotta/hetzner_k3s", "switch", "stamp"]
        for index, stage in enumerate(stages):
            with self.subTest(stage=stage):
                code, events = self.run_workflow(stage)
                self.assertNotEqual(code, 0)
                self.assertEqual(events, stages[:index + 1])

    def test_update_does_not_report_activation(self):
        code, events = self.run_workflow(target="update")
        self.assertEqual(code, 0)
        self.assertEqual(events, ["update"])


if __name__ == "__main__":
    unittest.main()
