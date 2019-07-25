import argparse
import subprocess

libraries = [
    'tensorflow',
]

def get_args():
    # e.g. python python_library_tags.py -o ~/python_library_tags/tags
    parser = argparse.ArgumentParser(
        'Produce tags files for selected libraries')
    parser.add_argument('-o', '--output-file', required=True,
                        help='Where to write tags file')

    args = parser.parse_args()
    return args

if __name__ == '__main__':
    args = get_args()

    all_paths = []
    for library in libraries:
        print("Processing [name = {}]".format(library))
        paths = None
        exec("import {library}; paths = {library}.__path__".format(
            **locals()))
        assert paths is not None
        print("Found paths [num = {}]".format(len(paths)))
        all_paths.extend(paths)

    print("Running ctags [paths = {}]".format(len(all_paths)))
    cmd = [
        'ctags',
        '-f',
        args.output_file,
        '--recurse',
        '--languages=python',
    ] + all_paths
    subprocess.check_call(cmd)
    print("Ctags run complete")
