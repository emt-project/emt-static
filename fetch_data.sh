# bin/bash
mkdir data
echo "fetching transkriptions from emt-working-data"
rm -rf data/editions && mkdir data/editions
curl -LO https://github.com/emt-project/emt-working-data/archive/refs/heads/main.zip
unzip main
mv -t ./data/editions/ ./emt-working-data-main/data/work-in-progress/*/*.xml
rm main.zip
rm -rf ./emt-working-data-main

echo "fetching indices from emt-entities"
rm -rf data/indices

curl -LO https://github.com/emt-project/emt-entities/archive/refs/heads/main.zip
unzip main
rm main.zip
rm -rf html/js-data && mkdir html/js-data
mv ./emt-entities-main/indices ./data/indices
mv ./emt-entities-main/json_dumps/storymap.json ./html/js-data/storymap.json
mv ./emt-entities-main/json_dumps/timeline.json ./html/js-data/timeline.json
rm -rf ./emt-entities-main

echo "fetching transkriptions from emt-para-text"
rm -rf data/meta/
mkdir data/meta
curl -LO https://github.com/emt-project/emt-para-text/archive/refs/heads/main.zip
unzip main
mv ./emt-para-text-main/data/meta/*.xml ./data/meta/
shopt -s extglob
mv --target-directory=./html/img/ ./emt-para-text-main/data/img/*.+(jpg|png) 
rm main.zip
rm -rf ./emt-para-text-main

echo "update imprint"
./shellscripts/dl_imprint.sh

echo "fetch bio-pics"
rm -rf ./html/bio-pics
curl -LO https://github.com/emt-project/emt-bio-pics/archive/refs/heads/main.zip
unzip main
rm main.zip
mv ./emt-bio-pics-main/bio-pics ./html/bio-pics
rm -rf ./emt-bio-pics-main
python delete_faulty_files.py
python add_missing_hashes.py
