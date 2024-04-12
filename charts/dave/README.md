# dave-helm
helmchart for DAVe traffic counting plattform

# install
helm upgrade --install -f values.yaml -f values-lhm.yaml -f values-secret.yaml dave .
