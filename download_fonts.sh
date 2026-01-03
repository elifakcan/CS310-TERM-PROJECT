#!/bin/bash

mkdir -p assets/fonts

curl -L "https://github.com/google/fonts/raw/main/ofl/pacifico/Pacifico-Regular.ttf" \
     -o assets/fonts/Pacifico-Regular.ttf

curl -L "https://github.com/google/fonts/raw/main/ofl/montserrat/static/Montserrat-Regular.ttf" \
     -o assets/fonts/Montserrat-Regular.ttf

curl -L "https://github.com/google/fonts/raw/main/ofl/montserrat/static/Montserrat-Bold.ttf" \
     -o assets/fonts/Montserrat-Bold.ttf
