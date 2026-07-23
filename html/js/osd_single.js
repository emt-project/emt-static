/* function trigger when static html img was loaded */

/* collect each page image URL as viewers load, preserving page order */
var _sequenceImages = [];

function loadImage(container_id, rotation) {

    /* get container holding the image and set height and padding */
    var container = document.getElementById(container_id);
    container.style.height = "700px";
    /* get image src (url) */
    var image = document.getElementById(`${container_id}-img`);
    var imageURL = {
        type: 'image',
        url: image.getAttribute("src")
    };

    /* register this page's image alongside its container id for ordering */
    _sequenceImages.push({ id: container_id, source: imageURL });

    // OpenSeaDragon Image Viewer
    var viewer = OpenSeadragon({
        id: container_id,
        prefixUrl: "vendor/openseadragon-bin-4.1.1/images/",
        defaultZoomLevel: 0,
        fitHorizontally: true,
        sequenceMode: true,
        showSequenceControl: true,
        tileSources: [imageURL],   // single-element array; all pages loaded on fullscreen entry
        degrees: (() => { let rot = parseInt(rotation); return isNaN(rot) ? 0 : rot; })(),
        showRotationControl: true, // Show rotation buttons
        gestureSettingsTouch: {
            pinchRotate: true // Enable touch rotation on tactile devices
        }
    });
    /* remove static html image element */
    image.remove();

    /* hide sequence nav buttons until fullscreen is entered */
    if (viewer.pagingControl) {
        viewer.pagingControl.style.display = 'none';
    }

    /*
     * On fullscreen entry: reveal sequence controls and navigate through sequence, starting with current page
     * On fullscreen exit: hide sequence controls and restore single-page view
     */
    viewer.addHandler('full-screen', function(event) {
        if (event.fullScreen) {
            // need to sort the images by their container id, otherwise the order might be off because they're added by load order
            var sorted = _sequenceImages.slice().sort(function(a, b) {
                return parseInt(a.id.replace('os-id-', '')) - parseInt(b.id.replace('os-id-', ''));
            });
            var orderedImages = sorted.map(function(item) { return item.source; });
            var startIdx = sorted.findIndex(function(item) { return item.source.url === imageURL.url; });
            if (viewer.pagingControl) viewer.pagingControl.style.display = '';
            viewer.open(orderedImages, startIdx < 0 ? 0 : startIdx);
        } else {
            if (viewer.pagingControl) viewer.pagingControl.style.display = 'none';
            viewer.open([imageURL], 0);
        }
    });
}


/* 
    set timeout to wait till osd viewer was loaded
    createOverlays is a click event that creates point coords 
    based one linenumber zones.
    Depending on wheter the linenubmers link was already clicked
    the class active stores the state (maybe re-write to urlparam)
*/
setTimeout(createOverlays, 1000);

function createOverlays() {

    /* attach click event on linenumbers */
    var linenumbers = document.getElementsByClassName("linenumbers");
    [].forEach.call(linenumbers, function(opt) {
        opt.addEventListener("click", function(event) {
            event.preventDefault();

            /* 
                since more than one viewer is open get a viewer id
                and open relevant viewer
            */
            var opt_id = opt.getAttribute("id").replace("#", "");
            var viewerID = `${opt_id.split("_")[0]}_${opt_id.split("_")[1]}`;
            var viewerID = viewerID.replace("facs_", "os-id-");
            var openViewer = OpenSeadragon.getViewer(viewerID);

            /*
                size attribute contains the width,height of facsimile
            */
            var wh = opt.getAttribute("size").split(",");

             /* 
                create overlays array based on clicked linenumbers
                attribute zone
            */
            var overlays = [];
            var zone = opt.getAttribute("zone");

            if (zone !== null && zone !== "") {

                /* 
                    create list split by whitespace and
                    pair every two elements
                 */
                var xys = zone.split(" ");

                /*
                    xy_start = first and last lrx and lry zone points
                    xy_end = list middle and list middle + 1 lrx and lry zone points
                */
                var xy_start = [xys[0], xys[xys.length - 1]];
                var xy_end = [xys[Math.floor((xys.length / 2) - 1)],
                              xys[Math.floor(xys.length / 2)]];

                var xys1 = xy_start[0].split(",");
                var xys2 = xy_start[1].split(",");
                var xye1 = xy_end[0].split(",");
                var xye2 = xy_end[1].split(",");

                /*
                    generate id for each overlay
                */
                var id = `${opt_id}_${xys1[0]}_${xye2[1]}`;
                overlays.push(
                    {
                        id: id,
                        xs1: parseInt(xys1[0]), // x start 1
                        ys1: parseInt(xys1[1]), // y start 1
                        xs2: parseInt(xys2[0]), // x start 2
                        ys2: parseInt(xys2[1]), // y start 2
                        xe1: parseInt(xye1[0]), // x end 1
                        ye1: parseInt(xye1[1]), // y end 1
                        xe2: parseInt(xye2[0]), // x end 2
                        ye2: parseInt(xye2[1]), // y end 2
                        className: 'overlay'
                    }
                )
            }
            else {
                if (!opt.classList.contains("active")) {
                    console.warn("Line " + opt.innerText + " has no associated zone, so no image region is highlighted.");
                }
            }

            /* 
                check if linenumbers is active or not
                if active: remove class and remove overlays
                else: add class and add overlays
            */
            if (opt.classList.contains("active")) {

                /* remove active state from linenumbers click event */
                opt.classList.remove("active");

                /* remove overlay div's */
                for (let el of overlays) {
                    var el_id = el.id;
                    openViewer.removeOverlay(el_id);
                }

                /* remove text overlay */
                opt.closest('.transcript-line').classList.remove('active');

            } else {

                /* add active state for linenumbers click event */
                opt.classList.add("active");

                /* create overlay, turn pixel to viewport and add overlays */
                for (let el of overlays) {

                    /* 
                        get lrx and lry from overlays list
                        1st part contains 2 x lrx and lry at facs start position (left)
                    */
                    let lowerRightXS1 = el.xs1;
                    let lowerRightYS1 = el.ys1;
                    let lowerRightXS2 = el.xs2;
                    let lowerRightYS2 = el.ys2;

                    /* create weight between the two lrx and lry (start - left) */
                    let lrx_s1_weighted = (lowerRightXS1 + lowerRightXS2) / 2;
                    let lry_s1_weighted = (lowerRightYS1 + lowerRightYS2) / 2;

                    /* 
                        get lrx and lry from overlays list
                        2nd part contains 2 x lrx and lry at facs end position (right)
                    */
                    let lowerRightXE1 = el.xe1;
                    let lowerRightYE1 = el.ye1;
                    let lowerRightXE2 = el.xe2;
                    let lowerRightYE2 = el.ye2;

                    /* create weight between the two lrx and lry (end - right) */
                    let lrx_e1_weighted = (lowerRightXE1 + lowerRightXE2) / 2;
                    let lry_e1_weighted = (lowerRightYE1 + lowerRightYE2) / 2;

                    /* create div element as overlay */
                    let overlayElement = document.createElement("div");
                    let idOfOverlay = document.createAttribute("id");
                    let classOfOverlay = document.createAttribute("class");
                    idOfOverlay.value = el.id;
                    classOfOverlay.value = el.className;
                    overlayElement.setAttributeNode(idOfOverlay);
                    overlayElement.setAttributeNode(classOfOverlay);

                    /* parse xry and xrx as integer and convert to viewport coords */
                    let widthOfPicture = parseInt(wh[0]);
                    let heightOfPicture = parseInt(wh[1]);

                    // 1st viewport coordinates to start the rectangle
                    let lrx_1 = lrx_s1_weighted / widthOfPicture;
                    let lry_1 = (lry_s1_weighted / heightOfPicture) * (heightOfPicture / widthOfPicture);

                    // 2nd viewport coordinates for width and height
                    let lrx_2 = lrx_e1_weighted / widthOfPicture;
                    let lry_2 = (lry_e1_weighted / heightOfPicture) * (heightOfPicture / widthOfPicture);

                    /*  height is too random set to zero */
                    // if (lry_1 > lry_2) {
                    //     var heightScaled = lry_1 - lry_2;
                    // } else {
                    //     var heightScaled = lry_2 - lry_1;
                    // }

                    /* width is the lrx 2nd point at the end - right */
                    let widthScaled = lrx_2;
			        
                    /* add div el on pointLayer coords */
                    openViewer.addOverlay(overlayElement, 
                                          new OpenSeadragon.Rect(lrx_1,
                                                                 lry_1,
                                                                 widthScaled,
                                                                 0));
                }

                /* add text overlay */
                opt.closest('.transcript-line').classList.add('active');

            }
        });
    });
}

