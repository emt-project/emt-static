# Familiensache. Dynastische Handlungsspielräume in der Korrespondenz von Kaiserin Eleonora Magdalena von Pfalz-Neuburg (1655-1720)

Application repo for the FWF funded Project [Family Matters. Female Dynastic Agency and Correspondence](https://www.fwf.ac.at/en/research-radar/10.55776/P34651)

## develop

* clone the repo
* install [ant](https://ant.apache.org/) if its not already installed
* install saxon (you can run `./shellscripts/dl_saxon.sh`)
* create a python virtual environment, activate it and install dependencies e.g.
```bash
python -m venv venv
source venv/bin/activte
pip install -U pip
pip install -r requirements.txt
```

To build the app, have a look at `.github/workflows/static.yml`but it basically boils down to
* fetch the data `./fetch_data.sh`
* process the `./process_data.sh`
* build the app `ant`
* build the fulltext indes `python make_typesense_index.py` (be sure to set your Typesense credentials als environment variables)

## dockerize your application

* To build the image run: `docker build -t emt-static .`
* To run the container: `docker run -p 80:80 --rm --name emt-static emt-static`


## Licenses

This project is released under the [MIT License](LICENSE)

## Third-party JavaScript libraries

The code for all third-party JavaScript libraries used is included in the html/vendor folder, their respective licenses can be found either in a LICENSE.txt file or directly in the header of the .js file

## SAXON-HE

The projects also includes Saxon-HE, which is licensed separately under the Mozilla Public License, Version 2.0 (MPL 2.0). See the dedicated [LICENSE.txt](saxon/notices/LICENSE.txt)
-----
build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)