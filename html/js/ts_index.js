const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    // apiKey: "lGsWJtaz2LdOqNx2iiQeTwY68oLOdn1k",
    // nodes: [
    //   {
    //     host: "typesense.acdh-dev.oeaw.ac.at",
    //     port: "443",
    //     protocol: "https",
    //   },
    // ],
    apiKey: "wGufrCvmagp3u285ViWYErQL1t8rzF85",
    nodes: [{
      host: "localhost",
      port: 8108,
      protocol: "http"
    }],
    cacheSearchResultsForSeconds: 2 * 60,
  },
  additionalSearchParameters: {
    query_by: "full_text, regest",
  }
});

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
  indexName: 'emt',
  searchClient,
})

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#searchbox',
    autofocus: true,
    showSubmit: true,
    showReset: true,
    cssClasses: {
      form: 'form-inline',
      input: 'form-control col-md-11',
      submit: 'btn',
      reset: 'btn'
    },
  }),



  instantsearch.widgets.hits({
    container: '#hits',
    cssClasses: {
      item: "w-100"
    },
    templates: {
      empty: "Keine Resultate für <q>{{ query }}</q>",
      item(hit, { html, components }) {
        return html`
      <h4><a href='${hit.id}.html'>${hit.title}</a></h4>
      <p>${hit._snippetResult.regest.matchedWords.length > 0 ? components.Snippet({ hit, attribute: 'regest' }) : ''}</p>
      <p>${hit._snippetResult.full_text.matchedWords.length > 0 ? components.Snippet({ hit, attribute: 'full_text' }) : ''}</p>
      <p>${hit.sender ? html`<a href='${hit.sender.id}.html'><span class="badge rounded-pill m-1 entity-person">${hit.sender.name}</span></a>` : ''} 
      ${hit.receiver ? html`<a href='${hit.receiver.id}.html'><span class="badge rounded-pill m-1 entity-person">${hit.receiver.name}</span></a>` : ''} ${hit.sent_from ? html`<a href='${hit.sent_from.id}.html'><span class="badge rounded-pill m-1 entity-place">${hit.sent_from.name}</span></a>` : ''}</p>`
      }
    },
  }),

  instantsearch.widgets.stats({
    container: '#stats-container',
    templates: {
      text: `
        {{#areHitsSorted}}
          {{#hasNoSortedResults}}Keine Treffer{{/hasNoSortedResults}}
          {{#hasOneSortedResults}}1 Treffer{{/hasOneSortedResults}}
          {{#hasManySortedResults}}{{#helpers.formatNumber}}{{nbSortedHits}}{{/helpers.formatNumber}} Treffer {{/hasManySortedResults}}
          aus {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}}
        {{/areHitsSorted}}
        {{^areHitsSorted}}
          {{#hasNoResults}}Keine Treffer{{/hasNoResults}}
          {{#hasOneResult}}1 Treffer{{/hasOneResult}}
          {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} Treffer{{/hasManyResults}}
        {{/areHitsSorted}}
        gefunden in {{processingTimeMS}}ms
      `,
    }
  }),
  // asc and desc flipped because date values are inverted
  instantsearch.widgets.sortBy({
    container: '#sort-by',
    items: [
      { label: 'Relevanz', value: 'emt' },
      { label: 'Datum (aufsteigend)', value: 'emt/sort/date:desc' },
      { label: 'Datum (absteigend)', value: 'emt/sort/date:asc' },
    ],
    cssClasses: {
      select: 'form-control'
    }
  }),

  // commented due to https://github.com/emt-project/emt-static/issues/71
  // instantsearch.widgets.refinementList({
  //   container: '#refinement-list-persons',
  //   attribute: 'persons',
  //   searchable: true,
  //   showMore: true,
  //   searchablePlaceholder: 'Suche',
  //   cssClasses: {
  //     searchableInput: 'form-control form-control-sm mb-2 border-light-2',
  //     searchableSubmit: 'd-none',
  //     searchableReset: 'd-none',
  //     showMore: 'btn btn-secondary btn-sm align-content-center',
  //     list: 'list-unstyled',
  //     count: 'badge m-2 badge-secondary',
  //     label: 'd-flex align-items-center',
  //     checkbox: 'm-2',
  //   }
  // }),



  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Absender'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)
    ({
      container: '#refinement-list-sender',
      attribute: 'sender.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-secondary',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Empfänger'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)
    ({
      container: '#refinement-list-receiver',
      attribute: 'receiver.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-secondary',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Absendeorte'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)({
      container: '#refinement-list-sent_from',
      attribute: 'sent_from.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-info',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Erwähnte Personen'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)
    ({
      container: '#refinement-list-mentioned_persons',
      attribute: 'mentioned_persons.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-secondary',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Erwähnte Orte'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)({
      container: '#refinement-list-mentioned_places',
      attribute: 'mentioned_places.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-info',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Organisationen'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)({
      container: '#refinement-list-orgs',
      attribute: 'orgs.name',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-info',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    collapsed: true,
    templates: {
      header: 'Schlagworte'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.refinementList)({
      container: '#refinement-list-keywords',
      attribute: 'keywords',
      searchable: true,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        // showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge m-2 badge-info',
        label: 'd-flex align-items-center',
        checkbox: 'm-2',
      }
    }),
  instantsearch.widgets.panel({
    templates: {
      header: 'Jahr'
    },
    cssClasses: {
      header: 'fs-6',
    }
  })(
    instantsearch.widgets.rangeInput)
    ({
      container: "#range-input",
      attribute: "year",
      templates: {
        separatorText: 'bis',
        submitText: 'Suchen',
      },
      cssClasses: {
        form: 'form-inline',
        input: 'form-control',
        submit: 'button-custom'
      }
    }),

  instantsearch.widgets.pagination({
    container: '#pagination',
    padding: 2,
    cssClasses: {
      list: 'pagination',
      item: 'page-item',
      link: 'page-link'
    }
  }),
  instantsearch.widgets.clearRefinements({
    container: '#clear-refinements',
    templates: {
      resetLabel: 'Filter zurücksetzen',
    },
    cssClasses: {
      button: 'custom-button'
    }
  }),



  instantsearch.widgets.currentRefinements({
    container: '#current-refinements',
    cssClasses: {
      delete: 'btn',
      label: 'badge'
    }
  })
]);



search.addWidgets([
  instantsearch.widgets.configure({
    attributesToSnippet: ['full_text', 'regest'],
  })
]);

// Add event listeners to checkboxes after the DOM is fully loaded
document.addEventListener('DOMContentLoaded', () => {
  const select = document.getElementById('search-field-select');
  const applyQueryBy = (queryBy) => {
    const currentConfig = typesenseInstantsearchAdapter.configuration;
    typesenseInstantsearchAdapter.updateConfiguration({
      ...currentConfig,
      additionalSearchParameters: {
        query_by: queryBy
      }
    });
    if (search.helper) {
      search.helper.setClient(typesenseInstantsearchAdapter.searchClient);
      search.helper.search();
    }
  };

  // Initial sync (in case adapter default differs)
  applyQueryBy(select.value);

  select.addEventListener('change', () => {
    applyQueryBy(select.value);
  });
});

// Force search refresh with current query
if (search.helper && search.helper.state.query) {
  search.helper.setClient(typesenseInstantsearchAdapter.searchClient);
  search.helper.search();
}


search.start();