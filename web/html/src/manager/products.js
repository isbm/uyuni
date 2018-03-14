'use strict';

const React = require('react');
const ReactDOM = require('react-dom');
const Network = require('../utils/network');
const Messages = require('../components/messages').Messages;
const MessagesUtils = require("../components/messages").Utils;
const {DataHandler, DataItem, SearchField, Highlight} = require('../components/data-handler');
const Functions = require('../utils/functions');
const Utils = Functions.Utils;
const {ModalButton, ModalLink} = require("../components/dialogs");
const Button = require('../components/buttons').Button;
const SCCDialog = require('./products-scc-dialog').SCCDialog;
const PopUp = require("../components/popup").PopUp;
const ProgressBar = require("../components/progressbar").ProgressBar;
const CustomDiv = require("../components/custom-objects").CustomDiv;

const _DATA_ROOT_ID = 'baseProducts';

const _SETUP_WIZARD_STEPS = [
  {
    id: 'wizard-step-proxy',
    label: 'HTTP Proxy',
    url: '/rhn/admin/setup/ProxySettings.do',
    active: false
  },
  {
    id: 'wizard-step-credentials',
    label: 'Organization Credentials',
    url: '/rhn/admin/setup/MirrorCredentials.do',
    active: false
  },
  {
    id: 'wizard-step-suse-products',
    label: 'SUSE Products',
    url: location.href.split(/\?|#/)[0],
    active: true
  }
];

const _PRODUCT_STATUS = {
  installed: 'INSTALLED',
  available: 'AVAILABLE',
  unavailable: 'UNAVAILABLE'
};

const _CHANNEL_STATUS = {
  notSynced: 'NOT_MIRRORED',
  syncing: 'IN_PROGRESS',
  synced: 'FINISHED',
  failed: 'FAILED'
};

const _COLS = {
  selector: { width: 2, um: 'em' },
  showSubList: { width: 2, um: 'em'},
  description: { width: undefined, um: 'px'},
  arch: { width: 6, um: 'em' },
  channels: { width: 5, um: 'em' },
  mix: { width: 12, um: 'em'}
}

function reloadData() {
  return Network.get('/rhn/manager/api/admin/products', 'application/json').promise;
}

const ProductPageWrapper = React.createClass({
  getInitialState: function() {
    return {
      issMaster: issMaster_flag_from_backend,
      refreshNeeded: refreshNeeded_flag_from_backend,
      refreshRunning: refreshRunning_flag_from_backend,
      serverData: {_DATA_ROOT_ID : []},
      errors: [],
      loading: true,
      selectedItems: [],
      showPopUp: // trigger the refresh at the first page load if
        refreshNeeded_flag_from_backend &&
        issMaster_flag_from_backend &&
        !refreshRunning_flag_from_backend,
      syncRunning: false,
      addingProducts: false,
      syncingSingleProducts: []
    }
  },

  componentWillMount: function() {
    if (!this.state.refreshRunning) {
      this.refreshServerData();
    }
  },

  refreshServerData: function(dataUrlTag) {
    this.setState({loading: true});
    var currentObject = this;
    reloadData()
      .then(data => {
        currentObject.setState({
          serverData: data[_DATA_ROOT_ID],
          errors: [],
          loading: false
        });
      })
      .catch(this.handleResponseError);
  },

  handleSelectedItems: function(items) {
    this.setState({ selectedItems: items });
  },

  clearSelection: function() {
    this.setState({ selectedItems: [] });
  },

  showPopUp: function() {
    this.setState({showPopUp: true});
  },

  closePopUp: function() {
    this.setState({showPopUp: false});
  },

  updateSyncRunning: function(syncStatus) {
    // if it was running and now it's finished
    if (this.state.syncRunning && !syncStatus) {
      this.refreshServerData(); // reload data
    }

    if (syncStatus) {
      this.setState({ errors: MessagesUtils.info(t('The product catalog refresh is running..')) });
    }
    this.setState({ syncRunning: syncStatus });
  },

  submit: function() {
    const currentObject = this;
    currentObject.setState({ addingProducts: true });
    Network.post(
        '/rhn/manager/admin/setup/products',
        JSON.stringify(currentObject.state.selectedItems), 'application/json'
    ).promise.then(data => {
      // returned data format is { productId : isFailedFlag }
      let failedProducts = currentObject.state.selectedItems.filter(id => data[id]).map(id => id);
      let resultMessages = null;
      if (failedProducts.length == 0) {
        resultMessages = MessagesUtils.success('All the products were installed succesfully.')
      }
      else {
        resultMessages = MessagesUtils.warning(
          'The following product installations failed: \'' + failedProducts.reduce((a,b) => a + ', ' + b) + '\'. Please check log files.'
        );
      }
      currentObject.setState(
        {
          errors: resultMessages,
          selectedItems : [],
          addingProducts: false}
      );
      this.refreshServerData();
    })
    .catch(currentObject.handleResponseError);
  },

  resyncProduct: function(id, name) {
    const currentObject = this;
    var syncingSingleProductsInProgress = currentObject.state.syncingSingleProducts.concat([id]);
    currentObject.setState({ syncingSingleProducts: syncingSingleProductsInProgress});
    Network.post('/rhn/manager/admin/setup/products', JSON.stringify([id]), 'application/json').promise
    .then(data => {
      if(!data[id]) {
        currentObject.setState({
          errors: MessagesUtils.success('The product \'' + name + '\' sync has been scheduled successfully'),
          syncingSingleProducts: syncingSingleProductsInProgress.filter(i => i != id)
        });
      }
      else {
        currentObject.setState({
          errors: MessagesUtils.warning('The product \'' + name + '\' sync was not scheduled correctly. Please check server log files.'),
          syncingSingleProducts: syncingSingleProductsInProgress.filter(i => i != id)
        });
      }
    })
    .catch(currentObject.handleResponseError);
  },

  handleResponseError: function(jqXHR, arg = "") {
    const msg = Network.responseErrorMessage(jqXHR,
      (status, msg) => msgMap[msg] ? t(msgMap[msg], arg) : null);
    this.setState({ errors: this.state.errors.concat(msg) });
  },

  render: function() {
    const title =
      <div className='spacewalk-toolbar-h1'>
        <h1>
          <i className='fa fa-cogs'></i>
          &nbsp;
          {t('Setup Wizard')}
          &nbsp;
          <a href='/rhn/help/reference/en-US/ref.webui.admin.jsp#ref.webui.admin.wizard'
              target='_blank'><i className='fa fa-question-circle spacewalk-help-link'></i>
          </a>
        </h1>
      </div>
    ;

    const tabs = 
      <div className='spacewalk-content-nav'>
        <ul className='nav nav-tabs'>
          { _SETUP_WIZARD_STEPS.map(step => <li key={step.id} className={step.active ? 'active' : ''}><a href={step.url}>{t(step.label)}</a></li>)}
        </ul>
      </div>;

    let pageContent;
    if (this.state.refreshRunning) {
      pageContent = (
        <div className='alert alert-warning' role='alert'>
          {t('A refresh of the product data is currently running in the background. Please try again later.')}
        </div>
      );
    }
    else if (this.state.issMaster) {
      const submitButtonTitle =
        this.state.syncRunning ?
          t('The product catalog is still refreshing, please wait.')
          : this.state.selectedItems.length == 0 ?
              t('Select some product first.')
              : null;
      const addProductButton = (
        this.state.syncRunning || this.state.selectedItems.length == 0 || this.state.addingProducts ?
        <Button
            id="addProducts"
            icon={this.state.addingProducts ? 'fa-plus-circle fa-spin' : 'fa-plus'}
            className='btn-default text-muted'
            title={submitButtonTitle}
            text={t('Add products')}
        />
        :
        <Button
            id="addProducts"
            icon="fa-plus"
            className={'btn-success'}
            text={t('Add products') + (this.state.selectedItems.length > 0 ? ' (' + this.state.selectedItems.length + ')' : '')}
            handler={this.submit}
        />
      );

      pageContent = (
        <div className='row' id='suse-products'>
          <div className='col-sm-9'>
            <Messages items={this.state.errors}/>
            <div>
              <div className='spacewalk-section-toolbar'>
                <div className='action-button-wrapper'>
                  <div className='btn-group'>
                    <ModalButton
                        className='btn btn-default'
                        id='sccRefresh'
                        icon={'fa-refresh ' + (this.state.syncRunning ? 'fa-spin' : '')}
                        title={
                          this.state.syncRunning ?
                            t('The product catalog refresh is running..')
                            : t('Refreshes the product catalog from the Customer Center')
                        }
                        text={t('Refresh')}
                        target='scc-refresh-popup'
                        onClick={() => this.showPopUp()}
                    />
                    <Button
                        id="clearSelection"
                        icon='fa-eraser'
                        className={'btn-default ' + (this.state.selectedItems.length == 0 ? 'text-muted' : '')}
                        title={t('Clear products selection')}
                        text={t('Clear')}
                        handler={this.clearSelection}
                    />
                    {addProductButton}
                  </div>
                </div>
              </div>
              <Products
                  data={this.state.serverData}
                  loading={this.state.loading}
                  handleSelectedItems={this.handleSelectedItems}
                  selectedItems={this.state.selectedItems}
                  resyncProduct={this.resyncProduct}
                  syncingSingleProducts={this.state.syncingSingleProducts}
              />
            </div>
          </div>
          <div className='col-sm-3 hidden-xs' id='wizard-faq'>
              <h4>{t("Why aren't all SUSE products displayed in the list?")}</h4>
              <p>{t('The products displayed on this list are directly linked to your \
                  Organization credentials (Mirror credentials) as well as your SUSE subscriptions.')}</p>
              <p>{t('If you believe there are products missing, make sure you have added the correct \
                  Organization credentials in the previous wizard step.')}</p>
          </div>
        </div>
      );
    }
    else {
      pageContent = (
        <div className='alert alert-warning' role='alert'>
          {t('This server is configured as an Inter-Server Synchronisation (ISS) slave. SUSE Products can only be managed on the ISS master.')}
        </div>
      );
    }

    const prevStyle = { 'marginLeft': '10px' , 'verticalAlign': 'middle'};
    const currentStepIndex = _SETUP_WIZARD_STEPS.indexOf(_SETUP_WIZARD_STEPS.find(step => step.active));
    const footer =
      <div className='panel-footer'>
        <div className='btn-group'>  
          {
            currentStepIndex > 1 ?
              <a className='btn btn-default' href={_SETUP_WIZARD_STEPS[currentStepIndex-1].url}>
                <i className='fa fa-arrow-left'></i>{t('Prev')}
              </a> : null
          }
          {
            currentStepIndex < (_SETUP_WIZARD_STEPS.length - 1) ?
              <a className='btn btn-success' href={_SETUP_WIZARD_STEPS[currentStepIndex+1].url}>
                <i className='fa fa-arrow-right'></i>{t('Next')}
              </a> : null
          }
        </div>
        <span style={prevStyle}>
          { currentStepIndex+1 }&nbsp;{t('of')}&nbsp;{ _SETUP_WIZARD_STEPS.length }
        </span>
      </div>;

    return (
      <div className='responsive-wizard'>
        {title}
        {tabs}
        <div className='panel panel-default' id='products-content'>
            <div className='panel-body'>
              {pageContent}
            </div>
        </div>
        <SCCDialog
            onClose={() => this.closePopUp}
            start={this.state.showPopUp && !this.state.syncRunning}
            updateSyncRunning={(syncStatus) => this.updateSyncRunning(syncStatus)}
          />
        {footer}
      </div>
    )
  }
});

const Products = React.createClass({
  getInitialState: function() {
    return {
      popupItem: null,
      archCriteria: []
    }
  },

  componentDidMount: function() {
    const currentObject = this;

    //HACK: usage of JQuery here is needed to apply the select2js plugin
    $('select#product-arch-filter.apply-select2js-on-this').each(function(i) {
      var select = $(this);
      // apply select2js only one time
      if (!select.hasClass('select2js-applied')) {
        select.addClass('select2js-applied');

        var select2js = select.select2({placeholder: t('Filter by architecture')});
        select2js.on("change", function(event) {
          currentObject.handleFilterArchChange(select.val() || []);
        });
      }
    });
  },

  getDistinctArchsFromData: function(data) {
    var archs = [];
    Object.keys(data).map((id) => data[id])
        .forEach(function(x) { if (!archs.includes(x.arch)) archs.push(x.arch); });
    return archs;
  },

  handleFilterArchChange: function(archs) {
    this.setState({archCriteria: archs});
  },

  filterDataByArch: function(data) {
    if(this.state.archCriteria.length > 0) {
      return data.filter(p => this.state.archCriteria.includes(p.arch));
    }
    return data;
  },

  handleSelectedItems: function(ids) {
    let arr = this.props.selectedItems;
    ids.forEach(id => {
      if(!arr.includes(id)) {
        arr = arr.concat([id]);
      }
    });
    this.props.handleSelectedItems(arr);
  },

  handleUnselectedItems: function(ids) {
    let arr = this.props.selectedItems;
    ids.forEach(id => {
      arr = arr.filter(i => i !== id);
    });
    this.props.handleSelectedItems(arr);
  },

  searchData: function(datum, criteria) {
    if (criteria) {
      return (datum.label).toLowerCase().includes(criteria.toLowerCase());
    }
    return true;
  },

  buildRows: function(message) {
    return Object.keys(message).map((id) => message[id]);
  },

  showChannelsfor: function(item) {
    this.setState({popupItem: item});
  },

  render: function() {
    const titlePopup = t('Product Channels - ') + (this.state.popupItem != null ? this.state.popupItem['label'] : '');
    const contentPopup = 
      this.state.popupItem != null ?
        (
          <div>
            {
              this.state.popupItem['channels'].filter(c => !c.optional).length > 0 ?
                <div>
                  <h4>Mandatory Channels</h4>
                  <ul className='product-channel-list'>
                    {
                      this.state.popupItem['channels']
                        .filter(c => !c.optional)
                        .map(c => <li>{c.summary}&nbsp;<small>[{c.label}]</small></li>)
                    }
                  </ul>
                </div>
                : null
            }
            {
              this.state.popupItem['channels'].filter(c => c.optional).length > 0 ?
                <div>
                  <h4>Optional Channels</h4>
                  <ul className='product-channel-list'>
                    {
                      this.state.popupItem['channels']
                        .filter(c => c.optional)
                        .map(c => <li key={c.summary}>{c.summary}&nbsp;<small>[{c.label}]</small></li>)
                    }
                  </ul>
                </div>
                : null
            }
          </div>
        )
      : null ;
    const archFilter =
      <div className='multiple-select-wrapper'>
        <select id='product-arch-filter' className='form-control d-inline-block apply-select2js-on-this' multiple='multiple'>
          { this.getDistinctArchsFromData(this.props.data).map(a => <option key={a} value={a}>{a}</option>) }
        </select>
      </div>;
    return (
      <div>
        <DataHandler
          data={this.buildRows(this.filterDataByArch(this.props.data))}
          identifier={(raw) => raw['identifier']}
          initialItemsPerPage={userPrefPageSize}
          loading={this.props.loading}
          additionalFilters={[archFilter]}
          searchField={
              <SearchField filter={this.searchData}
                  criteria={''}
                  placeholder={t('Filter by product Description')} />
          }>
          <CheckList data={d => d}
              nestedKey='extensions'
              isSelectable={true}
              handleSelectedItems={this.handleSelectedItems}
              handleUnselectedItems={this.handleUnselectedItems}
              selectedItems={this.props.selectedItems}
              listStyleClass='product-list'
              isFirstLevel={true}
              showChannelsfor={this.showChannelsfor}
              cols={_COLS}
              resyncProduct={this.props.resyncProduct}
              syncingSingleProducts={this.props.syncingSingleProducts}
          />
        </DataHandler>
        <PopUp
            id='show-channels-popup'
            title={titlePopup}
            content={contentPopup}
            className='modal-xs'
        />
      </div>
    )
  }
});

const CheckList = React.createClass({
  handleSelectedItems: function(ids) {
    this.props.handleSelectedItems(ids);
  },

  handleUnselectedItems: function(ids) {
    this.props.handleUnselectedItems(ids);
  },

  render: function() {
    return (
      this.props.data ?
        <ul className={this.props.listStyleClass}>
          {
            this.props.isFirstLevel ?
              <li className='list-header'>
                <CustomDiv className='col text-center' width={this.props.cols.selector.width} um={this.props.cols.selector.um}></CustomDiv>
                <CustomDiv className='col text-center' width={this.props.cols.showSubList.width} um={this.props.cols.showSubList.um}></CustomDiv>
                <CustomDiv className='col col-class-calc-width'>{t('Product Description')}</CustomDiv>
                <CustomDiv className='col' width={this.props.cols.arch.width} um={this.props.cols.arch.um} title={t('Architecture')}>{t('Arch')}</CustomDiv>
                <CustomDiv className='col text-center' width={this.props.cols.channels.width} um={this.props.cols.channels.um}>{t('Channels')}</CustomDiv>
                <CustomDiv className='col text-right' width={this.props.cols.mix.width} um={this.props.cols.mix.um}></CustomDiv>
              </li>
              : null
          }
          {
            this.props.data.map((l, index) =>
            {
              return (
                <CheckListItem
                    key={l['identifier']}
                    item={l}
                    handleSelectedItems={this.handleSelectedItems}
                    handleUnselectedItems={this.handleUnselectedItems}
                    selectedItems={this.props.selectedItems}
                    nestedKey={this.props.nestedKey}
                    isSelectable={true}
                    isFirstLevel={this.props.isFirstLevel}
                    index={index}
                    showChannelsfor={this.props.showChannelsfor}
                    listStyleClass={this.props.listStyleClass}
                    childrenDisabled={this.props.isFirstLevel ? false : this.props.childrenDisabled}
                    cols={this.props.cols}
                    resyncProduct={this.props.resyncProduct}
                    syncingSingleProducts={this.props.syncingSingleProducts}
                />
              )
            })
          }
        </ul>
        : null
    )
  }
});

const CheckListItem = React.createClass({
  getInitialState: function() {
    return {
      itemsWithSublistVisible: [],
      withRecommended: true,
      isSelected: this.props.selectedItems.includes(this.props.item.identifier),
      isInstalled: this.props.item.status == _PRODUCT_STATUS.installed,
      isScheduled: false,
    }
  },

  componentWillReceiveProps: function(nextProps) {
    const isSelectedNew = nextProps.selectedItems.includes(this.props.item.identifier);
    const isInstalledNew = nextProps.item.status == _PRODUCT_STATUS.installed;
    this.setState({isSelected: isSelectedNew, isInstalled: isInstalledNew});
  },

  isSublistVisible: function() {
    return this.state.itemsWithSublistVisible.includes(this.props.item['identifier']);
  },

  handleSubListVisibility: function(id) {
    let arr = this.state.itemsWithSublistVisible;
    if(arr.includes(id)) {
      arr = arr.filter(i => i !== id);
    } else {
      arr = arr.concat([id]);
    }
    this.setState({itemsWithSublistVisible: arr});
  },

  handleSelectedItem: function(id) {
    // add base product first (the server fails if it tries to add extentions first)
    let arr = [id];

    // this item was selected but it is going to be removed from the selected set,
    // so all children are going to be removed as well
    if(this.state.isSelected) {
      arr = arr.concat(this.getNestedData().map(el => el.identifier));
      this.handleUnselectedItems(arr);
    }
    else {
      // this item was not selected and it is going to be added to the selected set,

      // if any required product, add them first
      if (this.props.item.required) {
        arr = this.props.item.required.concat(arr);
      }

      // if it has the recommended flag enabled,
      // all recommended children are going to be added as well
      if (this.state.withRecommended) {
        arr = arr.concat(this.getRecommendedChildren().map(el => el.identifier));
      }
      this.handleSelectedItems(arr);
    }
  },

  getRecommendedChildren: function() {
    return this.getNestedData().filter(el => el.recommended);
  },

  handleSelectedItems: function(ids) {
    this.props.handleSelectedItems(ids);
  },

  handleUnselectedItems: function(ids) {
    this.props.handleUnselectedItems(ids);
  },

  handleWithRecommended: function() {
    const withRecommendedNow = !this.state.withRecommended;
    this.setState({withRecommended: withRecommendedNow});
    // only if this item is already selected
    if (this.state.isSelected) {
      // if the recommended flag is now enabled, select all recommended children
      if (withRecommendedNow) {
        this.props.handleSelectedItems(this.getRecommendedChildren().map(el => el.identifier));
      }
      else {
        this.props.handleUnselectedItems(this.getRecommendedChildren().map(el => el.identifier));
      }
    }
  },

  isResyncActionInProgress: function(id) {
    return this.props.syncingSingleProducts.includes(this.props.item['identifier']);
  },

  resyncProduct: function(id, label) {
    if (!this.isResyncActionInProgress(id)){
      this.props.resyncProduct(id, label);
    }
  },

  getNestedData: function() {
    if (this.props.item &&
        this.props.nestedKey &&
        this.props.item[this.props.nestedKey] != null) {
     return this.props.item[this.props.nestedKey];
    }
    return [];
  },

  render: function() {
    /** generate item selector content **/
    const selectorContent =
      this.props.isSelectable && this.props.item.status == _PRODUCT_STATUS.available ?
        <input type='checkbox'
            value={this.props.item['identifier']}
            onChange={() => this.handleSelectedItem(this.props.item['identifier'])}
            checked={this.state.isSelected ? 'checked' : ''}
            disabled={this.props.childrenDisabled ? 'disabled' : ''}
            title={this.props.childrenDisabled ? t('To enable this product, the parent product should be selected first') : t('Select this product')}
        />
        : null;
    /*****/

    /** generate show nested list icon **/
    let showNestedDataIconContent;
    if (this.getNestedData().length > 0) {
      const openSubListIconClass = this.isSublistVisible() ? 'fa-angle-down' : 'fa-angle-right';
      showNestedDataIconContent = <i className={'fa ' + openSubListIconClass + ' fa-1-5x pointer'}
          onClick={() => this.handleSubListVisibility(this.props.item['identifier'])} />;
    }
    /*****/

    /** generate product description content **/
    const productLabelStatus = this.state.isInstalled ? 'text-muted' : '';
    const handleDescriptionClick =
      this.getNestedData().length > 0 ?
        () => this.handleSubListVisibility(this.props.item['identifier'])
        : null;
    let productDescriptionContent =
      <span className={'cursor-default ' + productLabelStatus} onClick={handleDescriptionClick}>
        {this.props.item['label']}&nbsp;
        {
          this.props.item.recommended ?
            <span className='text-info'>(<u title={'This extension is recommended'}>recommended</u>)</span>
            : null
        }
      </span>;
    /*****/

    /** generate recommended toggler if needed **/
    let recommendedTogglerContent;
    if (this.getNestedData().some(i => i.recommended)) {
      if (this.state.withRecommended) {
      recommendedTogglerContent =
        <span  className='pointer text-info' onClick={() => this.handleWithRecommended()}>
          <i className='fa fa-1-5x fa-toggle-on' />
          &nbsp;
          {t('with recommended')}
        </span>;
      }
      else {
        recommendedTogglerContent =
          <span className='pointer text-muted' onClick={() => this.handleWithRecommended()}>
            <i className='fa fa-1-5x fa-toggle-off' />
            &nbsp;
            {t('with recommended')}
          </span>;
      }
    }
    /*****/

    /** generate channel sync progress bar **/
    let channelSyncContent;
    if (this.state.isInstalled) {
      const mandatoryChannelList = this.props.item['channels'].filter(c => !c.optional);

      // if any failed sync channel, show the error only
      if (mandatoryChannelList.filter(c => c.status == _CHANNEL_STATUS.failed).length > 0) {
        channelSyncContent = <span className="text-danger">{t('Sync failed')}</span>;
      }
      else {
        const syncedChannels = mandatoryChannelList.filter(c => c.status == _CHANNEL_STATUS.synced).length;
        const toBeSyncedChannels = mandatoryChannelList.length;
        const channelSyncProgress = Math.round(( syncedChannels / toBeSyncedChannels ) * 100);
        channelSyncContent = <ProgressBar progress={channelSyncProgress} title={t('Product sync status')} width='70%'/>;
      }
    }
    /*****/

    /** generate product resync button **/
    const resyncActionInProgress = this.isResyncActionInProgress(this.props.item['identifier']);
    const resyncActionContent =
      this.state.isInstalled ?
        <i className={'fa fa-refresh fa-1-5x pointer ' + (resyncActionInProgress ? 'fa-spin text-muted' : '')}
            title={resyncActionInProgress ? t('Scheduling a product resync') : t('Resync product')}
            onClick={() => this.resyncProduct(this.props.item['identifier'], this.props.item['label'])} />
        : null;
    /*****/

    let evenOddClass = (this.props.index % 2) === 0 ? "list-row-even" : "list-row-odd";

    return (
      <li className={evenOddClass} key={this.props.item['identifier']}>
        <CustomDiv className='col text-center' width={this.props.cols.selector.width} um={this.props.cols.selector.um}>{selectorContent}</CustomDiv>
        <CustomDiv className='col text-center' width={this.props.cols.showSubList.width} um={this.props.cols.showSubList.um}>{showNestedDataIconContent}</CustomDiv>
        <CustomDiv className='col col-class-calc-width'>
          {productDescriptionContent}
        </CustomDiv>
        <CustomDiv className='col' width={this.props.cols.arch.width} um={this.props.cols.arch.um} title={t('Architecture')}>{this.props.isFirstLevel ? this.props.item['arch'] : ''}</CustomDiv>
        <CustomDiv className='col text-center' width={this.props.cols.channels.width} um={this.props.cols.channels.um}>
          <ModalLink
              id='showChannels'
              icon='fa-list'
              title={t('Show product\'s channels')}
              target='show-channels-popup'
              onClick={() => this.props.showChannelsfor(this.props.item)}
          />
        </CustomDiv>
        {
          this.state.isInstalled ?
            <CustomDiv className='col text-right' width={this.props.cols.mix.width} um={this.props.cols.mix.um}>
              {channelSyncContent}&nbsp;{resyncActionContent}
            </CustomDiv>
            :
            <CustomDiv className='col text-right' width={this.props.cols.mix.width} um={this.props.cols.mix.um} title={t('With Recommended')}>
              {recommendedTogglerContent}
            </CustomDiv>
        }
        { this.isSublistVisible() ?
          <CheckList data={this.getNestedData()}
              nestedKey={this.props.nestedKey}
              isSelectable={this.props.isSelectable}
              selectedItems={this.props.selectedItems}
              handleSelectedItems={this.handleSelectedItems}
              handleUnselectedItems={this.handleUnselectedItems}
              listStyleClass={this.props.listStyleClass}
              isFirstLevel={false}
              showChannelsfor={this.props.showChannelsfor}
              childrenDisabled={!(this.state.isSelected || this.state.isInstalled)}
              cols={this.props.cols}
              resyncProduct={this.props.resyncProduct}
              syncingSingleProducts={this.props.syncingSingleProducts}
          />
          : null }
      </li>
    )
  }
});

ReactDOM.render(
  <ProductPageWrapper />,
  document.getElementById('products')
);
