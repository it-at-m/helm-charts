The chart embeds only Kubernetes definitions reachable from the Kubernetes types
used by its values schema. Current source and Apache-2.0 attribution are recorded
in NOTICE; the full license text is in LICENSE.

The definitions are embedded in `../values.schema.json` because Helm does not
resolve relative file references from the chart directory. To update the
Kubernetes API baseline, refresh the transitive definition closure from the
upstream file recorded in NOTICE and update the schema comment and attribution.
