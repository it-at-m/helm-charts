from packaging.version import Version
import ruamel.yaml
from ruamel.yaml.scalarstring import DoubleQuotedScalarString
import argparse
import os

def increment_version(version):
    v = Version(version)
    return f"{v.major}.{v.minor}.{v.micro + 1}"

parser = argparse.ArgumentParser(description='Upgrade Versions')
parser.add_argument('--appVersion', help='New App-Version')
parser.add_argument('--pathToChart', help='Path to updated Chart.yaml')
args = parser.parse_args()

yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True

# Check, whether passed file path is sub-chart or parent-chart
path_to_helm_charts = os.path.abspath('charts/')
target_path = os.path.abspath(args.pathToChart)

if path_to_helm_charts == os.path.dirname(os.path.dirname(target_path)):
    parent_chart_yaml = target_path
    sub_chart_yaml = ""
else:
    parent_chart_yaml = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(target_path))), "Chart.yaml")
    sub_chart_yaml = target_path

# Load Chart.yaml files
with open(parent_chart_yaml, "r") as file:
    parent_chart_file_data = yaml.load(file)
if sub_chart_yaml:
    with open(sub_chart_yaml, "r") as file:
        sub_chart_file_data = yaml.load(file)

# Update versions
if sub_chart_yaml:
    if sub_chart_file_data["appVersion"] != args.appVersion:
        # Sub-Chart was updated
        sub_chart_file_data["version"] = increment_version(sub_chart_file_data["version"])
        sub_chart_file_data["appVersion"] = DoubleQuotedScalarString(args.appVersion)
        entry_index = parent_chart_file_data["dependencies"].index(next(filter(lambda entry: entry['name'] == sub_chart_file_data["name"], parent_chart_file_data["dependencies"]), None))
        parent_chart_file_data["dependencies"][entry_index]["version"] = sub_chart_file_data["version"]
        parent_chart_file_data["version"] = increment_version(parent_chart_file_data["version"])
else:
    # Parent-Chart was updated
    if "appVersion" in parent_chart_file_data.keys():
        if parent_chart_file_data["appVersion"] != args.appVersion:
            parent_chart_file_data["appVersion"] = args.appVersion
            parent_chart_file_data["version"] = increment_version(parent_chart_file_data["version"])
    else:
        parent_chart_file_data["version"] = increment_version(parent_chart_file_data["version"])

# Write data to Chart.yaml files
with open(parent_chart_yaml, "w") as file:
    yaml.dump(parent_chart_file_data, file)
if sub_chart_yaml:
    with open(sub_chart_yaml, "w") as file:
        yaml.dump(sub_chart_file_data, file)
