'use strict';

const Network = require('../../utils/network');
const React = require('react');
const ReactDOM = require('react-dom');
const Panel = require('../../components/panel').Panel;
const DataTree = require('./data-tree.js');
const Preprocessing = require('./data-processing/preprocessing.js');
const UI = require('./ui/components.js');
const Utils = require('./utils.js');

function displayHierarchy(data) {
  // disable the #spacewalk-content observer:
  // drawing svg triggers it for every small changes,
  // and it is not the desired behaviour/what the observer stands for
  // note: leaving it connected slow down the svg usability
  spacewalkContentObserver.disconnect();

  const container = Utils.prepareDom();
  const tree = DataTree.dataTree(data, container);
  if (view == 'grouping') { // hack - derive preprocessor from global variable
    tree.preprocessor(Preprocessing.grouping());
  }
  tree.refresh();

  initUI(tree);

  d3.select(window).on('resize', function () {
    const dimensions = Utils.computeSvgDimensions();
    // try to find the object via d3
    d3.select('#svg-wrapper svg')
    .attr('width', dimensions[0])
    .attr('height', dimensions[1]);
  });
}

// util function for adding the UI to the dom and setting its callbacks
function initUI(tree) {
  // System name filter
  UI.addFilter(d3.select('#filter-wrapper'), 'Filter by system name', 'e.g., client.nue.sles', (input) => {
    tree.filters().put('name', d => d.data.name.toLowerCase().includes(input.toLowerCase()));
    tree.refresh();
  });

  // Patch count filter
  const patchCountsFilter = d3.select('#filter-wrapper')
    .append('div').attr('class', 'filter');

  patchCountsFilter
    .append('label')
    .text('Show systems with:');

  // state of the patch status checkboxes:
  // [bug fix adv. checked, prod. enhancements checked, security adv. checked]
  const patchCountFilterConfig = [false, false, false];
  // create a callback function that
  //  - updates patchCountFilterConfig at given index,
  //  - updates the filters based on patchCountFilterConfig
  //  - refreshes the tree
  function patchCountFilterCallback(idx) {
    return function(checked) {
      patchCountFilterConfig[idx] = checked;
      if (!patchCountFilterConfig.includes(true)) {
        tree.filters().remove('patch_count_filter');
      } else {
        tree.filters().put('patch_count_filter', d => {
          return Utils.isSystemType(d) &&
          patchCountFilterConfig // based on the checkboxes state, take into account the patch count
          .map((value, index) => value && (d.data.patch_counts || [])[index] > 0)
          .reduce((a, b) => a || b, false);
        });
      }
      tree.refresh();
    }
  }
  UI.addCheckbox(patchCountsFilter, 'security advisories', 'fa-shield', 'security-patches', patchCountFilterCallback(2));
  UI.addCheckbox(patchCountsFilter, 'bug fix advisories', 'fa-bug', 'bug-patches', patchCountFilterCallback(0));
  UI.addCheckbox(patchCountsFilter, 'product enhancement advisories', 'spacewalk-icon-enhancement', 'minor-patches', patchCountFilterCallback(1));

  // Base channel filter
  UI.addFilter(d3.select('#filter-wrapper'), 'Filter by system base channel', 'e.g., SLE12', (input) => {
    tree.filters().put('base_channel', d => (d.data.base_channel || '').toLowerCase().includes(input.toLowerCase()));
    tree.refresh();
  });

  // Installed products filter
  UI.addFilter(d3.select('#filter-wrapper'), 'Filter by system installed products', 'e.g., SLES', (input) => {
    if (input == undefined || input == '') {
      tree.filters().remove('installedProducts');
    } else {
      tree.filters().put('installedProducts', d => (d.data.installedProducts || [])
        .map(ip => ip.toLowerCase().includes(input.toLowerCase()))
        .reduce((v1,v2) => v1 || v2, false));
    }
    tree.refresh();
  });

  // Grouping UI (based on the preprocessor type)
  if (tree.preprocessor().groupingConfiguration) { // we have a processor responding to groupingConfiguration
    UI.addGroupSelector(d3.select('#filter-wrapper'),
        tree.data().map(e => e.managed_groups || []).reduce((a,b) => a.concat(b)),
        (data) => {
          tree.preprocessor().groupingConfiguration(data);
          tree.refresh();
        });
  }

  // Partitioning by checkin time
  function partitionByCheckin(datetime) {
    tree.partitioning().get()['user-partitioning'] = d => {
      if (d.data.checkin == undefined) {
        return '';
      }
      const firstPartition = d.data.checkin < datetime.getTime();
      d.data.partition = firstPartition;
      return firstPartition  ? 'stroke-red non-checking-in' : 'stroke-green checking-in';
    };
    tree.refresh();
  }

  UI.addCheckinTimePartitioningSelect('#filter-wrapper', partitionByCheckin);

  // Partitioning by patch existence
  const hasPatchesPartitioning = d3.select('#filter-wrapper')
    .append('div').attr('class', 'filter');

  hasPatchesPartitioning
    .append('div')
    .attr('class', 'filter-title')
    .text('Partition systems based on whether there are patches for them:');

  function applyPatchesPartitioning() {
    tree.partitioning().get()['user-partitioning'] = d => {
      if (d.data.patch_counts == undefined) {
        return '';
      }
      const firstPartition = d.data.patch_counts.filter(pc => pc > 0).length > 0;
      d.data.partition = firstPartition;
      return firstPartition  ? 'stroke-red unpatched' : 'stroke-green patched';
    };
    tree.refresh();
  }

  UI.addButton(hasPatchesPartitioning, 'Apply', applyPatchesPartitioning);

  UI.addButton(d3.select('#filter-wrapper'), 'Reset partitioning', () => {
    tree.partitioning().get()['user-partitioning'] = d => { return ''};
    tree.refresh();
  });
}

const Hierarchy = React.createClass({
  componentDidMount: function() {
    // Get data & put everything together in the graph!
    Network
      .get(endpoint, 'application/json')
      .promise
      .then(
        (data) => $(document).ready(() => displayHierarchy(data)),
        (xhr) =>  d3.select('#svg-wrapper').text(t('There was an error fetching data from the server.'))
      );
  },

  showFilters: function() {
    $('#filter-wrapper').toggle();
  },

  render: function() {
    return (
      <Panel title={t(title)}>
        <button id='toggle-svg-filter' className='btn btn-default' onClick={this.showFilters}>{t('Toggle filters')}</button>
        <div id='svg-wrapper'>
          <div id='filter-wrapper'></div>
          <div className='detailBox'></div>
        </div>
      </Panel>
    );
  }
});

ReactDOM.render(
  <Hierarchy />,
  document.getElementById('hierarchy')
);