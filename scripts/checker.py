import argparse
import sys
import datetime
import re
import json

denylist = re.compile('we|our|blacklist|whitelist|master|slave')


def create_denylist(denylist):
    deny_dict = json.loads(denylist)
    regex_string = ''
    for word in deny_dict[deny_dict.keys()[0]]:
        regex_string += word+'|'
    return re.compile(regex_string)


def java_checker(file):
    """
    Checks java file for style and license
    """
    line = []
    checks = {
        "license": False,
        "line_too_long": line,
    }
    pass


def adoc_checker(file):
    """
    Checks adoc file for style and license
    """
    checks = {
        "license": False,
        "release_date": False,

    }
    pass


def html_checker(file):
    """
    Checks html file for license
    """
    pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--deny', nargs=1,
                        type=argparse.FileType('r'))
    parser.add_argument('--warn', nargs=1,
                        type=argparse.FileType('r'))
    parser.add_argument('infile', nargs='*',
                        type=argparse.FileType('r'), default=sys.stdin)
    args = parser.parse_args()
    denylist = json.loads(args.deny[0].read())['deny']
    for word in denylist:
        print(word)
    print(denylist)
    for file in args.infile:
        file_extension = file.name.split('/')[-1].split('.')[-1]
        if file_extension is 'adoc':
            adoc_check(file)

        elif file_extension is 'java':
            java_checker(file)

        elif file_extension is 'html':
            html_checker(file)

        else:
            print('its something else')
