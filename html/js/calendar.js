import { register } from "../vendor/calendar-component/calendar.js";
import de from "../vendor/calendar-component/i18n/de.js";


register({});
// register()

function createCalendar(i18n, events, onEventClick) {
    const calendar = document.querySelector("acdh-ch-calendar");

    if (i18n != null) {
        /** Optionally set locale, defaults to english. */
        calendar.setI18n(i18n);
    }

    calendar.setData({ events, currentYear: 1696 });

    calendar.addEventListener("calendar-event-click", onEventClick);
    // const senders = new Map()
    // events.forEach(d => {
    //     if (d.sender === undefined) return;
    //     if (d.sender.link.includes("emt_person")) {
    //         senders.set(d.sender.link, d.sender.label)
    //     }
    //     else if (d.sender.label.includes("erschlossen")) {
    //         senders.set(false, d.sender.label)
    //     }
    // })
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
            if (item.ref_by){
                li.innerHTML += ` (Erwähnt in: <a href="${item.ref_by.link}">${item.ref_by.label}</a>)`
            }
        } else if (item.ref_by){
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
    return events.map((event) => {
        return { ...event, date: new Date(event.date) };
    });
}

try {
    const events = await request("js-data/calendarData.json");
    createCalendar(de, events, onEventClick);
    console.log("Successfully created calendar.");
} catch (error) {
    console.error("Failed to create calendar.\n", String(error));
}