# https://github.com/hashicorp/terraform-provider-archive/issues/62
# to be used with terraform when zipping libs for a lambda function
# test in cli with
# echo '{"output_path": "output.zip", "source_path": "/some/dir", "exclusions": "[\"*.sh\"]"}' | python utils_zip_glob.py

import fnmatch
import json
import pathlib
import shutil
import sys
import zipfile
from datetime import datetime, timedelta
from typing import List


def matches_exclusions(source: str, exclusions: List[str]) -> bool:
    """Return true if the given relative path matches one
    of the globbing patterns in exclusions."""

    for exclusion in exclusions:
        if fnmatch.fnmatch(source, exclusion):
            return True

    return False


def update_zip_file(
    output_path: pathlib.Path, source_path: pathlib.Path, exclusions: List[str]
) -> bool:
    """
    Update the zip file at output_path with files from source_path. Any file with a
    timestamp newer than it's counterpart in the output_path or that does not yet
    exist in the output path will be updated. All other files are left unchanged.
    The exclusion list governs what files are checked. This function will act
    sanely even if the output zip doesn't exist yet or isn't a zip file. In those
    cases, any existing file at output_path is removed, and then a new zip file
    is created in it's place.
    This function returns True if the archive was modified.
    """

    updated = False
    infos = []
    info_map = {}
    source_files: List[pathlib.Path] = []

    try:
        # First, grab all the ZipInfo's from the existing archive
        with zipfile.ZipFile(
            output_path, mode="r", compression=zipfile.ZIP_BZIP2
        ) as zfile:
            infos = zfile.infolist()
            info_map = {i.filename: i for i in infos}
    except zipfile.BadZipFile:
        # Bad archive, delete it
        output_path.unlink()
    except FileNotFoundError:
        updated = True
        pass

    # Next look for all the source files matching the pattern
    for source in source_path.rglob("**/*"):

        # Don't try to zip directories
        if not source.is_file():
            continue

        # Do not attempt to zip ourselves
        if output_path.resolve() == source.resolve():
            continue

        relative_source = str(source.relative_to(source_path))

        # There's no way to remove a file from a zipfile with the standard library D:
        if matches_exclusions(relative_source, exclusions):
            continue

        if relative_source in info_map:
            st = source.stat()
            other_info = info_map[relative_source]

            # Grab the source modification time
            src_mtime = datetime.fromtimestamp(st.st_mtime)

            # Grab the existing modification time.
            #   We add 2 seconds because the resolution of zip datetime
            #   stamps is 2 seconds. It's unlikely to hit the edge case
            #   of a modified file not being added becase of this.
            other_mtime = datetime(
                year=other_info.date_time[0],
                month=other_info.date_time[1],
                day=other_info.date_time[2],
                hour=other_info.date_time[3],
                minute=other_info.date_time[4],
                second=other_info.date_time[5],
            ) + timedelta(seconds=2)

            # Ignore the file
            if src_mtime > other_mtime:
                updated = True

        source_files.append(source)

    if not updated:
        return False

    # Remove the existing zip file. We can't modify it.
    output_path.unlink(missing_ok=True)

    with zipfile.ZipFile(output_path, mode="w", compression=zipfile.ZIP_BZIP2) as zfile:

        # Iterate over every file
        for source in source_files:

            # Find the path name inside the zip
            relative_source = "python/" + str(source.relative_to(source_path))

            info = zipfile.ZipInfo.from_file(source, relative_source)
            mtime = datetime.fromtimestamp(source.stat().st_mtime)
            info.date_time = (
                mtime.year,
                mtime.month,
                mtime.day,
                mtime.hour,
                mtime.minute,
                mtime.second,
            )

            # Write the file to the archive
            with zfile.open(info, "w") as ofile:
                with source.open("rb") as ifile:
                    shutil.copyfileobj(ifile, ofile)

    return True


if __name__ == "__main__":
    """Archive a directory with a list of excluded glob patterns. This is a stupid hack
    because the terraform archive_file resource doesn't support exclusion patterns. The
    output file will be removed if it already exists with invalid content. The output
    path is only overwritten if any files in the source_path that do not match the
    exclusion list are newer than their counterpart in the existing archive.
    Because the Python standard library can't remove or overwrite a file in a zip file,
    updating the archive means removing it and rebuilding it from scratch regardless
    of the reason.
    Input arguments are passed via JSON on stdin, but are restricted to strings, so
    the exclusion list has to be passed with `jsonencode(["exclusion", "list"])` in
    terraform.
    Input Arguments:
        - `output_path`: a string representing the output zip file
        - `source_path`: a string representing the root directory to archive
        - `exclusions`: a JSON encoded list of exclusion glob patterns relative to source_path
    Output:
        - `id`: path to the output file
        - `output_path`: path to the output file
        - `updated`: either the string "true" or "false" indicating if the archive was changed.
    """

    query = json.load(sys.stdin)

    if query.get("output_path") is None or not isinstance(query["output_path"], str):
        print("output_path is required and must be a string", file=sys.stderr)
        sys.exit(1)

    if query.get("source_path") is None or not isinstance(query["source_path"], str):
        print("source_path is required and must be a string", file=sys.stderr)
        sys.exit(1)

    source_path = pathlib.Path(query.get("source_path", "."))
    output_path = pathlib.Path(query.get("output_path"))
    exclusions_str = query.get("exclusions", "[]")
    exclusions = json.loads(exclusions_str)

    if not isinstance(exclusions, list):
        print("Exclusions must be a list of glob patterns", file=sys.stderr)
        sys.exit(1)

    if not source_path.is_dir():
        print("source_path must be an existing directory", file=sys.stderr)
        sys.exit(1)

    if output_path.exists() and not output_path.is_file():
        print("output_path must either not exist or point to a regular file")
        sys.exit(1)

    try:
        # Update or create the zip file
        updated = update_zip_file(output_path, source_path, exclusions)
    except Exception as exc:
        print(f"unknown error while buiding archive: {exc}", file=sys.stderr)
        sys.exit(1)

    print(
        json.dumps(
            {
                "id": str(output_path),
                "output_path": str(output_path),
                "updated": str(updated).lower(),
            }
        )
    )
