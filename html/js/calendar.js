import { register } from "../vendor/calendar-component/calendar.js";
import de from "../vendor/calendar-component/i18n/de.js";


register({});
// register()

let currentYear = 1696;
function createCalendar(i18n, allEvents, onEventClick) {
    const calendar = document.querySelector("acdh-ch-calendar");
    if (i18n != null) {
        /** Optionally set locale, defaults to english. */
        calendar.setI18n(i18n);
    }


    const activeKinds = new Set(allEvents.map(e => e.kind));

    function applyFilter() {
        const filtered = allEvents.filter(e => activeKinds.has(e.kind));
        calendar.setData({ events: filtered, currentYear });
    }

    applyFilter();


    calendar.addEventListener("calendar-event-click", onEventClick);
    calendar.addEventListener("calendar-year-select", (event) => {
        currentYear = event.detail.year;
        applyFilter();
    });
    document.getElementById("year-pdf-download-btn").addEventListener("click", () => {
        const pdfUrl = `https://emt-project.github.io/emt-pdf/emt_korrespondenz_${currentYear}.pdf`;
        window.open(pdfUrl, '_blank');
    });

    const calendarEl = document.querySelector("acdh-ch-calendar");
    document.querySelectorAll('.legend-toggle').forEach(btn => {
        btn.addEventListener('click', () => {
            const kind = btn.dataset.kind;
            if (activeKinds.has(kind)) {
                activeKinds.delete(kind);
            } else {
                activeKinds.add(kind);
            }
            if (btn.dataset.label) {
                btn.title = `${btn.dataset.label} ${activeKinds.has(kind) ? 'ausblenden' : 'anzeigen'}`;
            }
            applyFilter();
        });
    });
    // add a master toggle button to show/hide all letter kinds
    const letterToggles = document.querySelectorAll('#sender-panel .legend-toggle');
    document.getElementById('show-all-letters').addEventListener('click', () => {
        letterToggles.forEach(btn => {
            btn.classList.add('active');
            btn.setAttribute('aria-pressed', 'true');
            activeKinds.add(btn.dataset.kind);
        });
        applyFilter();
    });

    document.getElementById('hide-all-letters').addEventListener('click', () => {
        letterToggles.forEach(btn => {
            btn.classList.remove('active');
            btn.setAttribute('aria-pressed', 'false');
            activeKinds.delete(btn.dataset.kind);
        });
        applyFilter();
    });
}


function onEventClick(event) {
    var myModal = new bootstrap.Modal(document.getElementById("dataModal"), {});

    const { date, events } = event.detail;
    const modalBody = document.querySelector('#dataModal .modal-body');
    modalBody.innerHTML = "";
    const myUl = document.createElement("ul")

    events.forEach(item => {
        const li = document.createElement("li");
        if (item.link) {
            li.innerHTML = `
                <a href="${item.link}">${item.label}</a>
            `
            if (item.ref_by) {
                li.innerHTML += ` (Erwähnt in: <a href="${item.ref_by.link}">${item.ref_by.label}</a>)`
            }
        } else if (item.ref_by) {
            li.innerHTML = `${item.label} (Erwähnt in: <a href="${item.ref_by.link}">${item.ref_by.label}</a>)`
        }
        else {
            li.innerHTML = `${item.label}`
        }

        myUl.appendChild(li)
    });
    modalBody.appendChild(myUl)
    myModal.show()
}

async function request(url) {
    const response = await fetch(url);
    const events = await response.json();
    const expanded = [];
    events.forEach((event) => {
        if (event.range && event.kind === "visits") {
            const from = new Date(event.from);
            const to = new Date(event.to);
            for (let d = new Date(from); d <= to; d.setDate(d.getDate() + 1)) {
                const dateStr = d.toISOString().slice(0, 10);
                let kind = "visits";
                if (event.uncertainty) {
                    const isFrom = dateStr === event.from;
                    const isTo = dateStr === event.to;
                    if (
                        (event.uncertainty === "from" && isFrom) ||
                        (event.uncertainty === "to" && isTo) ||
                        (event.uncertainty === "both" && (isFrom || isTo))
                    ) {
                        kind = "visits_uncertain";
                    }
                }
                expanded.push({ ...event, date: new Date(d), kind });
            }
        } else {
            expanded.push({ ...event, date: new Date(event.date) });
        }
    });
    return expanded;
}

try {
    const events = await request("js-data/calendarData.json");
    createCalendar(de, events, onEventClick);
    console.log("Successfully created calendar.");
} catch (error) {
    console.error("Failed to create calendar.\n", String(error));
}