from pathlib import Path
import runpy
import tempfile
import unittest

update = runpy.run_path(str(Path(__file__).with_name("update-shipper.py")))["update"]


def cask(version):
    return f'cask "quesma-shipper" do\n  version "{version}"\nend\n'


class ReleaseImportTests(unittest.TestCase):
    def test_first_import_and_upgrade(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "Casks/quesma-shipper.rb"
            for version in ("0.1.0-9.abc", "0.1.0-10.def", "0.2.0-1.abc"):
                update({"tag_name": version}, cask(version), target)
                self.assertEqual(target.read_text(), cask(version))

    def test_older_release_cannot_roll_back_the_tap(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "quesma-shipper.rb"
            target.write_text(cask("0.1.0-100.abc"))
            update({"tag_name": "0.1.0-99.def"}, cask("0.1.0-99.def"), target)
            self.assertEqual(target.read_text(), cask("0.1.0-100.abc"))

    def test_unpublished_or_mismatched_asset_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "quesma-shipper.rb"
            for release in (
                {"tag_name": "1.0.1"},
                {"tag_name": "1.0.0", "draft": True},
                {"tag_name": "1.0.0", "prerelease": True},
            ):
                with self.subTest(release=release), self.assertRaises(ValueError):
                    update(release, cask("1.0.0"), target)
            self.assertFalse(target.exists())


if __name__ == "__main__":
    unittest.main()
