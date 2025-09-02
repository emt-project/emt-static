// Add event listeners to checkboxes after the DOM is fully loaded
document.addEventListener('DOMContentLoaded', () => {
  const checkboxes = document.querySelectorAll('.search-attribute-checkbox');
  checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', (event) => {
      // If this checkbox is being unchecked
      if (!event.target.checked) {
        // Check if it's the last one checked
        const anyChecked = Array.from(checkboxes).some(cb => cb !== event.target && cb.checked);
        if (!anyChecked) {
          event.preventDefault();
          event.target.checked = true;
          alert('At least one search field must be selected.');
          return;
        }
      }

      updateSearchAttributes();
    });
  });
});

const updateSearchAttributes = () => {
  const selectedAttributes = Array.from(document.querySelectorAll('.search-attribute-checkbox:checked'))
    .map(checkbox => checkbox.value);
  const currentConfig = typesenseInstantsearchAdapter.configuration;
  typesenseInstantsearchAdapter.updateConfiguration({
    ...currentConfig,
    additionalSearchParameters: {
      query_by: selectedAttributes.join(', ')
    }
  });

  // Force search refresh with current query
  if (search.helper && search.helper.state.query) {
    search.helper.setClient(typesenseInstantsearchAdapter.searchClient);
    search.helper.search();
  }
}



const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    apiKey: "lGsWJtaz2LdOqNx2iiQeTwY68oLOdn1k",
    nodes: [
      {
        host: "typesense.acdh-dev.oeaw.ac.at",
        port: "443",
        protocol: "https",
      },
    ],
    cacheSearchResultsForSeconds: 2 * 60,
  },
  additionalSearchParameters: {
    query_by: "full_text, regest"
  },
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
      <p>${hit.persons.map((item) => html`<a href='${item.id}'><span class="badge rounded-pill m-1 bg-danger">${item}</span></a>`)}</p>
      <p>${hit.places.map((item) => html`<a href='${item.id}'><span class="badge rounded-pill m-1 bg-info">${item}</span></a>`)}</p>`
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

  instantsearch.widgets.refinementList({
    container: '#refinement-list-places',
    attribute: 'places',
    searchable: true,
    searchablePlaceholder: 'Suche',
    cssClasses: {
      searchableInput: 'form-control form-control-sm mb-2 border-light-2',
      searchableSubmit: 'd-none',
      searchableReset: 'd-none',
      showMore: 'btn btn-secondary btn-sm align-content-center',
      list: 'list-unstyled',
      count: 'badge m-2 badge-info',
      label: 'd-flex align-items-center',
      checkbox: 'm-2',
    }
  }),


  instantsearch.widgets.refinementList({
    container: '#refinement-list-sender',
    attribute: 'sender',
    searchable: true,
    searchablePlaceholder: 'Suche',
    cssClasses: {
      searchableInput: 'form-control form-control-sm mb-2 border-light-2',
      searchableSubmit: 'd-none',
      searchableReset: 'd-none',
      showMore: 'btn btn-secondary btn-sm align-content-center',
      list: 'list-unstyled',
      count: 'badge m-2 badge-secondary',
      label: 'd-flex align-items-center',
      checkbox: 'm-2',
    }
  }),
  instantsearch.widgets.refinementList({
    container: '#refinement-list-receiver',
    attribute: 'receiver',
    searchable: true,
    searchablePlaceholder: 'Suche',
    cssClasses: {
      searchableInput: 'form-control form-control-sm mb-2 border-light-2',
      searchableSubmit: 'd-none',
      searchableReset: 'd-none',
      showMore: 'btn btn-secondary btn-sm align-content-center',
      list: 'list-unstyled',
      count: 'badge m-2 badge-secondary',
      label: 'd-flex align-items-center',
      checkbox: 'm-2',
    }
  }),

  // instantsearch.widgets.refinementList({
  //     container: '#refinement-list-keywords',
  //     attribute: 'keywords',
  //     searchable: true,
  //     searchablePlaceholder: 'Suche',
  //     cssClasses: {
  //       searchableInput: 'form-control form-control-sm mb-2 border-light-2',
  //       searchableSubmit: 'd-none',
  //       searchableReset: 'd-none',
  //       showMore: 'btn btn-secondary btn-sm align-content-center',
  //       list: 'list-unstyled',
  //       count: 'badge m-2 badge-success',
  //       label: 'd-flex align-items-center',
  //       checkbox: 'm-2',
  //     }
  // }),
  instantsearch.widgets.refinementList({
    container: '#refinement-list-keywords',
    attribute: 'keywords',
    searchable: true,
    searchablePlaceholder: 'Suche',
    cssClasses: {
      searchableInput: 'form-control form-control-sm mb-2 border-light-2',
      searchableSubmit: 'd-none',
      searchableReset: 'd-none',
      showMore: 'btn btn-secondary btn-sm align-content-center',
      list: 'list-unstyled',
      count: 'badge m-2 badge-info',
      label: 'd-flex align-items-center',
      checkbox: 'm-2',
    }
  }),
  instantsearch.widgets.rangeInput({
    container: "#range-input",
    attribute: "year",
    templates: {
      separatorText: 'bis',
      submitText: 'Suchen',
    },
    cssClasses: {
      form: 'form-inline',
      input: 'form-control',
      submit: 'btn'
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
      button: 'btn'
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



search.start();