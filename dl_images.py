import os

import requests
import glob
from acdh_tei_pyutils.tei import TeiReader

os.makedirs("img", exist_ok=True)

images = [os.path.split(x)[-1] for x in sorted(glob.glob("./img/*.jpg"))]
files = sorted(glob.glob("./data/editions/*xml"))
for x in files:
    f_name = os.path.split(x)[-1].replace(".xml", "")
    doc = TeiReader(x)
    for i, url in enumerate(
        doc.any_xpath(".//tei:pb[@source]/@source"), start=1
    ):
        img_name = f"{f_name}___{i:04}.jpg"
        save_path = os.path.join("img", img_name)
        if img_name in images:
            continue
        response = requests.get(url)
        print(f"saving {url} as {save_path}")
        with open(save_path, "wb") as file:
            file.write(response.content)
